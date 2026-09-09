import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/features/measurements/data/measurement_repository.dart';
import 'package:tailor_app/features/measurements/domain/measurement.dart';

class CustomerMeasurementKey {
  const CustomerMeasurementKey(this.businessId, this.customerClientUuid);

  final String businessId;
  final String customerClientUuid;

  @override
  bool operator ==(Object other) =>
      other is CustomerMeasurementKey &&
      other.businessId == businessId &&
      other.customerClientUuid == customerClientUuid;

  @override
  int get hashCode => Object.hash(businessId, customerClientUuid);
}

class MeasurementProfileKey {
  const MeasurementProfileKey(this.businessId, this.profileClientUuid);

  final String businessId;
  final String profileClientUuid;

  @override
  bool operator ==(Object other) =>
      other is MeasurementProfileKey &&
      other.businessId == businessId &&
      other.profileClientUuid == profileClientUuid;

  @override
  int get hashCode => Object.hash(businessId, profileClientUuid);
}

final measurementTemplatesProvider = StreamProvider.autoDispose
    .family<List<MeasurementTemplateRecord>, String>(
      (ref, businessId) =>
          ref.watch(measurementRepositoryProvider).watchTemplates(businessId),
    );

final measurementProfilesProvider = StreamProvider.autoDispose
    .family<List<MeasurementProfileRecord>, CustomerMeasurementKey>(
      (ref, key) => ref
          .watch(measurementRepositoryProvider)
          .watchProfiles(key.businessId, key.customerClientUuid),
    );

final measurementProfileProvider = StreamProvider.autoDispose
    .family<MeasurementProfileRecord?, MeasurementProfileKey>(
      (ref, key) => ref
          .watch(measurementRepositoryProvider)
          .watchProfile(key.businessId, key.profileClientUuid),
    );

final measurementRevisionsProvider = StreamProvider.autoDispose
    .family<List<MeasurementRevisionRecord>, MeasurementProfileKey>(
      (ref, key) => ref
          .watch(measurementRepositoryProvider)
          .watchRevisions(key.businessId, key.profileClientUuid),
    );
