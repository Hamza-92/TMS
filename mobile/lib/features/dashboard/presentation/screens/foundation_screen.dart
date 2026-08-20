import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/core/localization/app_locale.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';

class FoundationScreen extends ConsumerWidget {
  const FoundationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocale = ref.watch(localeProvider);
    final localizations = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.appName)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(localizations.welcome),
              const SizedBox(height: 16),
              Text(localizations.foundationReady),
              const SizedBox(height: 8),
              Text(localizations.databaseReady),
              const SizedBox(height: 24),
              DropdownButton<AppLocale>(
                value: selectedLocale,
                onChanged: (locale) {
                  if (locale != null) {
                    ref.read(localeProvider.notifier).state = locale;
                  }
                },
                items: AppLocale.values
                    .map(
                      (locale) => DropdownMenuItem(
                        value: locale,
                        child: Text(locale.label(localizations)),
                      ),
                    )
                    .toList(),
              ),
              Text(localizations.language),
            ],
          ),
        ),
      ),
    );
  }
}
