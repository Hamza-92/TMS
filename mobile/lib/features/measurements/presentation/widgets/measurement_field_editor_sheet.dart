import 'package:flutter/material.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/features/measurements/domain/measurement.dart';
import 'package:tailor_app/features/measurements/presentation/measurement_localization.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';
import 'package:uuid/uuid.dart';

Future<MeasurementFieldDefinition?> showMeasurementFieldEditorSheet(
  BuildContext context, {
  MeasurementFieldDefinition? existing,
  Set<String> excludedKeys = const {},
}) => showModalBottomSheet<MeasurementFieldDefinition>(
  context: context,
  useSafeArea: true,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  barrierColor: const Color(0x990F0D16),
  builder: (context) =>
      _MeasurementFieldEditor(existing: existing, excludedKeys: excludedKeys),
);

class _MeasurementFieldEditor extends StatefulWidget {
  const _MeasurementFieldEditor({required this.excludedKeys, this.existing});

  final MeasurementFieldDefinition? existing;
  final Set<String> excludedKeys;

  @override
  State<_MeasurementFieldEditor> createState() =>
      _MeasurementFieldEditorState();
}

class _MeasurementFieldEditorState extends State<_MeasurementFieldEditor> {
  static const _sections = [
    'upper_garment',
    'upper_body',
    'sleeves',
    'lower_garment',
    'garment',
    'collar',
    'lengths',
    'body',
    'leg',
    'custom',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _labelController;
  late final TextEditingController _labelUrController;
  late final TextEditingController _labelRomanController;
  late String _section;
  late String _valueType;
  late bool _usesUnit;
  late bool _required;

  @override
  void initState() {
    super.initState();
    final field = widget.existing;
    _labelController = TextEditingController(text: field?.label);
    _labelUrController = TextEditingController(text: field?.labelUr);
    _labelRomanController = TextEditingController(text: field?.labelRomanUr);
    _section = _sections.contains(field?.section) ? field!.section : 'custom';
    _valueType = field?.valueType ?? 'number';
    _usesUnit = field?.unitType != 'none';
    _required = field?.isRequired ?? false;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _labelUrController.dispose();
    _labelRomanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      padding: EdgeInsets.fromLTRB(20, 10, 20, 18 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                widget.existing == null
                    ? context.l10n.addMeasurementField
                    : context.l10n.editMeasurementField,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _labelController,
                textInputAction: TextInputAction.next,
                decoration: _requiredDecoration(
                  context,
                  context.l10n.fieldNameEnglish,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? context.l10n.fieldNameRequired
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _labelUrController,
                textInputAction: TextInputAction.next,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: context.l10n.fieldNameUrdu,
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _labelRomanController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: context.l10n.fieldNameRomanUrdu,
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _section,
                decoration: InputDecoration(
                  labelText: context.l10n.fieldSection,
                ),
                items: [
                  for (final section in _sections)
                    DropdownMenuItem(
                      value: section,
                      child: Text(
                        localizedMeasurementSection(context, section),
                      ),
                    ),
                ],
                onChanged: (value) => setState(() => _section = value!),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _valueType,
                decoration: InputDecoration(labelText: context.l10n.fieldType),
                items: [
                  DropdownMenuItem(
                    value: 'number',
                    child: Text(context.l10n.numericValue),
                  ),
                  DropdownMenuItem(
                    value: 'text',
                    child: Text(context.l10n.textValue),
                  ),
                ],
                onChanged: (value) => setState(() {
                  _valueType = value!;
                  if (_valueType == 'text') _usesUnit = false;
                }),
              ),
              const SizedBox(height: 8),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(context.l10n.usesMeasurementUnit),
                value: _usesUnit,
                onChanged: _valueType == 'number'
                    ? (value) => setState(() => _usesUnit = value)
                    : null,
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(context.l10n.requiredField),
                value: _required,
                onChanged: (value) => setState(() => _required = value),
              ),
              const SizedBox(height: 14),
              Row(
                textDirection: TextDirection.ltr,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(context.l10n.cancelLabel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _save,
                      child: Text(context.l10n.saveField),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final label = _labelController.text.trim();
    var key = _slug(label);
    if (key.isEmpty) key = 'custom_field';
    final originalKey = widget.existing?.key;
    var suffix = 2;
    final unavailable = {...widget.excludedKeys}..remove(originalKey);
    final base = key;
    while (unavailable.contains(key)) {
      key = '${base}_${suffix++}';
    }
    Navigator.pop(
      context,
      MeasurementFieldDefinition(
        clientUuid: widget.existing?.clientUuid ?? const Uuid().v4(),
        key: key,
        label: label,
        labelUr: _emptyToNull(_labelUrController.text),
        labelRomanUr: _emptyToNull(_labelRomanController.text),
        section: _section,
        valueType: _valueType,
        unitType: _valueType == 'number' && _usesUnit ? 'length' : 'none',
        isRequired: _required,
        minimumValueMm: widget.existing?.minimumValueMm,
        maximumValueMm: widget.existing?.maximumValueMm,
        sortOrder: widget.existing?.sortOrder ?? 0,
        helpText: widget.existing?.helpText,
        helpTextUr: widget.existing?.helpTextUr,
        helpTextRomanUr: widget.existing?.helpTextRomanUr,
      ),
    );
  }
}

InputDecoration _requiredDecoration(BuildContext context, String label) =>
    InputDecoration(
      label: Text.rich(
        TextSpan(
          text: label,
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: AppColors.danger),
            ),
          ],
        ),
      ),
    );

String _slug(String value) => value
    .toLowerCase()
    .replaceAll(RegExp('[^a-z0-9]+'), '_')
    .replaceAll(RegExp(r'^_+|_+$'), '');

String? _emptyToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
