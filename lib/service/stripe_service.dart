import 'package:cloud_functions/cloud_functions.dart';

Future<String> createPaymentIntent(int amount, String currency) async {
  final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createPaymentIntent');
  final response = await callable.call(<String, dynamic>{
    'amount': amount,
    'currency': currency,
  });
  return response.data['clientSecret'];
}