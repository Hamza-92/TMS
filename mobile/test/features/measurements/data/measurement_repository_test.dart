import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor_app/core/database/app_database.dart';
import 'package:tailor_app/features/measurements/data/measurement_repository.dart';
import 'package:tailor_app/features/measurements/domain/measurement.dart';

void main() {
  late AppDatabase database;
  late MeasurementRepository repository;
  late int uuidSequence;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    await database.initialize();
    uuidSequence = 0;
    repository = MeasurementRepository(
      database,
      Dio(),
      () =>
          '00000000-0000-4000-8000-${(++uuidSequence).toString().padLeft(12, '0')}',
    );
  });

  tearDown(() => database.close());

  test('new profile and first revision are available before sync', () async {
    const businessId = '01HBUSINESS00000000000000';
    const customerUuid = '00000000-0000-4000-8000-000000000101';
    const templateUuid = '00000000-0000-4000-8000-000000000201';
    const fieldUuid = '00000000-0000-4000-8000-000000000301';

    final profile = await repository.saveProfile(
      businessId: businessId,
      customerClientUuid: customerUuid,
      draft: const MeasurementProfileDraft(
        templateClientUuid: templateUuid,
        templateDefinitionVersion: 1,
        name: 'Regular Shalwar Kameez',
        preferredUnit: 'inch',
      ),
    );
    await repository.addRevision(
      profile: profile,
      values: const [
        MeasurementValueDraft(fieldUuid: fieldUuid, value: 40.25, unit: 'inch'),
      ],
      measuredAt: DateTime(2026, 9, 9),
    );

    final profiles = await repository
        .watchProfiles(businessId, customerUuid)
        .first;
    final revisions = await repository
        .watchRevisions(businessId, profile.clientUuid)
        .first;

    expect(profiles, hasLength(1));
    expect(profiles.single.latestRevisionNumber, 1);
    expect(profiles.single.syncState, MeasurementSyncState.pending);
    expect(revisions, hasLength(1));
    expect(revisions.single.values.single['value'], 40.25);
    expect(await repository.pendingCount(businessId, customerUuid), 2);
  });

  test('measurement streams remain isolated by customer', () async {
    const businessId = '01HBUSINESS00000000000000';
    const firstCustomer = '00000000-0000-4000-8000-000000000101';
    const secondCustomer = '00000000-0000-4000-8000-000000000102';

    await repository.saveProfile(
      businessId: businessId,
      customerClientUuid: firstCustomer,
      draft: const MeasurementProfileDraft(
        templateClientUuid: 'template-one',
        templateDefinitionVersion: 1,
        name: 'First profile',
        preferredUnit: 'inch',
      ),
    );
    await repository.saveProfile(
      businessId: businessId,
      customerClientUuid: secondCustomer,
      draft: const MeasurementProfileDraft(
        templateClientUuid: 'template-two',
        templateDefinitionVersion: 1,
        name: 'Second profile',
        preferredUnit: 'cm',
      ),
    );

    final profiles = await repository
        .watchProfiles(businessId, firstCustomer)
        .first;

    expect(profiles, hasLength(1));
    expect(profiles.single.name, 'First profile');
  });
}
