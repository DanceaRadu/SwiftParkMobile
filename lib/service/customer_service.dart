import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomerService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<dynamic>?> fetchDataForCustomer() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        print("User is not logged in");
        throw Exception("User is not logged in");
      }

      DocumentSnapshot<Map<String, dynamic>> customerDoc = await _firestore
          .collection('customers')
          .doc(user.uid)
          .get();

      String? stripeCustomerId = customerDoc.data()?['stripeId'];
      if (stripeCustomerId == null) {
        print("stripeCustomerId does not exist in customer document");
        return [];
      }

      final response = await http.post(
        Uri.parse("https://listpaymentmethods-qpdy2scqza-uc.a.run.app"),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "customerId": stripeCustomerId,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // Access the 'paymentMethods' property directly
        return responseBody['paymentMethods'] as List<dynamic>;
      } else {
        print("Error fetching customer data: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching customer data: $e");
      return [];
    }
  }
}
