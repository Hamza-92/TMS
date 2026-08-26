import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/core/database/app_database.dart';
import 'package:tailor_app/core/database/database_provider.dart';
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

  static AppLocale? fromStorageValue(String? value) => switch (value) {
    'english' => AppLocale.english,
    'urdu' => AppLocale.urdu,
    'romanUrdu' => AppLocale.romanUrdu,
    _ => null,
  };

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

class LocaleController extends StateNotifier<AppLocale> {
  LocaleController(this._database) : super(AppLocale.english) {
    unawaited(_restore());
  }

  static const _localeMetadataKey = 'app_locale';

  final AppDatabase _database;
  bool _changedByUser = false;

  Future<void> _restore() async {
    try {
      final savedLocale = AppLocale.fromStorageValue(
        await _database.readMetadata(_localeMetadataKey),
      );
      if (!_changedByUser && savedLocale != null) {
        state = savedLocale;
      }
    } catch (_) {
      // Keep English when storage is unavailable during early app startup.
    }
  }

  Future<void> select(AppLocale locale) async {
    _changedByUser = true;
    state = locale;

    try {
      await _database.writeMetadata(_localeMetadataKey, locale.name);
    } catch (_) {
      // The in-memory choice remains active even if persistence is unavailable.
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleController, AppLocale>(
  (ref) => LocaleController(ref.watch(appDatabaseProvider)),
);
