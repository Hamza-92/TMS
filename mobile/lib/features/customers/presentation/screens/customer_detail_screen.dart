import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/features/auth/application/auth_controller.dart';
import 'package:tailor_app/features/customers/application/customer_providers.dart';
import 'package:tailor_app/features/customers/data/customer_repository.dart';
import 'package:tailor_app/features/customers/domain/customer.dart';
import 'package:tailor_app/features/customers/presentation/widgets/customer_avatar.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';
import 'package:tailor_app/shared/widgets/app_status_sheet.dart';

enum _CustomerMenuAction { edit, archive, restore, deletePermanently }

class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({required this.clientUuid, super.key});

  final String clientUuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider).valueOrNull;
    final business = authState is SignedIn ? authState.business : null;
    if (business == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final customer = ref.watch(
      customerProvider(CustomerKey(business.id, clientUuid)),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goBack(context);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: customer.when(
            data: (record) => record == null
                ? _CustomerNotFound(onBack: () => _goBack(context))
                : _CustomerDetailView(
                    customer: record,
                    onBack: () => _goBack(context),
                    onMore: () => _openActions(context, ref, record),
                    onMeasurements: () => context.push(
                      '/customers/${record.clientUuid}/measurements',
                    ),
                    onUnavailable: () => _showUnavailable(context),
                  ),
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
            error: (_, _) => _CustomerNotFound(
              message: context.l10n.customerLoadFailed,
              onBack: () => _goBack(context),
            ),
          ),
        ),
      ),
    );
  }

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/customers');
    }
  }

  Future<void> _showUnavailable(BuildContext context) => showAppStatusSheet(
    context,
    type: AppStatusType.info,
    title: context.l10n.featureUnavailableTitle,
    message: context.l10n.featureUnavailableMessage,
    actionLabel: context.l10n.okayLabel,
  );

  Future<void> _openActions(
    BuildContext context,
    WidgetRef ref,
    CustomerRecord customer,
  ) async {
    final action = await showAppOptionsSheet<_CustomerMenuAction>(
      context,
      title: context.l10n.customerMoreActions,
      cancelLabel: context.l10n.cancelLabel,
      options: [
        if (!customer.isArchived)
          AppSheetOption(
            value: _CustomerMenuAction.edit,
            label: context.l10n.editCustomer,
            icon: Icons.edit_outlined,
          ),
        AppSheetOption(
          value: customer.isArchived
              ? _CustomerMenuAction.restore
              : _CustomerMenuAction.archive,
          label: customer.isArchived
              ? context.l10n.restoreCustomer
              : context.l10n.archiveCustomer,
          icon: customer.isArchived
              ? Icons.restore_rounded
              : Icons.archive_outlined,
          destructive: !customer.isArchived,
        ),
        if (customer.isArchived)
          AppSheetOption(
            value: _CustomerMenuAction.deletePermanently,
            label: context.l10n.deletePermanently,
            icon: Icons.delete_forever_outlined,
            destructive: true,
          ),
      ],
    );
    if (action == null || !context.mounted) return;

    switch (action) {
      case _CustomerMenuAction.edit:
        await context.push('/customers/${customer.clientUuid}/edit');
        break;
      case _CustomerMenuAction.archive:
      case _CustomerMenuAction.restore:
        await _changeStatus(context, ref, customer);
        break;
      case _CustomerMenuAction.deletePermanently:
        await _deletePermanently(context, ref, customer);
        break;
    }
  }

  Future<void> _deletePermanently(
    BuildContext context,
    WidgetRef ref,
    CustomerRecord customer,
  ) async {
    final confirmed = await showAppConfirmationSheet(
      context,
      type: AppStatusType.danger,
      title: context.l10n.deletePermanentlyTitle,
      message: context.l10n.deletePermanentlyMessage,
      confirmLabel: context.l10n.deleteLabel,
      cancelLabel: context.l10n.cancelLabel,
    );
    if (!confirmed || !context.mounted) return;

    try {
      final repository = ref.read(customerRepositoryProvider);
      await repository.deletePermanently(customer);
      unawaited(repository.synchronize(customer.businessId));
      if (!context.mounted) return;
      await showAppStatusSheet(
        context,
        type: AppStatusType.success,
        title: context.l10n.successTitle,
        message: context.l10n.customerDeletedPermanently,
        actionLabel: context.l10n.doneLabel,
      );
      if (context.mounted) context.go('/customers');
    } catch (_) {
      if (!context.mounted) return;
      await showAppStatusSheet(
        context,
        type: AppStatusType.danger,
        title: context.l10n.errorTitle,
        message: context.l10n.customerStatusChangeFailed,
        actionLabel: context.l10n.okayLabel,
      );
    }
  }

  Future<void> _changeStatus(
    BuildContext context,
    WidgetRef ref,
    CustomerRecord customer,
  ) async {
    final shouldContinue = customer.isArchived
        ? true
        : await showAppConfirmationSheet(
            context,
            type: AppStatusType.warning,
            title: context.l10n.archiveCustomer,
            message: context.l10n.archiveCustomerMessage,
            confirmLabel: context.l10n.archiveLabel,
            cancelLabel: context.l10n.cancelLabel,
          );
    if (!shouldContinue || !context.mounted) return;

    try {
      final repository = ref.read(customerRepositoryProvider);
      if (customer.isArchived) {
        await repository.restore(customer);
      } else {
        await repository.archive(customer);
      }
      unawaited(repository.synchronize(customer.businessId));

      if (!context.mounted) return;
      await showAppStatusSheet(
        context,
        type: AppStatusType.success,
        title: context.l10n.successTitle,
        message: customer.isArchived
            ? context.l10n.customerRestored
            : context.l10n.customerArchived,
        actionLabel: context.l10n.doneLabel,
      );
      if (!context.mounted) return;
      if (!customer.isArchived) context.go('/customers');
    } catch (_) {
      if (!context.mounted) return;
      await showAppStatusSheet(
        context,
        type: AppStatusType.danger,
        title: context.l10n.errorTitle,
        message: context.l10n.customerStatusChangeFailed,
        actionLabel: context.l10n.okayLabel,
      );
    }
  }
}

class _CustomerDetailView extends StatelessWidget {
  const _CustomerDetailView({
    required this.customer,
    required this.onBack,
    required this.onMore,
    required this.onMeasurements,
    required this.onUnavailable,
  });

  final CustomerRecord customer;
  final VoidCallback onBack;
  final VoidCallback onMore;
  final VoidCallback onMeasurements;
  final VoidCallback onUnavailable;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: _CustomerHero(
            customer: customer,
            onBack: onBack,
            onMore: onMore,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 36),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!customer.isArchived) ...[
                  _SectionTitle(context.l10n.customerQuickActions),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickAction(
                          assetName: 'assets/icons/measurements.svg',
                          label: context.l10n.dashboardMeasurements,
                          onTap: onMeasurements,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickAction(
                          assetName: 'assets/icons/orders.svg',
                          label: context.l10n.dashboardNewOrder,
                          onTap: onUnavailable,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickAction(
                          assetName: 'assets/icons/wallet.svg',
                          label: context.l10n.dashboardRecordPayment,
                          onTap: onUnavailable,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                ],
                _SectionTitle(context.l10n.customerPersonalInformation),
                const SizedBox(height: 12),
                _ReadOnlyField(
                  label: context.l10n.customerName,
                  value: customer.name,
                ),
                const SizedBox(height: 12),
                _ReadOnlyField(
                  label: context.l10n.customerPhone,
                  value: customer.phoneE164 ?? context.l10n.notProvided,
                  forceLtr: customer.phoneE164 != null,
                ),
                const SizedBox(height: 12),
                _ReadOnlyField(
                  label: context.l10n.customerAlternatePhone,
                  value:
                      customer.alternatePhoneE164 ?? context.l10n.notProvided,
                  forceLtr: customer.alternatePhoneE164 != null,
                ),
                const SizedBox(height: 12),
                _ReadOnlyField(
                  label: context.l10n.customerAddress,
                  value: customer.address ?? context.l10n.notProvided,
                  multiline: true,
                ),
                const SizedBox(height: 25),
                _SectionTitle(context.l10n.customerNotes),
                const SizedBox(height: 12),
                _ReadOnlyField(
                  value: customer.notes ?? context.l10n.noCustomerNotes,
                  multiline: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CustomerHero extends StatelessWidget {
  const _CustomerHero({
    required this.customer,
    required this.onBack,
    required this.onMore,
  });

  final CustomerRecord customer;
  final VoidCallback onBack;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final material = MaterialLocalizations.of(context);
    final createdAt = customer.createdAt.toLocal();
    final updatedAt = customer.updatedAt.toLocal();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [AppColors.primaryDark, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadii.page),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
          child: Column(
            children: [
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    IconButton(
                      tooltip: material.backButtonTooltip,
                      onPressed: onBack,
                      icon: Icon(
                        Directionality.of(context) == TextDirection.rtl
                            ? Icons.arrow_forward_rounded
                            : Icons.arrow_back_rounded,
                        textDirection: TextDirection.ltr,
                        size: 22,
                      ),
                      color: Colors.white,
                    ),
                    Expanded(
                      child: Text(
                        context.l10n.customerDetails,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: context.l10n.customerMoreActions,
                      onPressed: onMore,
                      icon: const Icon(Icons.more_vert_rounded, size: 24),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    CustomerAvatar(
                      localPhotoPath: customer.photoLocalPath,
                      photoUrl: customer.photoUrl,
                      size: 70,
                      borderRadius: 18,
                      iconSize: 32,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 7),
                          _StatusPill(archived: customer.isArchived),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _MetaCard(
                        assetName: 'assets/icons/calendar.svg',
                        label: context.l10n.customerCreated,
                        value: material.formatMediumDate(createdAt),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetaCard(
                        assetName: 'assets/icons/time_circle.svg',
                        label: context.l10n.customerUpdated,
                        value: material.formatMediumDate(updatedAt),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.archived});

  final bool archived;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: archived
              ? const Color(0xFFFFECEE)
              : Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          archived
              ? context.l10n.customerStatusArchived
              : context.l10n.customerStatusActive,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: archived ? AppColors.danger : Colors.white,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _MetaCard extends StatelessWidget {
  const _MetaCard({
    required this.assetName,
    required this.label,
    required this.value,
  });

  final String assetName;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.17),
              borderRadius: BorderRadius.circular(11),
            ),
            child: SvgPicture.asset(
              assetName,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 10.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.assetName,
    required this.label,
    required this.onTap,
  });

  final String assetName;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadii.card),
      shadowColor: const Color(0x152A2040),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Container(
          height: 88,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 11),
          child: Column(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.lavender,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  assetName,
                  width: 19,
                  height: 19,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.ink,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    height: 1.15,
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

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.value,
    this.label,
    this.forceLtr = false,
    this.multiline = false,
  });

  final String value;
  final String? label;
  final bool forceLtr;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: multiline ? 76 : 66),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(AppRadii.control),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: const Color(0xFF9692A2), fontSize: 11),
            ),
            const SizedBox(height: 3),
          ],
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              value,
              textDirection: forceLtr ? TextDirection.ltr : null,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.ink,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge
          ?.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
    );
  }
}

class _CustomerNotFound extends StatelessWidget {
  const _CustomerNotFound({required this.onBack, this.message});

  final VoidCallback onBack;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.lavender,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/icons/customers.svg',
                  width: 30,
                  height: 30,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message ?? context.l10n.customerNotFound,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onBack,
                child: Text(context.l10n.customersTitle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
