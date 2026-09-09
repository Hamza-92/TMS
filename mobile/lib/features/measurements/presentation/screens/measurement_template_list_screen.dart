import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/features/auth/application/auth_controller.dart';
import 'package:tailor_app/features/measurements/application/measurement_providers.dart';
import 'package:tailor_app/features/measurements/data/measurement_repository.dart';
import 'package:tailor_app/features/measurements/domain/measurement.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';
import 'package:tailor_app/shared/widgets/gradient_page_header.dart';
import 'package:tailor_app/shared/widgets/pastel_page_background.dart';

class MeasurementTemplateListScreen extends ConsumerStatefulWidget {
  const MeasurementTemplateListScreen({super.key});

  @override
  ConsumerState<MeasurementTemplateListScreen> createState() =>
      _MeasurementTemplateListScreenState();
}

class _MeasurementTemplateListScreenState
    extends ConsumerState<MeasurementTemplateListScreen> {
  String? _refreshStartedFor;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider).valueOrNull;
    final business = auth is SignedIn ? auth.business : null;
    if (business == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    if (_refreshStartedFor != business.id) {
      _refreshStartedFor = business.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          unawaited(
            ref
                .read(measurementRepositoryProvider)
                .synchronizeTemplates(business.id),
          );
        }
      });
    }
    final templates = ref.watch(measurementTemplatesProvider(business.id));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/measurement-templates/new'),
          tooltip: context.l10n.newMeasurementTemplate,
          child: const Icon(Icons.add_rounded),
        ),
        body: PastelPageBackground(
          child: Column(
            children: [
              GradientPageHeader(
                height: 138,
                title: context.l10n.measurementTemplatesTitle,
                bottom: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    context.l10n.measurementTemplatesSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.82),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator.adaptive(
                  onRefresh: () => ref
                      .read(measurementRepositoryProvider)
                      .synchronizeTemplates(business.id),
                  child: templates.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    error: (_, _) => ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 100),
                        Center(
                          child: Text(
                            context.l10n.measurementTemplateLoadFailed,
                          ),
                        ),
                      ],
                    ),
                    data: (items) => ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 104),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _TemplateCard(
                        template: items[index],
                        onTap: () {
                          final template = items[index];
                          if (template.isBusinessTemplate) {
                            context.push(
                              '/measurement-templates/${template.clientUuid}/edit',
                            );
                          } else {
                            context.push(
                              '/measurement-templates/new?source=${template.clientUuid}',
                            );
                          }
                        },
                      ),
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
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template, required this.onTap});

  final MeasurementTemplateRecord template;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final system = !template.isBusinessTemplate;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
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
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: system ? AppColors.infoSurface : AppColors.lavender,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  system ? Icons.straighten_rounded : Icons.tune_rounded,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.localizedName(
                        locale.languageCode,
                        locale.scriptCode,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${system ? context.l10n.builtInTemplate : context.l10n.customTemplate}  •  ${template.fields.length} ${context.l10n.templateFields}',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Directionality.of(context) == ui.TextDirection.rtl
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                textDirection: ui.TextDirection.ltr,
                color: AppColors.mutedInk,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
