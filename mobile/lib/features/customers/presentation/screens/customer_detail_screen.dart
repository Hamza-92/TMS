import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/features/auth/application/auth_controller.dart';
import 'package:tailor_app/features/customers/application/customer_providers.dart';
import 'package:tailor_app/features/customers/data/customer_repository.dart';
import 'package:tailor_app/features/customers/domain/customer.dart';
import 'package:tailor_app/features/customers/presentation/widgets/customer_avatar.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';
import 'package:tailor_app/shared/widgets/app_status_sheet.dart';

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

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppRadii.page),
          ),
        ),
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [AppColors.primaryDark, AppColors.primaryLight],
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(AppRadii.page),
            ),
          ),
        ),
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => context.go('/customers'),
          icon: Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.arrow_forward_rounded
                : Icons.arrow_back_rounded,
            textDirection: TextDirection.ltr,
            size: 22,
          ),
        ),
        title: Text(
          context.l10n.customerDetails,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (customer.valueOrNull case final record?)
            IconButton(
              tooltip: context.l10n.editCustomer,
              onPressed: record.isArchived
                  ? null
                  : () => context.push('/customers/$clientUuid/edit'),
              icon: const Icon(Icons.edit_outlined, size: 20),
            ),
        ],
      ),
      body: ColoredBox(
        color: AppColors.canvas,
        child: customer.when(
          data: (record) => record == null
              ? Center(child: Text(context.l10n.customerNotFound))
              : _CustomerDetails(
                  customer: record,
                  onChangeStatus: () => _changeStatus(context, ref, record),
                ),
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (_, _) => Center(child: Text(context.l10n.customerLoadFailed)),
        ),
      ),
    );
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
            type: AppStatusType.danger,
            title: context.l10n.archiveCustomer,
            message: context.l10n.archiveCustomerMessage,
            confirmLabel: context.l10n.archiveLabel,
            cancelLabel: context.l10n.cancelLabel,
          );
    if (!shouldContinue) return;

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
  }
}

class _CustomerDetails extends StatelessWidget {
  const _CustomerDetails({
    required this.customer,
    required this.onChangeStatus,
  });

  final CustomerRecord customer;
  final VoidCallback onChangeStatus;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      children: [
        _ProfileCard(customer: customer),
        const SizedBox(height: 20),
        Text(
          context.l10n.customerContactInformation,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 9),
        _InformationCard(
          children: [
            _DetailRow(
              icon: Icons.phone_outlined,
              label: context.l10n.customerPhone,
              value: customer.phoneE164 ?? context.l10n.notProvided,
              forceLtr: customer.phoneE164 != null,
            ),
            _DetailRow(
              icon: Icons.phone_forwarded_outlined,
              label: context.l10n.customerAlternatePhone,
              value: customer.alternatePhoneE164 ?? context.l10n.notProvided,
              forceLtr: customer.alternatePhoneE164 != null,
            ),
            _DetailRow(
              icon: Icons.location_on_outlined,
              label: context.l10n.customerAddress,
              value: customer.address ?? context.l10n.notProvided,
              last: true,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          context.l10n.customerNotes,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 9),
        _InformationCard(
          children: [
            Text(
              customer.notes ?? context.l10n.noCustomerNotes,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(fontSize: 13, height: 1.5),
            ),
          ],
        ),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: onChangeStatus,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            foregroundColor: customer.isArchived
                ? const Color(0xFF168B75)
                : const Color(0xFFC34E5A),
            side: BorderSide(
              color: customer.isArchived
                  ? const Color(0xFF9ADBCB)
                  : const Color(0xFFF0BEC3),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          icon: Icon(
            customer.isArchived
                ? Icons.restore_rounded
                : Icons.archive_outlined,
          ),
          label: Text(
            customer.isArchived
                ? context.l10n.restoreCustomer
                : context.l10n.archiveCustomer,
          ),
        ),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.customer});

  final CustomerRecord customer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D2A2040),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CustomerAvatar(
            localPhotoPath: customer.photoLocalPath,
            photoUrl: customer.photoUrl,
            size: 62,
            borderRadius: 16,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: customer.isArchived
                        ? const Color(0xFFFFECEE)
                        : AppColors.mint,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    customer.isArchived
                        ? context.l10n.customerStatusArchived
                        : context.l10n.customerStatusActive,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: customer.isArchived
                          ? const Color(0xFFC34E5A)
                          : const Color(0xFF168B75),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
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

class _InformationCard extends StatelessWidget {
  const _InformationCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A20202A),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.forceLtr = false,
    this.last = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool forceLtr;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.lavender,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 17, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(fontSize: 10.5),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  textDirection: forceLtr ? TextDirection.ltr : null,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
