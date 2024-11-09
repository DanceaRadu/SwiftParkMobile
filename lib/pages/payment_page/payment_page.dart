import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:swift_park/pages/payment_page/map_view.dart';
import 'package:swift_park/widgets/parking_sessions/parking_session_list.dart';

import '../../models/car_model.dart';
import '../../models/parking_session_model.dart';
import '../../providers/car_provider.dart';
import '../../providers/parking_lot_provider.dart';
import '../../models/parking_lot_model.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  ParkingLot? selectedParkingLot;

  onParkingLotSelected(ParkingLot parkingLot, List<Car> cars) {
    setState(() {
      selectedParkingLot = parkingLot;
    });
  }

  onPayForParkingSession(ParkingSession parkingSession) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    int price = 300;
    final response = await http.post(
      Uri.parse('https://getparkingsessionprice-qpdy2scqza-uc.a.run.app'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'parkingSessionId': parkingSession.id}),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      price = data['price'] * 10;
    }

    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('customers')
        .doc(currentUser.uid)
        .collection('checkout_sessions')
        .add({
      'mode': 'payment',
      'price': "price_1QHX2bRsAXq8UeQDCn1Y4Ic9",
      'client': 'mobile',
      'currency': 'usd',
      'amount': price,
      'parkingLotId': selectedParkingLot!.id,
      'licensePlate': parkingSession.licensePlate,
      'metadata': {
        'parkingSessionId': parkingSession.id,
      },
    });

    docRef.snapshots().listen((snapshot) async {
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('paymentIntentClientSecret') && data.containsKey('ephemeralKeySecret') && data.containsKey('customer')) {
          String clientSecret = data['paymentIntentClientSecret'];
          String clientEphemeralKey = data['ephemeralKeySecret'];
          String customerId = data['customer'];

          await startPaymentProcess(clientSecret, clientEphemeralKey, customerId);
          docRef.snapshots().listen(null).cancel();
        }
      }
    });
  }

  Future<void> startPaymentProcess(String clientSecret, String clientEphemeralKey, String customer) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: selectedParkingLot != null
              ? selectedParkingLot!.name
              : 'Swift.park',
          style: ThemeMode.system,
          allowsDelayedPaymentMethods: true,
          customerId: customer,
          customerEphemeralKeySecret: clientEphemeralKey,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      print('Payment completed successfully');
    } catch (e) {
      // Handle initialization errors
      print('Error initializing payment sheet: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Center(child: Text('No user is logged in.'));
    }

    final carsAsyncValue = ref.watch(userCarsProvider(currentUser.uid));
    final parkingLotAsyncValue = ref.watch(parkingLotProvider);

    return carsAsyncValue.when(
      data: (cars) => Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 350,
                child: MapView(
                  onMarkerSelected: (lot) => onParkingLotSelected(lot, cars),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: Text(
                  selectedParkingLot != null
                      ? selectedParkingLot!.name
                      : "Select a parking lot",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ParkingSessionList(
                onPay: onPayForParkingSession,
                parkingLotId: selectedParkingLot != null
                    ? selectedParkingLot!.id
                    : '-1',
                licencePlates: cars.map((car) => car.licensePlate).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      error: (error, stackTrace) {
        return Center(child: Text('Error: $error'));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
