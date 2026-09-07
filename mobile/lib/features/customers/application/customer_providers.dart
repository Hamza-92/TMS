import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/features/customers/data/customer_repository.dart';
import 'package:tailor_app/features/customers/domain/customer.dart';

final customersProvider = StreamProvider.autoDispose
    .family<List<CustomerRecord>, String>(
      (ref, businessId) =>
          ref.watch(customerRepositoryProvider).watchAll(businessId),
    );

class CustomerKey {
  const CustomerKey(this.businessId, this.clientUuid);

  final String businessId;
  final String clientUuid;

  @override
  bool operator ==(Object other) =>
      other is CustomerKey &&
      other.businessId == businessId &&
      other.clientUuid == clientUuid;

  @override
  int get hashCode => Object.hash(businessId, clientUuid);
}

final customerProvider = StreamProvider.autoDispose
    .family<CustomerRecord?, CustomerKey>(
      (ref, key) => ref
          .watch(customerRepositoryProvider)
          .watchOne(key.businessId, key.clientUuid),
    );
