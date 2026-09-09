import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/features/auth/application/auth_controller.dart';
import 'package:tailor_app/features/measurements/application/measurement_providers.dart';
import 'package:tailor_app/features/measurements/data/measurement_repository.dart';
import 'package:tailor_app/features/measurements/domain/measurement.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';
import 'package:tailor_app/shared/widgets/app_status_sheet.dart';
import 'package:tailor_app/shared/widgets/gradient_page_header.dart';
import 'package:tailor_app/shared/widgets/pastel_page_background.dart';

class MeasurementFormScreen extends ConsumerStatefulWidget {
  const MeasurementFormScreen({required this.customerClientUuid, super.key});

  final String customerClientUuid;

  @override
  ConsumerState<MeasurementFormScreen> createState() =>
      _MeasurementFormScreenState();
}

class _MeasurementFormScreenState extends ConsumerState<MeasurementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final Map<String, TextEditingController> _valueControllers = {};
  String? _templateUuid;
  String _preferredUnit = 'inch';
  DateTime _measuredAt = DateTime.now();
  bool _saving = false;
  String? _syncStartedForBusiness;

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    for (final controller in _valueControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider).valueOrNull;
    final business = authState is SignedIn ? authState.business : null;
    if (business == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    if (_syncStartedForBusiness != business.id) {
      _syncStartedForBusiness = business.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          unawaited(
            ref
                .read(measurementRepositoryProvider)
                .synchronizeCustomer(business.id, widget.customerClientUuid),
          );
        }
      });
    }

    final templatesAsync = ref.watch(measurementTemplatesProvider(business.id));
    final templates =
        templatesAsync.valueOrNull ?? const <MeasurementTemplateRecord>[];
    final selectedTemplate = templates
        .where((template) => template.clientUuid == _templateUuid)
        .firstOrNull;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: PastelPageBackground(
          child: Column(
            children: [
              GradientPageHeader(
                title: context.l10n.addMeasurements,
                height: 112,
                onBack: () => context.pop(),
              ),
              Expanded(
                child: templatesAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                  error: (_, _) => _TemplateLoadError(
                    onRetry: () => ref
                        .read(measurementRepositoryProvider)
                        .synchronizeCustomer(
                          business.id,
                          widget.customerClientUuid,
                        ),
                  ),
                  data: (_) => Form(
                    key: _formKey,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 36),
                      children: [
                        _SectionHeading(
                          title: context.l10n.measurementTemplate,
                          caption: context.l10n.measurementRequiredHint,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: _templateUuid,
                          isExpanded: true,
                          decoration: _requiredDecoration(
                            context,
                            context.l10n.measurementTemplate,
                          ),
                          hint: Text(context.l10n.selectMeasurementTemplate),
                          items: templates
                              .map(
                                (template) => DropdownMenuItem(
                                  value: template.clientUuid,
                                  child: Text(
                                    _templateName(context, template),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (value) =>
                              _selectTemplate(context, templates, value),
                          validator: (value) => value == null
                              ? context.l10n.measurementTemplateRequired
                              : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          decoration:
                              _requiredDecoration(
                                context,
                                context.l10n.measurementProfileName,
                              ).copyWith(
                                hintText:
                                    context.l10n.measurementProfileNameHint,
                              ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? context.l10n.measurementProfileNameRequired
                              : null,
                        ),
                        const SizedBox(height: 14),
                        _UnitSelector(
                          value: _preferredUnit,
                          onChanged: (value) => setState(() {
                            _preferredUnit = value;
                          }),
                        ),
                        const SizedBox(height: 14),
                        InkWell(
                          borderRadius: BorderRadius.circular(AppRadii.control),
                          onTap: _pickDate,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: context.l10n.measuredOn,
                              suffixIcon: const Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                              ),
                            ),
                            child: Text(
                              DateFormat.yMMMd(
                                Localizations.localeOf(context).toLanguageTag(),
                              ).format(_measuredAt),
                            ),
                          ),
                        ),
                        if (selectedTemplate != null) ...[
                          const SizedBox(height: 26),
                          _SectionHeading(
                            title: context.l10n.measurementValues,
                          ),
                          const SizedBox(height: 12),
                          ..._buildMeasurementFields(context, selectedTemplate),
                        ],
                        const SizedBox(height: 24),
                        _SectionHeading(title: context.l10n.measurementNotes),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _notesController,
                          minLines: 3,
                          maxLines: 5,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            labelText: context.l10n.measurementNotes,
                            hintText: context.l10n.measurementNotesHint,
                            alignLabelWithHint: true,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: AppSizes.controlHeight,
                          child: FilledButton(
                            onPressed: _saving || selectedTemplate == null
                                ? null
                                : () => _save(business.id, selectedTemplate),
                            child: _saving
                                ? const SizedBox.square(
                                    dimension: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(context.l10n.saveMeasurements),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectTemplate(
    BuildContext context,
    List<MeasurementTemplateRecord> templates,
    String? value,
  ) {
    if (value == null) return;
    final template = templates.firstWhere((item) => item.clientUuid == value);
    setState(() {
      _templateUuid = value;
      _preferredUnit = template.defaultUnit;
      _nameController.text = _templateName(context, template);
      final validIds = template.fields.map((field) => field.clientUuid).toSet();
      final staleIds = _valueControllers.keys
          .where((fieldUuid) => !validIds.contains(fieldUuid))
          .toList(growable: false);
      for (final fieldUuid in staleIds) {
        _valueControllers.remove(fieldUuid)?.dispose();
      }
    });
  }

  List<Widget> _buildMeasurementFields(
    BuildContext context,
    MeasurementTemplateRecord template,
  ) {
    final fields = [...template.fields]
      ..sort((a, b) {
        final section = a.section.compareTo(b.section);
        return section == 0 ? a.sortOrder.compareTo(b.sortOrder) : section;
      });
    final widgets = <Widget>[];
    String? currentSection;
    for (final field in fields) {
      if (currentSection != field.section) {
        if (currentSection != null) widgets.add(const SizedBox(height: 18));
        currentSection = field.section;
        widgets.add(_FieldGroupLabel(label: _displaySection(field.section)));
        widgets.add(const SizedBox(height: 10));
      }
      final controller = _valueControllers.putIfAbsent(
        field.clientUuid,
        TextEditingController.new,
      );
      widgets.add(
        TextFormField(
          key: ValueKey(field.clientUuid),
          controller: controller,
          keyboardType: field.valueType == 'number'
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          textInputAction: TextInputAction.next,
          inputFormatters: field.valueType == 'number'
              ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))]
              : null,
          decoration:
              (field.isRequired
                      ? _requiredDecoration(
                          context,
                          _fieldLabel(context, field),
                        )
                      : InputDecoration(labelText: _fieldLabel(context, field)))
                  .copyWith(
                    suffixText: field.unitType == 'length'
                        ? (_preferredUnit == 'inch' ? 'in' : 'cm')
                        : null,
                  ),
          validator: (raw) => _validateField(context, field, raw),
        ),
      );
      widgets.add(const SizedBox(height: 14));
    }
    if (widgets.isNotEmpty) widgets.removeLast();
    return widgets;
  }

  String? _validateField(
    BuildContext context,
    MeasurementFieldDefinition field,
    String? raw,
  ) {
    final value = raw?.trim() ?? '';
    if (value.isEmpty) {
      return field.isRequired ? context.l10n.measurementValueRequired : null;
    }
    if (field.valueType != 'number') return null;
    final parsed = double.tryParse(value);
    if (parsed == null || parsed <= 0) {
      return context.l10n.measurementValueInvalid;
    }
    final millimetres = field.unitType == 'length'
        ? (_preferredUnit == 'inch' ? parsed * 25.4 : parsed * 10)
        : parsed;
    if ((field.minimumValueMm != null && millimetres < field.minimumValueMm!) ||
        (field.maximumValueMm != null && millimetres > field.maximumValueMm!)) {
      return context.l10n.measurementValueInvalid;
    }
    return null;
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _measuredAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (selected != null && mounted) {
      setState(() => _measuredAt = selected);
    }
  }

  Future<void> _save(
    String businessId,
    MeasurementTemplateRecord template,
  ) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      final repository = ref.read(measurementRepositoryProvider);
      final profile = await repository.saveProfile(
        businessId: businessId,
        customerClientUuid: widget.customerClientUuid,
        draft: MeasurementProfileDraft(
          templateClientUuid: template.clientUuid,
          templateDefinitionVersion: template.definitionVersion,
          name: _nameController.text.trim(),
          preferredUnit: _preferredUnit,
          notes: _emptyToNull(_notesController.text),
        ),
      );
      final values = template.fields
          .where((field) {
            final raw = _valueControllers[field.clientUuid]?.text.trim();
            return raw != null && raw.isNotEmpty;
          })
          .map((field) {
            final raw = _valueControllers[field.clientUuid]!.text.trim();
            return MeasurementValueDraft(
              fieldUuid: field.clientUuid,
              value: field.valueType == 'number' ? double.parse(raw) : raw,
              unit: field.unitType == 'length' ? _preferredUnit : null,
            );
          })
          .toList(growable: false);
      await repository.addRevision(
        profile: profile,
        values: values,
        measuredAt: _measuredAt,
        notes: _emptyToNull(_notesController.text),
      );
      unawaited(
        repository.synchronizeCustomer(businessId, widget.customerClientUuid),
      );
      if (!mounted) return;
      await showAppStatusSheet(
        context,
        type: AppStatusType.success,
        title: context.l10n.measurementSavedTitle,
        message: context.l10n.measurementSavedMessage,
        actionLabel: context.l10n.doneLabel,
      );
      if (mounted) {
        context.go(
          '/customers/${widget.customerClientUuid}/measurements/${profile.clientUuid}',
        );
      }
    } catch (_) {
      if (!mounted) return;
      await showAppStatusSheet(
        context,
        type: AppStatusType.danger,
        title: context.l10n.errorTitle,
        message: context.l10n.measurementSaveFailed,
        actionLabel: context.l10n.okayLabel,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  InputDecoration _requiredDecoration(BuildContext context, String label) =>
      InputDecoration(
        label: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: label),
              const TextSpan(
                text: ' *',
                style: TextStyle(color: AppColors.danger),
              ),
            ],
          ),
        ),
      );

  String _templateName(
    BuildContext context,
    MeasurementTemplateRecord template,
  ) {
    final locale = Localizations.localeOf(context);
    return template.localizedName(locale.languageCode, locale.scriptCode);
  }

  String _fieldLabel(BuildContext context, MeasurementFieldDefinition field) {
    final locale = Localizations.localeOf(context);
    return field.localizedLabel(locale.languageCode, locale.scriptCode);
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.caption});

  final String title;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontSize: 16),
          ),
        ),
        if (caption != null)
          Flexible(
            child: Text(
              caption!,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(fontSize: 11),
            ),
          ),
      ],
    );
  }
}

class _FieldGroupLabel extends StatelessWidget {
  const _FieldGroupLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: Theme.of(context).textTheme.labelLarge
        ?.copyWith(color: AppColors.primary, fontSize: 12),
  );
}

class _UnitSelector extends StatelessWidget {
  const _UnitSelector({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.preferredUnit,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 7),
        Container(
          height: AppSizes.controlHeight,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.field,
            borderRadius: BorderRadius.circular(AppRadii.control),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              _UnitOption(
                label: context.l10n.inches,
                selected: value == 'inch',
                onTap: () => onChanged('inch'),
              ),
              const SizedBox(width: 4),
              _UnitOption(
                label: context.l10n.centimetres,
                selected: value == 'cm',
                onTap: () => onChanged('cm'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UnitOption extends StatelessWidget {
  const _UnitOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge
              ?.copyWith(color: selected ? Colors.white : AppColors.mutedInk),
        ),
      ),
    ),
  );
}

class _TemplateLoadError extends StatelessWidget {
  const _TemplateLoadError({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.measurementTemplateLoadFailed,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 18),
          OutlinedButton(
            onPressed: onRetry,
            child: Text(context.l10n.retryLabel),
          ),
        ],
      ),
    ),
  );
}

String _displaySection(String section) => section
    .split('_')
    .where((part) => part.isNotEmpty)
    .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
    .join(' ');

String? _emptyToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
