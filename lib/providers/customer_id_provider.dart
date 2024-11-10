import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swift_park/service/customer_service.dart';

final customerServiceProvider = Provider((ref) => CustomerService());

final customerDataProvider = FutureProvider<List<dynamic>?>((ref) async {
  final customerService = ref.watch(customerServiceProvider);
  return await customerService.fetchDataForCustomer();
});