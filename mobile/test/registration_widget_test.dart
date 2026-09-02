import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tailor_app/app/app.dart';
import 'package:tailor_app/app/router.dart';
import 'package:tailor_app/core/database/app_database.dart';
import 'package:tailor_app/core/database/database_provider.dart';
import 'package:tailor_app/core/localization/app_locale.dart';
import 'package:tailor_app/core/storage/secure_storage_service.dart';
import 'package:tailor_app/features/auth/data/auth_models.dart';

void main() {
  testWidgets('registration uses clear field-specific validation', (
    tester,
  ) async {
    final harness = await _pumpAppAt(tester, '/register');
    addTearDown(harness.dispose);

    final name = find.byKey(const ValueKey('registration-name-field'));
    final business = find.byKey(const ValueKey('registration-business-field'));
    final phone = find.byKey(const ValueKey('registration-phone-field'));
    final password = find.byKey(const ValueKey('registration-password-field'));
    final confirmation = find.byKey(
      const ValueKey('registration-confirm-password-field'),
    );
    final action = find.byKey(const ValueKey('registration-continue-button'));

    expect(find.byKey(const ValueKey('auth-header')), findsOneWidget);
    expect(tester.getTopLeft(name).dy, 366);
    expect(name, findsOneWidget);
    expect(business, findsOneWidget);
    expect(phone, findsOneWidget);
    expect(password, findsOneWidget);
    expect(confirmation, findsOneWidget);

    await tester.ensureVisible(action);
    await tester.tap(action);
    await tester.pump();

    expect(_errorText(tester, name), 'Enter your full name');
    expect(_errorText(tester, business), 'Enter your business name');
    expect(_errorText(tester, phone), 'Enter your phone number');
    expect(_errorText(tester, password), 'Enter your password');
    expect(_errorText(tester, confirmation), 'Confirm your new password');

    await tester.enterText(name, 'A');
    await tester.pump();
    expect(
      _errorText(tester, name),
      'Enter at least 2 characters for your name',
    );
    await tester.enterText(name, 'Ayesha Khan');
    await tester.enterText(business, 'Ayesha Tailors');
    await tester.enterText(phone, '03001234567');
    await tester.enterText(password, 'Tailor123');
    await tester.enterText(confirmation, 'Tailor124');
    await tester.pump();

    expect(_errorText(tester, confirmation), 'Passwords do not match');
    await tester.enterText(confirmation, 'Tailor123');
    await tester.pump();

    expect(_errorText(tester, name), isNull);
    expect(_errorText(tester, business), isNull);
    expect(_errorText(tester, phone), isNull);
    expect(_errorText(tester, password), isNull);
    expect(_errorText(tester, confirmation), isNull);
  });

  testWidgets('registration action remains reachable with a compact keyboard', (
    tester,
  ) async {
    final harness = await _pumpAppAt(
      tester,
      '/register',
      size: const Size(320, 568),
      keyboardHeight: 240,
    );
    addTearDown(harness.dispose);

    final action = find.byKey(const ValueKey('registration-continue-button'));
    expect(find.byKey(const ValueKey('auth-flow-scroll')), findsOneWidget);

    await tester.ensureVisible(action);
    await tester.pumpAndSettle();
    expect(tester.getBottomRight(action).dy, lessThanOrEqualTo(328));
  });

  testWidgets('registration OTP uses the shared six-cell verification design', (
    tester,
  ) async {
    final now = DateTime.now();
    final draft = RegistrationDraft(
      challengeId: '01H00000000000000000000000',
      name: 'Ayesha Khan',
      businessName: 'Ayesha Tailors',
      phoneE164: '+923001234567',
      password: 'Tailor123',
      preferredLocale: 'en',
      installationUuid: '11111111-1111-4111-8111-111111111111',
      expiresAt: now.add(const Duration(minutes: 5)),
      resendAt: now.add(const Duration(seconds: 60)),
    );
    final harness = await _pumpAppAt(tester, '/register/otp', extra: draft);
    addTearDown(harness.dispose);

    final otp = find.byKey(const ValueKey('registration-otp-field'));
    final verify = find.byKey(const ValueKey('registration-verify-button'));
    expect(otp, findsOneWidget);
    expect(find.textContaining('+923001234567'), findsOneWidget);
    expect(find.text('Verify & create account'), findsOneWidget);
    expect(find.textContaining('Resend in '), findsOneWidget);

    await tester.tap(verify);
    await tester.pump();
    expect(find.text('Enter the complete 6-digit code'), findsOneWidget);

    final hiddenInput = find.descendant(
      of: otp,
      matching: find.byType(TextField),
    );
    await tester.enterText(hiddenInput, '123456');
    await tester.pump();
    expect(find.text('Enter the complete 6-digit code'), findsNothing);
  });
}

Future<_TestHarness> _pumpAppAt(
  WidgetTester tester,
  String location, {
  Object? extra,
  Size size = const Size(360, 800),
  double keyboardHeight = 0,
}) async {
  await tester.binding.setSurfaceSize(size);
  final pixelRatio = tester.view.devicePixelRatio;
  tester.view.padding = FakeViewPadding(top: 24 * pixelRatio);
  tester.view.viewPadding = FakeViewPadding(top: 24 * pixelRatio);
  if (keyboardHeight > 0) {
    tester.view.viewInsets = FakeViewPadding(
      bottom: keyboardHeight * pixelRatio,
    );
  }

  final database = AppDatabase(NativeDatabase.memory());
  await database.initialize();
  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
      secureStorageProvider.overrideWithValue(
        const _FakeSecureStorageService(),
      ),
    ],
  );
  await container.read(localeProvider.notifier).select(AppLocale.english);

  appRouter.go(location, extra: extra);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const TailorApp()),
  );
  await tester.pumpAndSettle();

  return _TestHarness(tester, container, database);
}

class _TestHarness {
  const _TestHarness(this.tester, this.container, this.database);

  final WidgetTester tester;
  final ProviderContainer container;
  final AppDatabase database;

  Future<void> dispose() async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.binding.setSurfaceSize(null);
    tester.view.resetPadding();
    tester.view.resetViewPadding();
    tester.view.resetViewInsets();
    container.dispose();
    await database.close();
  }
}

class _FakeSecureStorageService extends SecureStorageService {
  const _FakeSecureStorageService() : super(const FlutterSecureStorage());

  @override
  Future<String?> readAccessToken() async => null;
}

String? _errorText(WidgetTester tester, Finder field) {
  final decorator = find.descendant(
    of: field,
    matching: find.byType(InputDecorator),
  );
  return tester.widget<InputDecorator>(decorator).decoration.errorText;
}
