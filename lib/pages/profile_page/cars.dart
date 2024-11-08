import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swift_park/color_palette.dart';
import 'package:swift_park/widgets/main_text_field.dart';

import '../../models/car_model.dart';
import '../../providers/car_provider.dart';

class Cars extends ConsumerStatefulWidget {
  const Cars({super.key});
  @override
  CarsState createState() => CarsState();
}

class CarsState extends ConsumerState<Cars> {

  void handleAddingCar() async {

    final addCar = ref.read(addCarProvider);
    final currentUser = FirebaseAuth.instance.currentUser;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final carNameController = TextEditingController();
        final licensePlateController = TextEditingController();
        final _formKey = GlobalKey<FormState>();

        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add New Car",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              MainTextField(labelText: "Hello"),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    MainTextField(
                        labelText: "Car Name",
                        controller: carNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the car name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    MainTextField(
                      labelText: "License Plate",
                      controller: licensePlateController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the plate number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Validate form fields before submitting
                      if (_formKey.currentState?.validate() ?? false) {
                        // Add car using provider
                        addCar(
                          currentUser!.uid,
                          Car(
                            userId: currentUser.uid,
                            name: carNameController.text,
                            licensePlate: licensePlateController.text,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text('No user is logged in.'));
    }

    final carsAsyncValue = ref.watch(userCarsProvider(currentUser.uid));
    final deleteCar = ref.read(deleteCarProvider);
    final addCar = ref.read(addCarProvider);

    return carsAsyncValue.when(
      data: (carList) => carList.isEmpty
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("No cars found."),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: handleAddingCar,
            child: const Row(
              mainAxisSize: MainAxisSize.min, // Ensures the button only takes as much space as needed
              children: [
                Icon(Icons.add),
                SizedBox(width: 8),
                Text("Add Car"),
              ],
            ),
          )
        ],
      )
          : Column(
        children: [
          ElevatedButton(
            onPressed: handleAddingCar,
            child: const Row(
              mainAxisSize: MainAxisSize.min, // Ensures the button only takes as much space as needed
              children: [
                Icon(Icons.add), // Add the plus icon
                SizedBox(width: 8), // Add some space between the icon and the text
                Text("Add Car"),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
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
                    await deleteCar(car.id!);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${car.licensePlate} deleted')),
                    );
                  },
                  background: Container(
                    color: ColorPalette.error,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      leading: const Icon(Icons.directions_car),
                      title: Text(
                        car.licensePlate,
                        style: const TextStyle(color: ColorPalette.backgroundColor),
                      ),
                      subtitle: Text(
                        car.name,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
