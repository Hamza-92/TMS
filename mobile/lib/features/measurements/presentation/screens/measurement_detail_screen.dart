import 'dart:async';
import 'dart:ui' as ui;

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
import 'package:tailor_app/shared/widgets/gradient_page_header.dart';
import 'package:tailor_app/shared/widgets/pastel_page_background.dart';

class MeasurementDetailScreen extends ConsumerStatefulWidget {
  const MeasurementDetailScreen({
    required this.customerClientUuid,
    required this.profileClientUuid,
    super.key,
  });

  final String customerClientUuid;
  final String profileClientUuid;

  @override
  ConsumerState<MeasurementDetailScreen> createState() =>
      _MeasurementDetailScreenState();
}

class _MeasurementDetailScreenState
    extends ConsumerState<MeasurementDetailScreen> {
  String? _refreshStartedForBusiness;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider).valueOrNull;
    final business = authState is SignedIn ? authState.business : null;
    if (business == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    if (_refreshStartedForBusiness != business.id) {
      _refreshStartedForBusiness = business.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_refresh(business.id));
      });
    }

    final key = MeasurementProfileKey(business.id, widget.profileClientUuid);
    final profileAsync = ref.watch(measurementProfileProvider(key));
    final revisionsAsync = ref.watch(measurementRevisionsProvider(key));
    final templatesAsync = ref.watch(measurementTemplatesProvider(business.id));

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
                title:
                    profileAsync.valueOrNull?.name ??
                    context.l10n.measurementsTitle,
                height: 112,
                onBack: () => context.go(
                  '/customers/${widget.customerClientUuid}/measurements',
                ),
              ),
              Expanded(
                child: profileAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator.adaptive()),
                  error: (_, _) => _DetailMessage(
                    message: context.l10n.measurementLoadFailed,
                  ),
                  data: (profile) {
                    if (profile == null) {
                      return _DetailMessage(
                        message: context.l10n.measurementProfileNotFound,
                      );
                    }
                    final templates =
                        templatesAsync.valueOrNull ??
                        const <MeasurementTemplateRecord>[];
                    final template = templates
                        .where(
                          (item) =>
                              item.clientUuid == profile.templateClientUuid,
                        )
                        .firstOrNull;
                    return RefreshIndicator.adaptive(
                      onRefresh: () => _refresh(business.id),
                      child: _MeasurementDetailBody(
                        profile: profile,
                        template: template,
                        revisions:
                            revisionsAsync.valueOrNull ??
                            const <MeasurementRevisionRecord>[],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh(String businessId) async {
    final repository = ref.read(measurementRepositoryProvider);
    await repository.synchronizeCustomer(businessId, widget.customerClientUuid);
    await repository.refreshHistory(
      businessId: businessId,
      customerClientUuid: widget.customerClientUuid,
      profileClientUuid: widget.profileClientUuid,
    );
  }
}

class _MeasurementDetailBody extends StatelessWidget {
  const _MeasurementDetailBody({
    required this.profile,
    required this.template,
    required this.revisions,
  });

  final MeasurementProfileRecord profile;
  final MeasurementTemplateRecord? template;
  final List<MeasurementRevisionRecord> revisions;

  @override
  Widget build(BuildContext context) {
    final latest = revisions.firstOrNull;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 38),
      children: [
        _ProfileSummary(profile: profile, template: template),
        const SizedBox(height: 24),
        _SectionTitle(context.l10n.latestMeasurements),
        const SizedBox(height: 12),
        if (latest == null)
          _DetailCard(
            child: Text(
              context.l10n.noMeasurementsTitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        else
          _LatestValues(
            revision: latest,
            template: template,
            preferredUnit: profile.preferredUnit,
          ),
        if (latest?.notes?.trim().isNotEmpty == true) ...[
          const SizedBox(height: 12),
          _DetailCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.measurementNotes,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  latest!.notes!,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: AppColors.ink),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        _SectionTitle(context.l10n.measurementHistory),
        const SizedBox(height: 12),
        ...revisions.map(
          (revision) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _RevisionCard(revision: revision),
          ),
        ),
      ],
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({required this.profile, required this.template});

  final MeasurementProfileRecord profile;
  final MeasurementTemplateRecord? template;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final templateName = template?.localizedName(
      locale.languageCode,
      locale.scriptCode,
    );
    return _DetailCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.lavender,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.straighten_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  [
                    ?templateName,
                    profile.preferredUnit == 'inch'
                        ? context.l10n.inches
                        : context.l10n.centimetres,
                  ].join('  •  '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LatestValues extends StatelessWidget {
  const _LatestValues({
    required this.revision,
    required this.template,
    required this.preferredUnit,
  });

  final MeasurementRevisionRecord revision;
  final MeasurementTemplateRecord? template;
  final String preferredUnit;

  @override
  Widget build(BuildContext context) {
    final fieldsByUuid = {
      for (final field
          in template?.fields ?? const <MeasurementFieldDefinition>[])
        field.clientUuid: field,
    };
    final locale = Localizations.localeOf(context);
    return _DetailCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < revision.values.length; index++) ...[
            Builder(
              builder: (context) {
                final value = revision.values[index];
                final field = fieldsByUuid[value['field_uuid']];
                final label =
                    field?.localizedLabel(
                      locale.languageCode,
                      locale.scriptCode,
                    ) ??
                    value['label']?.toString() ??
                    context.l10n.measurementsTitle;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.ink),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _displayValue(value, field, preferredUnit),
                        textDirection: ui.TextDirection.ltr,
                        style: Theme.of(context).textTheme.labelLarge
                            ?.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (index != revision.values.length - 1)
              const Divider(height: 1, indent: 14, endIndent: 14),
          ],
        ],
      ),
    );
  }
}

class _RevisionCard extends StatelessWidget {
  const _RevisionCard({required this.revision});

  final MeasurementRevisionRecord revision;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateFormat.yMMMd(locale).format(revision.measuredAt.toLocal());
    return _DetailCard(
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.mint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.history_rounded,
              size: 20,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.measurementRevision(revision.revisionNumber),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 3),
                Text(
                  '$date  •  ${context.l10n.measurementFieldsCount(revision.values.length)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadii.card),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.05),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: child,
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 17),
  );
}

class _DetailMessage extends StatelessWidget {
  const _DetailMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ),
  );
}

String _displayValue(
  Map<String, dynamic> value,
  MeasurementFieldDefinition? field,
  String fallbackUnit,
) {
  final raw = value['value'];
  final display = raw is num
      ? raw.toStringAsFixed(raw % 1 == 0 ? 0 : 2)
      : raw?.toString() ?? '—';
  if (field?.unitType != 'length') return display;
  final unit = value['unit']?.toString() ?? fallbackUnit;
  return '$display ${unit == 'inch' ? 'in' : 'cm'}';
}
