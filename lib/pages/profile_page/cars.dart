import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/car_provider.dart';

class Cars extends ConsumerWidget {
  const Cars({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text('No user is logged in.'));
    }

    final carsAsyncValue = ref.watch(userCarsProvider(currentUser.uid));
    final deleteCar = ref.read(deleteCarProvider);

    return carsAsyncValue.when(
      data: (carList) => carList.isEmpty
          ? const Center(child: Text('No cars added.'))
          : ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: carList.length,
        itemBuilder: (context, index) {
          final car = carList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Dismissible(
              key: Key(car.id.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) async {
                // Delete the car using deleteCarProvider
                await deleteCar(car.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${car.licensePlate} deleted')),
                );
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                elevation: 3,
                child: ListTile(
                  leading: const Icon(Icons.directions_car),
                  title: Text(car.licensePlate),
                  subtitle: Text(car.name),
                ),
              ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}

