import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/features/auth/application/auth_controller.dart';
import 'package:tailor_app/features/customers/application/customer_providers.dart';
import 'package:tailor_app/features/customers/domain/customer.dart';
import 'package:tailor_app/features/customers/presentation/widgets/customer_avatar.dart';
import 'package:tailor_app/features/measurements/application/measurement_providers.dart';
import 'package:tailor_app/features/measurements/data/measurement_repository.dart';
import 'package:tailor_app/features/measurements/domain/measurement.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';
import 'package:tailor_app/shared/widgets/gradient_page_header.dart';
import 'package:tailor_app/shared/widgets/pastel_page_background.dart';

class MeasurementProfileListScreen extends ConsumerStatefulWidget {
  const MeasurementProfileListScreen({
    required this.customerClientUuid,
    super.key,
  });

  final String customerClientUuid;

  @override
  ConsumerState<MeasurementProfileListScreen> createState() =>
      _MeasurementProfileListScreenState();
}

class _MeasurementProfileListScreenState
    extends ConsumerState<MeasurementProfileListScreen> {
  String? _syncStartedForBusiness;

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
        if (mounted) unawaited(_refresh(business.id));
      });
    }

    final customer = ref.watch(
      customerProvider(CustomerKey(business.id, widget.customerClientUuid)),
    );
    final customerRecord = customer.valueOrNull;
    final profiles = ref.watch(
      measurementProfilesProvider(
        CustomerMeasurementKey(business.id, widget.customerClientUuid),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(
            '/customers/${widget.customerClientUuid}/measurements/new',
          ),
          tooltip: context.l10n.addMeasurements,
          elevation: 3,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add_rounded, size: 27),
        ),
        body: PastelPageBackground(
          child: Column(
            children: [
              GradientPageHeader(
                title: context.l10n.measurementsTitle,
                height: 164,
                onBack: () =>
                    context.go('/customers/${widget.customerClientUuid}'),
                bottom: customerRecord != null
                    ? _CustomerHeader(customer: customerRecord)
                    : null,
              ),
              Expanded(
                child: RefreshIndicator.adaptive(
                  onRefresh: () => _refresh(business.id),
                  child: profiles.when(
                    data: (items) => items.isEmpty
                        ? _EmptyMeasurements(
                            onAdd: () => context.push(
                              '/customers/${widget.customerClientUuid}/measurements/new',
                            ),
                          )
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 22, 20, 104),
                            itemCount: items.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) =>
                                _MeasurementProfileCard(
                                  profile: items[index],
                                  index: index,
                                  onTap: () => context.push(
                                    '/customers/${widget.customerClientUuid}/measurements/${items[index].clientUuid}',
                                  ),
                                ),
                          ),
                    loading: () => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    error: (_, _) => _MeasurementLoadError(
                      onRetry: () => _refresh(business.id),
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

  Future<void> _refresh(String businessId) => ref
      .read(measurementRepositoryProvider)
      .synchronizeCustomer(businessId, widget.customerClientUuid);
}

class _CustomerHeader extends StatelessWidget {
  const _CustomerHeader({required this.customer});

  final CustomerRecord customer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomerAvatar(
          localPhotoPath: customer.photoLocalPath,
          photoUrl: customer.photoUrl,
          size: 42,
          borderRadius: 12,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customer.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 2),
              Text(
                context.l10n.measurementProfilesSubtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MeasurementProfileCard extends StatelessWidget {
  const _MeasurementProfileCard({
    required this.profile,
    required this.index,
    required this.onTap,
  });

  final MeasurementProfileRecord profile;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(profile.updatedAt.toLocal());
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 260 + (index.clamp(0, 5) * 55)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 12 * (1 - value)),
          child: child,
        ),
      ),
      child: Material(
        color: Colors.white,
        elevation: 0,
        shadowColor: AppColors.primary.withValues(alpha: 0.08),
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
                  color: AppColors.primary.withValues(alpha: 0.055),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: AppColors.lavender,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/measurements.svg',
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
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
                            ?.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${context.l10n.measurementRevision(profile.latestRevisionNumber)}  •  $date',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                  size: 22,
                  color: AppColors.mutedInk,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyMeasurements extends StatelessWidget {
  const _EmptyMeasurements({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(28, 84, 28, 120),
      children: [
        Center(
          child: Container(
            width: 76,
            height: 76,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.lavender,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              'assets/icons/measurements.svg',
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          context.l10n.noMeasurementsTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 7),
        Text(
          context.l10n.noMeasurementsMessage,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 22),
        Center(
          child: FilledButton(
            onPressed: onAdd,
            child: Text(context.l10n.addMeasurements),
          ),
        ),
      ],
    );
  }
}

class _MeasurementLoadError extends StatelessWidget {
  const _MeasurementLoadError({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(28, 90, 28, 80),
      children: [
        const Icon(
          Icons.error_outline_rounded,
          size: 42,
          color: AppColors.danger,
        ),
        const SizedBox(height: 14),
        Text(
          context.l10n.measurementLoadFailed,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 18),
        Center(
          child: OutlinedButton(
            onPressed: onRetry,
            child: Text(context.l10n.retryLabel),
          ),
        ),
      ],
    );
  }
}
