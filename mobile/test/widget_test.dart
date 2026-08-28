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
import 'package:tailor_app/features/auth/application/auth_controller.dart';

void main() {
  testWidgets('entry illustration reveals the localized login form', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    await database.initialize();
    addTearDown(database.close);

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        secureStorageProvider.overrideWithValue(_FakeSecureStorageService()),
      ],
    );
    addTearDown(container.dispose);

    appRouter.go('/');
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const TailorApp()),
    );

    final illustration = find.byKey(const ValueKey('tailor-illustration'));
    expect(illustration, findsOneWidget);
    expect(find.byKey(const ValueKey('login-card')), findsNothing);

    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pump(const Duration(milliseconds: 720));

    final loginCard = find.byKey(const ValueKey('login-card'));
    expect(loginCard, findsOneWidget);
    expect(
      Theme.of(tester.element(loginCard)).textTheme.bodyMedium?.fontFamily,
      'Inter',
    );
    expect(
      find.byKey(const ValueKey('login-identifier-field')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('password-field')), findsOneWidget);
    expect(Directionality.of(tester.element(loginCard)), TextDirection.ltr);

    await tester.tap(find.byKey(const ValueKey('sign-in-button')));
    await tester.pump();
    expect(find.text('Enter your phone number'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('language-button')));
    await tester.pumpAndSettle();
    expect(
      Directionality.of(tester.element(find.text('English'))),
      TextDirection.ltr,
    );
    expect(
      Directionality.of(tester.element(find.text('اردو'))),
      TextDirection.ltr,
    );
    expect(
      Directionality.of(tester.element(find.text('Roman Urdu'))),
      TextDirection.ltr,
    );
    expect(
      tester.widget<Text>(find.text('English')).style?.fontFamily,
      'Inter',
    );
    expect(
      tester.widget<Text>(find.text('اردو')).style?.fontFamily,
      'NotoNaskhArabic',
    );
    expect(
      tester.widget<Text>(find.text('Roman Urdu')).style?.fontFamily,
      'Inter',
    );
    await tester.tap(find.text('اردو'));
    await tester.pumpAndSettle();
    expect(Directionality.of(tester.element(loginCard)), TextDirection.rtl);
    expect(
      Theme.of(tester.element(loginCard)).textTheme.bodyMedium?.fontFamily,
      'NotoNaskhArabic',
    );
    expect(find.text('اپنا فون نمبر درج کریں'), findsOneWidget);
    expect(find.text('Enter your phone number'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('language-button')));
    await tester.pumpAndSettle();
    expect(
      Directionality.of(tester.element(find.text('English'))),
      TextDirection.rtl,
    );
    expect(
      Directionality.of(tester.element(find.text('اردو'))),
      TextDirection.rtl,
    );
    expect(
      Directionality.of(tester.element(find.text('Roman Urdu'))),
      TextDirection.rtl,
    );
    await tester.tap(find.text('اردو'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('login-identifier-field')),
      '03001234567',
    );
    await tester.pump();
    expect(find.text('اپنا فون نمبر درج کریں'), findsNothing);

    await container.read(localeProvider.notifier).select(AppLocale.romanUrdu);
    await tester.pumpAndSettle();
    expect(Directionality.of(tester.element(loginCard)), TextDirection.ltr);
    expect(
      Theme.of(tester.element(loginCard)).textTheme.bodyMedium?.fontFamily,
      'Inter',
    );
  });

  testWidgets('stored access token bypasses login and opens dashboard', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final database = AppDatabase(NativeDatabase.memory());
    await database.initialize();
    addTearDown(database.close);

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        secureStorageProvider.overrideWithValue(
          _FakeSecureStorageService('existing-token'),
        ),
        authControllerProvider.overrideWith(_SignedInAuthController.new),
      ],
    );
    addTearDown(container.dispose);

    appRouter.go('/');
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const TailorApp()),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const ValueKey('dashboard-root')), findsOneWidget);
    expect(find.byKey(const ValueKey('login-card')), findsNothing);
    expect(find.text("Today's work"), findsOneWidget);
    expect(find.text('Quick actions'), findsOneWidget);
    expect(find.text('Recent orders'), findsOneWidget);

    await container.read(localeProvider.notifier).select(AppLocale.urdu);
    await tester.pump();
    expect(find.text('آج کا کام'), findsOneWidget);
    expect(find.text('فوری کام'), findsOneWidget);
  });

  test('Drift database initializes with its foundation table', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await database.initialize();
    expect(await database.select(database.appMetadata).get(), isEmpty);
  });

  test('locale selection is restored from local storage', () async {
    final database = AppDatabase(NativeDatabase.memory());
    await database.initialize();
    await database.writeMetadata('app_locale', 'urdu');
    addTearDown(database.close);

    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(database)],
    );
    addTearDown(container.dispose);

    container.read(localeProvider);
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(container.read(localeProvider), AppLocale.urdu);

    await container.read(localeProvider.notifier).select(AppLocale.romanUrdu);
    expect(await database.readMetadata('app_locale'), 'romanUrdu');
  });
}

class _SignedInAuthController extends AuthController {
  @override
  Future<AuthState> build() async => const SignedIn();
}

class _FakeSecureStorageService extends SecureStorageService {
  const _FakeSecureStorageService([this.token])
    : super(const FlutterSecureStorage());

  final String? token;

  @override
  Future<String?> readAccessToken() async => token;
}
