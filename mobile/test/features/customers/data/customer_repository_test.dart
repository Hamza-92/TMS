import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor_app/core/database/app_database.dart';
import 'package:tailor_app/features/customers/data/customer_repository.dart';
import 'package:tailor_app/features/customers/domain/customer.dart';

void main() {
  late AppDatabase database;
  late CustomerRepository repository;
  late int uuidSequence;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    await database.initialize();
    uuidSequence = 0;
    repository = CustomerRepository(
      database,
      Dio(),
      () =>
          '00000000-0000-4000-8000-${(++uuidSequence).toString().padLeft(12, '0')}',
    );
  });

  tearDown(() => database.close());

  test(
    'offline customer edits are consolidated into one pending upsert',
    () async {
      const businessId = '01HBUSINESS00000000000000';
      final created = await repository.save(
        businessId: businessId,
        draft: const CustomerDraft(
          name: 'Ayesha Khan',
          phoneE164: '+923001234567',
        ),
      );

      expect(created.serverVersion, 0);
      expect(created.syncState, CustomerSyncState.pending);
      expect(await repository.pendingCount(businessId), 1);

      final edited = await repository.save(
        businessId: businessId,
        existing: created,
        draft: const CustomerDraft(
          name: 'Ayesha Ahmed',
          phoneE164: '+923001234567',
          notes: 'Prefers WhatsApp updates.',
        ),
      );

      expect(edited.clientUuid, created.clientUuid);
      expect(edited.name, 'Ayesha Ahmed');
      expect(edited.notes, 'Prefers WhatsApp updates.');
      expect(await repository.pendingCount(businessId), 1);
    },
  );

  test(
    'archiving a never-synced customer removes its local operation',
    () async {
      const businessId = '01HBUSINESS00000000000000';
      final customer = await repository.save(
        businessId: businessId,
        draft: const CustomerDraft(name: 'Temporary Customer'),
      );

      await repository.archive(customer);

      expect(await repository.pendingCount(businessId), 0);
      expect(
        await repository.watchOne(businessId, customer.clientUuid).first,
        isNull,
      );
    },
  );

  test('customer stream is isolated by business', () async {
    await repository.save(
      businessId: 'business-one',
      draft: const CustomerDraft(name: 'First Customer'),
    );
    await repository.save(
      businessId: 'business-two',
      draft: const CustomerDraft(name: 'Second Customer'),
    );

    final customers = await repository.watchAll('business-one').first;

    expect(customers, hasLength(1));
    expect(customers.single.name, 'First Customer');
  });
}
