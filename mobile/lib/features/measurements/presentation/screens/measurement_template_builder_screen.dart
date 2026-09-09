import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/features/auth/application/auth_controller.dart';
import 'package:tailor_app/features/measurements/application/measurement_providers.dart';
import 'package:tailor_app/features/measurements/data/measurement_repository.dart';
import 'package:tailor_app/features/measurements/domain/measurement.dart';
import 'package:tailor_app/features/measurements/presentation/measurement_localization.dart';
import 'package:tailor_app/features/measurements/presentation/widgets/measurement_field_editor_sheet.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';
import 'package:tailor_app/shared/widgets/app_status_sheet.dart';
import 'package:tailor_app/shared/widgets/gradient_page_header.dart';
import 'package:tailor_app/shared/widgets/pastel_page_background.dart';

class MeasurementTemplateBuilderScreen extends ConsumerStatefulWidget {
  const MeasurementTemplateBuilderScreen({
    this.templateClientUuid,
    this.sourceTemplateUuid,
    super.key,
  });

  final String? templateClientUuid;
  final String? sourceTemplateUuid;

  @override
  ConsumerState<MeasurementTemplateBuilderScreen> createState() =>
      _MeasurementTemplateBuilderScreenState();
}

class _MeasurementTemplateBuilderScreenState
    extends ConsumerState<MeasurementTemplateBuilderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameUrController = TextEditingController();
  final _nameRomanController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<MeasurementFieldDefinition> _fields = [];
  String _unit = 'inch';
  bool _initialized = false;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nameUrController.dispose();
    _nameRomanController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider).valueOrNull;
    final business = auth is SignedIn ? auth.business : null;
    if (business == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    final templates =
        ref.watch(measurementTemplatesProvider(business.id)).valueOrNull ??
        const <MeasurementTemplateRecord>[];
    final existing = templates
        .where((item) => item.clientUuid == widget.templateClientUuid)
        .firstOrNull;
    final source = templates
        .where((item) => item.clientUuid == widget.sourceTemplateUuid)
        .firstOrNull;
    final requiresRecord =
        widget.templateClientUuid != null || widget.sourceTemplateUuid != null;
    if (!_initialized &&
        (!requiresRecord || existing != null || source != null)) {
      _initialize(
        existing ?? source,
        copying: existing == null && source != null,
      );
    }

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
                height: 112,
                title: existing == null
                    ? context.l10n.newMeasurementTemplate
                    : context.l10n.editTemplate,
              ),
              Expanded(
                child: !_initialized
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : Form(
                        key: _formKey,
                        child: ListView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.fromLTRB(20, 22, 20, 36),
                          children: [
                            TextFormField(
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                              decoration: _requiredDecoration(
                                context.l10n.templateName,
                              ),
                              validator: (value) =>
                                  value == null || value.trim().length < 2
                                  ? context.l10n.templateNameRequired
                                  : null,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _nameUrController,
                              textDirection: TextDirection.rtl,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: context.l10n.templateNameUrdu,
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _nameRomanController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: context.l10n.templateNameRomanUrdu,
                              ),
                            ),
                            const SizedBox(height: 14),
                            SegmentedButton<String>(
                              segments: [
                                ButtonSegment(
                                  value: 'inch',
                                  label: Text(context.l10n.inches),
                                ),
                                ButtonSegment(
                                  value: 'cm',
                                  label: Text(context.l10n.centimetres),
                                ),
                              ],
                              selected: {_unit},
                              onSelectionChanged: (value) =>
                                  setState(() => _unit = value.first),
                              showSelectedIcon: false,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    context.l10n.templateFields,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontSize: 17),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: _addField,
                                  icon: const Icon(Icons.add_rounded, size: 19),
                                  label: Text(context.l10n.addMeasurementField),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (_fields.isEmpty)
                              _EmptyFields(onAdd: _addField)
                            else
                              ReorderableListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                buildDefaultDragHandles: false,
                                itemCount: _fields.length,
                                onReorderItem: _reorder,
                                itemBuilder: (context, index) => Padding(
                                  key: ValueKey(_fields[index].clientUuid),
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _FieldCard(
                                    field: _fields[index],
                                    index: index,
                                    onEdit: () => _editField(index),
                                    onRemove: () => _removeField(index),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: AppSizes.controlHeight,
                              child: FilledButton(
                                onPressed: _saving
                                    ? null
                                    : () => _save(business.id, existing),
                                child: _saving
                                    ? const SizedBox.square(
                                        dimension: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(context.l10n.saveTemplate),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _initialize(MeasurementTemplateRecord? record, {required bool copying}) {
    _initialized = true;
    if (record == null) return;
    _nameController.text = copying ? '${record.name} – Custom' : record.name;
    _nameUrController.text = record.nameUr ?? '';
    _nameRomanController.text = record.nameRomanUr ?? '';
    _descriptionController.text = record.description ?? '';
    _unit = record.defaultUnit;
    _fields.addAll(record.fields);
  }

  Future<void> _addField() async {
    final field = await showMeasurementFieldEditorSheet(
      context,
      excludedKeys: _fields.map((item) => item.key).toSet(),
    );
    if (field != null && mounted) setState(() => _fields.add(field));
  }

  Future<void> _editField(int index) async {
    final field = await showMeasurementFieldEditorSheet(
      context,
      existing: _fields[index],
      excludedKeys: _fields.map((item) => item.key).toSet(),
    );
    if (field != null && mounted) setState(() => _fields[index] = field);
  }

  Future<void> _removeField(int index) async {
    final remove = await showAppConfirmationSheet(
      context,
      type: AppStatusType.warning,
      title: context.l10n.removeField,
      message: _fields[index].label,
      confirmLabel: context.l10n.removeField,
      cancelLabel: context.l10n.cancelLabel,
    );
    if (remove && mounted) setState(() => _fields.removeAt(index));
  }

  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      final field = _fields.removeAt(oldIndex);
      _fields.insert(newIndex, field);
    });
  }

  Future<void> _save(
    String businessId,
    MeasurementTemplateRecord? existing,
  ) async {
    if (!_formKey.currentState!.validate()) return;
    if (_fields.isEmpty) {
      await showAppStatusSheet(
        context,
        type: AppStatusType.warning,
        title: context.l10n.templateFields,
        message: context.l10n.atLeastOneFieldRequired,
        actionLabel: context.l10n.okayLabel,
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(measurementRepositoryProvider)
          .saveTemplate(
            businessId: businessId,
            existing: existing,
            draft: MeasurementTemplateDraft(
              name: _nameController.text.trim(),
              nameUr: _emptyToNull(_nameUrController.text),
              nameRomanUr: _emptyToNull(_nameRomanController.text),
              category: _slug(_nameController.text),
              defaultUnit: _unit,
              description: _emptyToNull(_descriptionController.text),
              sourceTemplateUuid: existing == null
                  ? widget.sourceTemplateUuid
                  : existing.sourceTemplateUuid,
              fields: _fields,
            ),
          );
      unawaited(
        ref
            .read(measurementRepositoryProvider)
            .synchronizeTemplates(businessId),
      );
      if (!mounted) return;
      await showAppStatusSheet(
        context,
        type: AppStatusType.success,
        title: context.l10n.templateSavedTitle,
        message: context.l10n.templateSavedMessage,
        actionLabel: context.l10n.doneLabel,
      );
      if (mounted) context.pop();
    } catch (_) {
      if (!mounted) return;
      await showAppStatusSheet(
        context,
        type: AppStatusType.danger,
        title: context.l10n.errorTitle,
        message: context.l10n.templateSaveFailed,
        actionLabel: context.l10n.okayLabel,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _FieldCard extends StatelessWidget {
  const _FieldCard({
    required this.field,
    required this.index,
    required this.onEdit,
    required this.onRemove,
  });

  final MeasurementFieldDefinition field;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.control),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: index,
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.drag_indicator_rounded,
                color: AppColors.mutedInk,
                size: 21,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.localizedLabel(locale.languageCode, locale.scriptCode),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 3),
                Text(
                  '${localizedMeasurementSection(context, field.section)}  •  ${field.valueType == 'number' ? context.l10n.numericValue : context.l10n.textValue}',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined, size: 19),
          ),
          IconButton(
            onPressed: onRemove,
            color: AppColors.danger,
            icon: const Icon(Icons.delete_outline_rounded, size: 20),
          ),
        ],
      ),
    );
  }
}

class _EmptyFields extends StatelessWidget {
  const _EmptyFields({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.field,
      borderRadius: BorderRadius.circular(AppRadii.card),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      children: [
        const Icon(Icons.straighten_rounded, color: AppColors.primary),
        const SizedBox(height: 8),
        Text(
          context.l10n.atLeastOneFieldRequired,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded),
          label: Text(context.l10n.addMeasurementField),
        ),
      ],
    ),
  );
}

InputDecoration _requiredDecoration(String label) => InputDecoration(
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

String _slug(String value) {
  final slug = value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp('[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
  return slug.isEmpty ? 'custom' : slug;
}

String? _emptyToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
