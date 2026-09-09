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

  test('a new measurement creates immutable revision history', () async {
    const businessId = '01HBUSINESS00000000000000';
    const customerUuid = '00000000-0000-4000-8000-000000000101';
    const fieldUuid = '00000000-0000-4000-8000-000000000301';
    final profile = await repository.saveProfile(
      businessId: businessId,
      customerClientUuid: customerUuid,
      draft: const MeasurementProfileDraft(
        templateClientUuid: 'template-one',
        templateDefinitionVersion: 1,
        name: 'Regular fitting',
        preferredUnit: 'inch',
      ),
    );
    await repository.addRevision(
      profile: profile,
      values: const [
        MeasurementValueDraft(fieldUuid: fieldUuid, value: 40, unit: 'inch'),
      ],
      measuredAt: DateTime(2026, 9, 1),
    );
    final updatedProfile = (await repository
        .watchProfile(businessId, profile.clientUuid)
        .first)!;

    await repository.addRevision(
      profile: updatedProfile,
      values: const [
        MeasurementValueDraft(fieldUuid: fieldUuid, value: 41, unit: 'inch'),
      ],
      measuredAt: DateTime(2026, 9, 9),
    );

    final revisions = await repository
        .watchRevisions(businessId, profile.clientUuid)
        .first;
    expect(revisions, hasLength(2));
    expect(revisions[0].revisionNumber, 2);
    expect(revisions[0].values.single['value'], 41);
    expect(revisions[1].revisionNumber, 1);
    expect(revisions[1].values.single['value'], 40);
    expect(await repository.pendingCount(businessId, customerUuid), 3);
  });

  test(
    'business template is available offline before synchronization',
    () async {
      const businessId = '01HBUSINESS00000000000000';
      const fieldUuid = '00000000-0000-4000-8000-000000000301';

      final template = await repository.saveTemplate(
        businessId: businessId,
        draft: const MeasurementTemplateDraft(
          name: 'Custom coat',
          category: 'coat',
          defaultUnit: 'inch',
          fields: [
            MeasurementFieldDefinition(
              clientUuid: fieldUuid,
              key: 'coat_length',
              label: 'Coat length',
              labelUr: 'کوٹ کی لمبائی',
              labelRomanUr: 'Coat ki lambai',
              section: 'garment',
              valueType: 'number',
              unitType: 'length',
              isRequired: true,
              sortOrder: 0,
            ),
          ],
        ),
      );

      final templates = await repository.watchTemplates(businessId).first;
      final queued = await database
          .select(database.measurementTemplateSyncOperations)
          .get();

      expect(template.source, 'business');
      expect(template.syncState, MeasurementSyncState.pending);
      expect(templates.single.fields.single.labelUr, 'کوٹ کی لمبائی');
      expect(queued, hasLength(1));
    },
  );

  test(
    'customer-only fields are retained in profile and revision history',
    () async {
      const businessId = '01HBUSINESS00000000000000';
      const customerUuid = '00000000-0000-4000-8000-000000000101';
      const customFieldUuid = '00000000-0000-4000-8000-000000000401';
      const customField = MeasurementFieldDefinition(
        clientUuid: customFieldUuid,
        key: 'special_note',
        label: 'Special note',
        labelUr: 'خصوصی نوٹ',
        labelRomanUr: 'Khaas note',
        section: 'custom',
        valueType: 'text',
        unitType: 'none',
        isRequired: false,
        sortOrder: 100,
      );

      final profile = await repository.saveProfile(
        businessId: businessId,
        customerClientUuid: customerUuid,
        draft: const MeasurementProfileDraft(
          templateClientUuid: 'template-one',
          templateDefinitionVersion: 1,
          name: 'Customer fitting',
          preferredUnit: 'inch',
          customFields: [customField],
        ),
      );
      await repository.addRevision(
        profile: profile,
        values: const [
          MeasurementValueDraft(
            fieldUuid: customFieldUuid,
            value: 'Keep loose',
          ),
        ],
        measuredAt: DateTime(2026, 9, 9),
      );

      final storedProfile = (await repository
          .watchProfile(businessId, profile.clientUuid)
          .first)!;
      final revision =
          (await repository
                  .watchRevisions(businessId, profile.clientUuid)
                  .first)
              .single;

      expect(storedProfile.customFields.single.labelUr, 'خصوصی نوٹ');
      expect(revision.customFields.single.clientUuid, customFieldUuid);
      expect(revision.values.single['value'], 'Keep loose');
    },
  );
}
