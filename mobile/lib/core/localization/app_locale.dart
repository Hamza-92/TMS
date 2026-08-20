import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/l10n/app_localizations.dart';

enum AppLocale {
  english(Locale('en')),
  urdu(
    Locale.fromSubtags(
      languageCode: 'ur',
      scriptCode: 'Arab',
      countryCode: 'PK',
    ),
  ),
  romanUrdu(
    Locale.fromSubtags(
      languageCode: 'ur',
      scriptCode: 'Latn',
      countryCode: 'PK',
    ),
  );

  const AppLocale(this.locale);

  final Locale locale;

  static const supportedLocales = [
    Locale('en'),
    Locale.fromSubtags(
      languageCode: 'ur',
      scriptCode: 'Arab',
      countryCode: 'PK',
    ),
    Locale.fromSubtags(
      languageCode: 'ur',
      scriptCode: 'Latn',
      countryCode: 'PK',
    ),
  ];

  String label(AppLocalizations localizations) => switch (this) {
    AppLocale.english => localizations.english,
    AppLocale.urdu => localizations.urdu,
    AppLocale.romanUrdu => localizations.romanUrdu,
  };
}

final localeProvider = StateProvider<AppLocale>((ref) => AppLocale.english);
