import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swift_park/color_palette.dart';
import 'package:swift_park/providers/customer_id_provider.dart';

class PaymentMethods extends ConsumerWidget {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerDataAsync = ref.watch(customerDataProvider);

    return customerDataAsync.when(
      data: (customerData) {
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
          child: Column(
            children: customerData!.map<Widget>((paymentMethod) {
              String brand = paymentMethod['card']['brand'].toString().toLowerCase();
              String cardLast4 = paymentMethod['card']['last4'];
              int expMonth = paymentMethod['card']['exp_month'];
              int expYear = paymentMethod['card']['exp_year'];

              String iconAsset = '';
              if (brand == 'visa') {
                iconAsset = 'assets/images/visa.png';
              } else if (brand == 'mastercard') {
                iconAsset = 'assets/images/mastercard.png';
              }

              return Card(
                color: ColorPalette.darkerSurface,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(
                    leading: iconAsset.isNotEmpty
                        ? Image.asset(iconAsset, width: 40)
                        : null,
                    title: Text(
                      brand.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('$expMonth/$expYear'),
                    trailing: Text(
                      '**** **** **** $cardLast4',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text('Error: $error'));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
