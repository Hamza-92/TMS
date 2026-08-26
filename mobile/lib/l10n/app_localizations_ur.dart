// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'Tailor Manager';

  @override
  String get welcome => 'خوش آمدید';

  @override
  String get language => 'زبان';

  @override
  String get english => 'انگریزی';

  @override
  String get urdu => 'اردو';

  @override
  String get romanUrdu => 'رومن اردو';

  @override
  String get foundationReady => 'فلٹر کی بنیاد چل رہی ہے';

  @override
  String get databaseReady => 'مقامی ڈیٹا بیس تیار ہے';

  @override
  String get introTagline =>
      'اپنے گاہک، پیمائشیں، آرڈرز اور ادائیگیاں آسانی سے سنبھالیں۔';

  @override
  String get tailorIllustrationLabel =>
      'لباس کے سانچے کے پاس ٹیبلٹ استعمال کرتا ہوا درزی';

  @override
  String get welcomeBack => 'خوش آمدید';

  @override
  String get signInSubtitle => 'اپنا کام وہیں سے جاری رکھیں';

  @override
  String get emailAddress => 'ای میل';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get password => 'پاس ورڈ';

  @override
  String get passwordHint => 'اپنا پاس ورڈ درج کریں';

  @override
  String get forgotPassword => 'پاس ورڈ بھول گئے؟';

  @override
  String get signIn => 'سائن اِن';

  @override
  String get emailRequired => 'اپنا ای میل درج کریں';

  @override
  String get emailInvalid => 'درست ای میل درج کریں';

  @override
  String get loginIdentifier => 'ای میل یا فون نمبر';

  @override
  String get loginIdentifierHint => 'ای میل یا فون نمبر';

  @override
  String get loginIdentifierRequired => 'اپنا ای میل یا فون نمبر درج کریں';

  @override
  String get loginIdentifierInvalid => 'درست ای میل یا فون نمبر درج کریں';

  @override
  String get passwordRequired => 'اپنا پاس ورڈ درج کریں';

  @override
  String get passwordTooShort => 'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے';

  @override
  String get showPassword => 'پاس ورڈ دکھائیں';

  @override
  String get hidePassword => 'پاس ورڈ چھپائیں';

  @override
  String get authNotConnected =>
      'لاگ اِن سروس تصدیقی API تیار ہونے پر منسلک کی جائے گی۔';
}

/// The translations for Urdu, using the Latin script (`ur_Latn`).
class AppLocalizationsUrLatn extends AppLocalizationsUr {
  AppLocalizationsUrLatn() : super('ur_Latn');

  @override
  String get appName => 'Tailor Manager';

  @override
  String get welcome => 'Khush Aamdeed';

  @override
  String get language => 'Zabaan';

  @override
  String get english => 'Angrezi';

  @override
  String get urdu => 'Urdu';

  @override
  String get romanUrdu => 'Roman Urdu';

  @override
  String get foundationReady => 'Flutter foundation chal rahi hai';

  @override
  String get databaseReady => 'Local database tayyar hai';

  @override
  String get introTagline =>
      'Apne customers, measurements, orders aur payments asaani se sambhalein.';

  @override
  String get tailorIllustrationLabel =>
      'Dress form ke paas tablet istemal karta darzi';

  @override
  String get welcomeBack => 'Khush aamdeed';

  @override
  String get signInSubtitle => 'Apna kaam wahin se jaari rakhein';

  @override
  String get emailAddress => 'Email address';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Apna password likhein';

  @override
  String get forgotPassword => 'Password bhool gaye?';

  @override
  String get signIn => 'Sign in';

  @override
  String get emailRequired => 'Apna email address likhein';

  @override
  String get emailInvalid => 'Durust email address likhein';

  @override
  String get loginIdentifier => 'Email ya phone number';

  @override
  String get loginIdentifierHint => 'Email ya phone number';

  @override
  String get loginIdentifierRequired => 'Apna email ya phone number likhein';

  @override
  String get loginIdentifierInvalid => 'Durust email ya phone number likhein';

  @override
  String get passwordRequired => 'Apna password likhein';

  @override
  String get passwordTooShort =>
      'Password kam az kam 6 characters ka hona chahiye';

  @override
  String get showPassword => 'Password dikhayein';

  @override
  String get hidePassword => 'Password chhupayein';

  @override
  String get authNotConnected =>
      'Authentication API tayyar hone par login connect kiya jayega.';
}
