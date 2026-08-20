// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'درزی مینجمنٹ';

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
}

/// The translations for Urdu, using the Latin script (`ur_Latn`).
class AppLocalizationsUrLatn extends AppLocalizationsUr {
  AppLocalizationsUrLatn() : super('ur_Latn');

  @override
  String get appName => 'Darzi Management';

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
}
