import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/app/router.dart';
import 'package:tailor_app/core/localization/app_locale.dart';
import 'package:tailor_app/l10n/app_localizations.dart';

class TailorApp extends ConsumerWidget {
  const TailorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocale = ref.watch(localeProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      locale: selectedLocale.locale,
      supportedLocales: AppLocale.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      routerConfig: appRouter,
      builder: (context, child) {
        final locale = Localizations.localeOf(context);
        final direction = locale.scriptCode == 'Latn'
            ? TextDirection.ltr
            : Directionality.of(context);

        return Directionality(
          textDirection: direction,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
