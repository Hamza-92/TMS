import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor_app/core/database/app_database.dart';
import 'package:tailor_app/features/auth/data/auth_models.dart';
import 'package:tailor_app/features/auth/data/auth_session_store.dart';

void main() {
  test('auth bootstrap is cached with the selected business', () async {
    final database = AppDatabase(NativeDatabase.memory());
    await database.initialize();
    addTearDown(database.close);
    final store = AuthSessionStore(database);
    final session = _session();

    await store.write(session);
    final restored = await store.read();

    expect(restored?.user.name, 'Ayesha Khan');
    expect(restored?.selectedBusiness?.name, 'Ayesha Tailors');
    expect(restored?.selectedBusiness?.subscription?.planCode, 'demo');
    expect(restored?.selectedBusiness?.role, 'owner');

    await store.clear();
    expect(await store.read(), isNull);
  });

  test('cached access expires locally after the offline grace boundary', () {
    final now = DateTime.now();
    final business = _business(
      expiresAt: now.subtract(const Duration(minutes: 5)),
      offlineGraceUntil: now.add(const Duration(days: 2)),
    );

    expect(business.canUseAppAt(now), isTrue);
    expect(business.requiresOnlineVerificationAt(now), isTrue);
    expect(business.canUseAppAt(now.add(const Duration(days: 3))), isFalse);
  });
}

AuthSessionSnapshot _session() {
  final now = DateTime.now();
  return AuthSessionSnapshot(
    user: const AuthUser(
      id: '01HUSER0000000000000000000',
      name: 'Ayesha Khan',
      phoneE164: '+923001234567',
      preferredLocale: 'en',
    ),
    businesses: [
      _business(
        expiresAt: now.add(const Duration(days: 14)),
        offlineGraceUntil: now.add(const Duration(days: 17)),
      ),
    ],
    selectedBusinessId: '01HBUSINESS00000000000000',
    syncedAt: now,
  );
}

AuthBusiness _business({
  required DateTime expiresAt,
  required DateTime offlineGraceUntil,
}) {
  return AuthBusiness(
    id: '01HBUSINESS00000000000000',
    name: 'Ayesha Tailors',
    role: 'owner',
    membershipStatus: 'active',
    businessStatus: 'active',
    countryCode: 'PK',
    currencyCode: 'PKR',
    timezone: 'Asia/Karachi',
    preferredLocale: 'en',
    subscription: AuthSubscription(
      id: '01HSUBSCRIPTION00000000000',
      planCode: 'demo',
      source: 'trial',
      status: 'trialing',
      startsAt: expiresAt.subtract(const Duration(days: 14)),
      expiresAt: expiresAt,
      offlineGraceUntil: offlineGraceUntil,
    ),
    access: AuthBusinessAccess(
      state: 'active',
      canUseApp: true,
      onlineVerificationRequired: false,
      validUntil: expiresAt,
    ),
  );
}
