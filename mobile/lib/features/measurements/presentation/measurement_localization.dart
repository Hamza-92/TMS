import 'package:flutter/widgets.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';

String localizedMeasurementSection(BuildContext context, String section) =>
    switch (section) {
      'upper_garment' => context.l10n.measurementSectionUpperGarment,
      'upper_body' => context.l10n.measurementSectionUpperBody,
      'sleeves' => context.l10n.measurementSectionSleeves,
      'lower_garment' => context.l10n.measurementSectionLowerGarment,
      'garment' => context.l10n.measurementSectionGarment,
      'collar' => context.l10n.measurementSectionCollar,
      'lengths' => context.l10n.measurementSectionLengths,
      'body' => context.l10n.measurementSectionBody,
      'leg' => context.l10n.measurementSectionLeg,
      'custom' => context.l10n.measurementSectionCustom,
      _ => _humanizeSection(section),
    };

String _humanizeSection(String section) => section
    .split('_')
    .where((part) => part.isNotEmpty)
    .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
    .join(' ');
