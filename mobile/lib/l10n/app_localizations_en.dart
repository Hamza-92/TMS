// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Tailor Manager';

  @override
  String get welcome => 'Welcome';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get urdu => 'Urdu';

  @override
  String get romanUrdu => 'Roman Urdu';

  @override
  String get foundationReady => 'Flutter foundation is running';

  @override
  String get databaseReady => 'Local database initialized';

  @override
  String get introTagline =>
      'Manage customers, measurements, orders and payments with ease.';

  @override
  String get tailorIllustrationLabel =>
      'Tailor working with a tablet beside a dress form';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get signInSubtitle => 'Continue where you left off';

  @override
  String get emailAddress => 'Email address';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign in';

  @override
  String get emailRequired => 'Enter your email address';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get loginIdentifier => 'Email or phone number';

  @override
  String get loginIdentifierHint => 'Email or phone number';

  @override
  String get loginIdentifierRequired => 'Enter your email or phone number';

  @override
  String get loginIdentifierInvalid => 'Enter a valid email or phone number';

  @override
  String get passwordRequired => 'Enter your password';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get authNotConnected =>
      'Login will be connected when the authentication API is ready.';
}
