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
import 'package:tailor_app/features/auth/data/auth_models.dart';

void main() {
  testWidgets('splash opens the localized phone-first login flow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final physicalStatusBarInset = 24 * tester.view.devicePixelRatio;
    tester.view.padding = FakeViewPadding(top: physicalStatusBarInset);
    tester.view.viewPadding = FakeViewPadding(top: physicalStatusBarInset);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.view.resetViewPadding);

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

    expect(find.byKey(const ValueKey('splash-root')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash-mark')), findsOneWidget);
    expect(find.byKey(const ValueKey('welcome-root')), findsNothing);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    final welcome = find.byKey(const ValueKey('welcome-root'));
    expect(welcome, findsOneWidget);
    final welcomeLanguage = find.byKey(const ValueKey('language-button'));
    expect(tester.getTopLeft(welcomeLanguage).dy, 26);
    final createAccount = find.byKey(const ValueKey('welcome-create-account'));
    expect(createAccount, findsOneWidget);
    expect(tester.getBottomRight(createAccount).dy, lessThan(640));
    expect(
      find.descendant(of: welcome, matching: find.byType(Scrollable)),
      findsNothing,
    );
    expect(
      Theme.of(tester.element(welcome)).textTheme.bodyMedium?.fontFamily,
      'PlusJakartaSans',
    );

    await tester.tap(find.byKey(const ValueKey('welcome-login-button')));
    await tester.pumpAndSettle();
    final phoneField = find.byKey(const ValueKey('login-phone-field'));
    expect(phoneField, findsOneWidget);
    final authHeader = find.byKey(const ValueKey('auth-header'));
    final authTitle = find.byKey(const ValueKey('auth-header-title'));
    final authBadge = find.byKey(const ValueKey('auth-header-badge'));
    final authScroll = find.byKey(const ValueKey('auth-flow-scroll'));
    final authBack = find.byKey(const ValueKey('auth-back-button'));
    final authLanguage = find.byKey(const ValueKey('language-button'));
    expect(tester.getSize(authHeader).height, 266);
    expect(tester.getTopLeft(authBack).dy, 26);
    expect(tester.getTopLeft(authLanguage).dy, 26);
    expect(tester.getTopLeft(authTitle).dy, 136);
    expect(tester.getSize(authTitle).height, lessThan(35));
    expect(tester.getTopLeft(authBadge).dy, 216);
    expect(tester.getTopLeft(phoneField).dy, 366);
    expect(
      find.descendant(of: authScroll, matching: authHeader),
      findsOneWidget,
    );
    expect(
      find.descendant(of: authScroll, matching: phoneField),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('login-phone-continue')));
    await tester.pumpAndSettle();
    expect(find.text('Enter your phone number'), findsOneWidget);

    await tester.enterText(phoneField, '123');
    await tester.pump();
    expect(
      find.text('Enter a valid number, for example +92 300 1234567'),
      findsOneWidget,
    );

    await tester.enterText(phoneField, '03001234567');
    await tester.pump();
    expect(find.text('Enter your phone number'), findsNothing);
    expect(
      find.text('Enter a valid number, for example +92 300 1234567'),
      findsNothing,
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('language-button')));
    await tester.pumpAndSettle();
    const urduLabel = '\u0627\u0631\u062f\u0648';
    expect(
      Directionality.of(tester.element(find.text('English'))),
      TextDirection.ltr,
    );
    expect(
      Directionality.of(tester.element(find.text(urduLabel))),
      TextDirection.ltr,
    );
    expect(
      Directionality.of(tester.element(find.text('Roman Urdu'))),
      TextDirection.ltr,
    );
    expect(
      tester.widget<Text>(find.text('English')).style?.fontFamily,
      'PlusJakartaSans',
    );
    expect(
      tester.widget<Text>(find.text(urduLabel)).style?.fontFamily,
      'NotoNaskhArabic',
    );
    expect(
      tester.widget<Text>(find.text('Roman Urdu')).style?.fontFamily,
      'PlusJakartaSans',
    );

    await tester.tap(find.text(urduLabel));
    await tester.pumpAndSettle();
    expect(Directionality.of(tester.element(phoneField)), TextDirection.rtl);
    expect(
      Theme.of(tester.element(phoneField)).textTheme.bodyMedium?.fontFamily,
      'NotoNaskhArabic',
    );
    expect(find.text('Enter your phone number'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('language-button')));
    await tester.pumpAndSettle();
    expect(
      Directionality.of(tester.element(find.text('English'))),
      TextDirection.rtl,
    );
    expect(
      Directionality.of(tester.element(find.text(urduLabel))),
      TextDirection.rtl,
    );
    expect(
      Directionality.of(tester.element(find.text('Roman Urdu'))),
      TextDirection.rtl,
    );
    await tester.tap(find.text(urduLabel));
    await tester.pumpAndSettle();

    await container.read(localeProvider.notifier).select(AppLocale.romanUrdu);
    await tester.pumpAndSettle();
    expect(Directionality.of(tester.element(phoneField)), TextDirection.ltr);
    expect(
      Theme.of(tester.element(phoneField)).textTheme.bodyMedium?.fontFamily,
      'PlusJakartaSans',
    );

    await tester.enterText(phoneField, '03001234567');
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('login-phone-continue')));
    await tester.pumpAndSettle();

    final passwordField = find.byKey(const ValueKey('login-password-field'));
    expect(passwordField, findsOneWidget);
    expect(find.textContaining('+923001234567'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('login-submit-button')));
    await tester.pump();
    final passwordDecorator = find.descendant(
      of: passwordField,
      matching: find.byType(InputDecorator),
    );
    expect(
      tester.widget<InputDecorator>(passwordDecorator).decoration.errorText,
      'Apna password likhein',
    );

    await tester.enterText(passwordField, 'password');
    await tester.pump();
    expect(
      tester.widget<InputDecorator>(passwordDecorator).decoration.errorText,
      isNull,
    );

    await tester.tap(find.byKey(const ValueKey('login-forgot-password')));
    await tester.pumpAndSettle();
    final forgotPhone = find.byKey(const ValueKey('forgot-phone-field'));
    expect(forgotPhone, findsOneWidget);
    expect(
      tester.widget<TextFormField>(forgotPhone).controller?.text,
      '+923001234567',
    );
    final forgotSubtitle = find.byKey(const ValueKey('auth-header-subtitle'));
    expect(tester.getBottomRight(forgotSubtitle).dy, lessThan(216));
  });

  testWidgets('new password errors are specific and clear while editing', (
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
        secureStorageProvider.overrideWithValue(_FakeSecureStorageService()),
      ],
    );
    addTearDown(container.dispose);

    await container.read(localeProvider.notifier).select(AppLocale.english);
    appRouter.go(
      '/forgot-password/reset',
      extra: const PasswordResetDraft(
        challengeId: '01H00000000000000000000000',
        resetToken:
            '0000000000000000000000000000000000000000000000000000000000000000',
      ),
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const TailorApp()),
    );
    await tester.pumpAndSettle();

    final password = find.byKey(const ValueKey('reset-password-field'));
    final confirmation = find.byKey(
      const ValueKey('reset-confirm-password-field'),
    );
    expect(password, findsOneWidget);
    expect(confirmation, findsOneWidget);

    await tester.enterText(password, 'short');
    await tester.pump();
    expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    expect(find.text('Confirm your new password'), findsNothing);

    await tester.enterText(password, 'abcdefgh');
    await tester.pump();
    expect(
      find.text('Include at least one letter and one number'),
      findsOneWidget,
    );

    await tester.enterText(password, 'abcd1234');
    await tester.pump();
    expect(find.text('Password must be at least 8 characters'), findsNothing);
    expect(
      find.text('Include at least one letter and one number'),
      findsNothing,
    );

    await tester.enterText(confirmation, 'abcd123');
    await tester.pump();
    expect(find.text('Passwords do not match'), findsOneWidget);

    await tester.enterText(confirmation, 'abcd1234');
    await tester.pump();
    expect(find.text('Passwords do not match'), findsNothing);
  });

  testWidgets(
    'auth actions remain reachable on a compact phone with keyboard',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final pixelRatio = tester.view.devicePixelRatio;
      tester.view.padding = FakeViewPadding(top: 24 * pixelRatio);
      tester.view.viewPadding = FakeViewPadding(top: 24 * pixelRatio);
      tester.view.viewInsets = FakeViewPadding(bottom: 240 * pixelRatio);
      addTearDown(tester.view.resetPadding);
      addTearDown(tester.view.resetViewPadding);
      addTearDown(tester.view.resetViewInsets);

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

      await container.read(localeProvider.notifier).select(AppLocale.english);
      appRouter.go('/login/phone');
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const TailorApp(),
        ),
      );
      await tester.pumpAndSettle();

      final action = find.byKey(const ValueKey('login-phone-continue'));
      expect(find.byKey(const ValueKey('auth-flow-scroll')), findsOneWidget);
      expect(action, findsOneWidget);

      await tester.ensureVisible(action);
      await tester.pumpAndSettle();
      expect(tester.getBottomRight(action).dy, lessThanOrEqualTo(328));
    },
  );

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
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('dashboard-root')), findsOneWidget);
    expect(find.byKey(const ValueKey('welcome-root')), findsNothing);
    expect(find.text('Ayesha Tailors'), findsOneWidget);
    expect(find.text('Good morning, Ayesha Khan'), findsOneWidget);
    expect(find.text('Ali Tailors'), findsNothing);
    expect(find.text("Today's work"), findsOneWidget);
    expect(find.text('Quick actions'), findsOneWidget);
    expect(find.text('Recent orders'), findsOneWidget);

    await container.read(localeProvider.notifier).select(AppLocale.urdu);
    await tester.pump();
    expect(
      Directionality.of(
        tester.element(find.byKey(const ValueKey('dashboard-root'))),
      ),
      TextDirection.rtl,
    );
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
  Future<AuthState> build() async => SignedIn(
    session: AuthSessionSnapshot(
      user: const AuthUser(
        id: '01HUSER0000000000000000000',
        name: 'Ayesha Khan',
        phoneE164: '+923001234567',
        preferredLocale: 'en',
      ),
      businesses: [
        AuthBusiness(
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
            startsAt: DateTime.now(),
            expiresAt: DateTime.now().add(const Duration(days: 14)),
            offlineGraceUntil: DateTime.now().add(const Duration(days: 17)),
          ),
          access: AuthBusinessAccess(
            state: 'active',
            canUseApp: true,
            onlineVerificationRequired: false,
            validUntil: DateTime.now().add(const Duration(days: 14)),
          ),
        ),
      ],
      selectedBusinessId: '01HBUSINESS00000000000000',
      syncedAt: DateTime.now(),
    ),
  );
}

class _FakeSecureStorageService extends SecureStorageService {
  const _FakeSecureStorageService([this.token])
    : super(const FlutterSecureStorage());

  final String? token;

  @override
  Future<String?> readAccessToken() async => token;
}
