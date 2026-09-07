import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/features/auth/application/auth_controller.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';
import 'package:tailor_app/shared/widgets/app_bottom_navigation.dart';
import 'package:tailor_app/shared/widgets/app_status_sheet.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final authState = auth.valueOrNull;

    if (auth.isLoading && authState == null) {
      return const _DashboardBootstrapLoading();
    }

    if (authState is SignedOut) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/welcome');
      });
      return const _DashboardBootstrapLoading();
    }

    if (authState is SignedIn) {
      final business = authState.business;
      if (business != null && !business.canUseAppAt(DateTime.now())) {
        return _AccountAccessPaused(
          reason: business.access.reason,
          loading: auth.isLoading,
          onRetry: () async {
            try {
              await ref.read(authControllerProvider.notifier).refreshSession();
            } catch (_) {
              if (!context.mounted) return;
              await showAppStatusSheet(
                context,
                type: AppStatusType.danger,
                title: context.l10n.errorTitle,
                message: context.l10n.accountAccessUnavailableMessage,
                actionLabel: context.l10n.okayLabel,
              );
            }
          },
          onSignOut: () async {
            await ref.read(authControllerProvider.notifier).logout();
            if (context.mounted) context.go('/welcome');
          },
        );
      }
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.canvas,
        bottomNavigationBar: const TailorBottomNavigation(
          selected: AppSection.home,
        ),
        body: CustomScrollView(
          key: const ValueKey('dashboard-root'),
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: _DashboardHeader()),
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                AppSpacing.page,
                20,
                AppSpacing.page,
                112,
              ),
              sliver: const SliverToBoxAdapter(
                child: Column(
                  children: [
                    _TodayCard(),
                    SizedBox(height: AppSpacing.section),
                    _SectionTitle(titleKey: _DashboardText.quickActions),
                    SizedBox(height: 12),
                    _QuickActions(),
                    SizedBox(height: AppSpacing.section),
                    _SectionTitle(titleKey: _DashboardText.attentionNeeded),
                    SizedBox(height: 12),
                    _AttentionCards(),
                    SizedBox(height: AppSpacing.section),
                    _SectionTitle(
                      titleKey: _DashboardText.recentOrders,
                      trailingKey: _DashboardText.seeAll,
                    ),
                    SizedBox(height: 12),
                    _RecentOrders(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardBootstrapLoading extends StatelessWidget {
  const _DashboardBootstrapLoading();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: const Scaffold(
        backgroundColor: AppColors.canvas,
        body: Stack(
          children: [
            Positioned.fill(child: _DashboardBackground()),
            Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountAccessPaused extends StatelessWidget {
  const _AccountAccessPaused({
    required this.reason,
    required this.loading,
    required this.onRetry,
    required this.onSignOut,
  });

  final String? reason;
  final bool loading;
  final Future<void> Function() onRetry;
  final Future<void> Function() onSignOut;

  @override
  Widget build(BuildContext context) {
    final message = switch (reason) {
      final value? when value.startsWith('membership_') =>
        context.l10n.membershipInactiveMessage,
      final value? when value.startsWith('business_') =>
        context.l10n.businessSuspendedMessage,
      final value? when value.startsWith('subscription_') =>
        context.l10n.subscriptionExpiredMessage,
      _ => context.l10n.accountAccessUnavailableMessage,
    };

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: Stack(
          children: [
            const Positioned.fill(child: _DashboardBackground()),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x142A2040),
                            blurRadius: 24,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: AppColors.lavender,
                              shape: BoxShape.circle,
                            ),
                            child: const _SvgIcon(
                              assetName: 'assets/icons/lock.svg',
                              size: 27,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            context.l10n.accountAccessPaused,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontSize: 22),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            message,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(height: 1.5),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: FilledButton(
                              onPressed: loading ? null : onRetry,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: loading
                                  ? const SizedBox.square(
                                      dimension: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.2,
                                      ),
                                    )
                                  : Text(context.l10n.checkAccessAgain),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextButton(
                            onPressed: loading ? null : onSignOut,
                            child: Text(context.l10n.signOut),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _DashboardText { quickActions, attentionNeeded, recentOrders, seeAll }

extension on _DashboardText {
  String value(BuildContext context) => switch (this) {
    _DashboardText.quickActions => context.l10n.dashboardQuickActions,
    _DashboardText.attentionNeeded => context.l10n.dashboardAttentionNeeded,
    _DashboardText.recentOrders => context.l10n.dashboardRecentOrders,
    _DashboardText.seeAll => context.l10n.dashboardSeeAll,
  };
}

class _DashboardBackground extends StatelessWidget {
  const _DashboardBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFEFFFE), Color(0xFFFEFDFF), Color(0xFFFFFEFA)],
          stops: [0, 0.52, 1],
        ),
      ),
      child: const Stack(
        children: [
          Positioned(
            top: -80,
            left: -105,
            child: _Glow(color: Color(0xFFE4F9F1), size: 300, opacity: 0.78),
          ),
          Positioned(
            top: 105,
            left: -155,
            child: _Glow(color: AppColors.lavender, size: 390, opacity: 0.34),
          ),
          Positioned(
            top: 230,
            right: -185,
            child: _Glow(color: Color(0xFFFFF3C9), size: 430, opacity: 0.56),
          ),
          Positioned(
            top: 330,
            left: -210,
            child: _Glow(color: Color(0xFFDDF4FF), size: 510, opacity: 0.72),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size, required this.opacity});

  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends ConsumerWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider).valueOrNull;
    final signedIn = authState is SignedIn ? authState : null;
    final user = signedIn?.user;
    final business = signedIn?.business;
    final displayName = business?.name ?? user?.name ?? context.l10n.appName;
    final avatarName = user?.name ?? displayName;
    final greeting = user?.name.trim().isNotEmpty == true
        ? context.l10n.dashboardGreeting(user!.name)
        : context.l10n.dashboardGoodMorning;
    final initial = avatarName.trim().isEmpty
        ? 'T'
        : avatarName.trim().characters.first.toUpperCase();

    return Container(
      height: 154,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PopupMenuButton<String>(
              tooltip: context.l10n.dashboardProfile,
              onSelected: (value) async {
                if (value != 'logout') return;
                await ref.read(authControllerProvider.notifier).logout();
                if (context.mounted) context.go('/');
              },
              color: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: AppColors.border),
              ),
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      const Icon(Icons.logout_rounded, size: 19),
                      const SizedBox(width: 10),
                      Text(context.l10n.signOut),
                    ],
                  ),
                ),
              ],
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.34),
                  ),
                ),
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    displayName,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            _IconButton(
              assetName: 'assets/icons/notification.svg',
              semanticLabel: context.l10n.dashboardNotifications,
              showBadge: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.assetName,
    required this.semanticLabel,
    this.showBadge = false,
  });

  final String assetName;
  final String semanticLabel;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            ),
            child: _SvgIcon(
              assetName: assetName,
              size: 20,
              color: Colors.white,
            ),
          ),
          if (showBadge)
            const PositionedDirectional(
              top: 4,
              end: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: SizedBox.square(dimension: 7),
              ),
            ),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(18, 17, 15, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3D6431EC),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.dashboardTodaysWork,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 5),
                Text(
                  context.l10n.dashboardOrdersDueToday,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.76),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 13),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    context.l10n.dashboardViewOrders,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox.square(
            dimension: 82,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.square(
                  dimension: 76,
                  child: CircularProgressIndicator(
                    value: 5 / 7,
                    strokeWidth: 7,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.white.withValues(alpha: 0.22),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '5/7',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      context.l10n.dashboardCompleted,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.titleKey, this.trailingKey});

  final _DashboardText titleKey;
  final _DashboardText? trailingKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            titleKey.value(context),
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontSize: 17),
          ),
        ),
        if (trailingKey != null)
          Text(
            trailingKey!.value(context),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickActionData(
        'assets/icons/add_user.svg',
        context.l10n.dashboardAddCustomer,
        AppColors.blush,
        const Color(0xFFE85F97),
        onTap: () => context.push('/customers/new'),
      ),
      _QuickActionData(
        'assets/icons/work.svg',
        context.l10n.dashboardNewOrder,
        AppColors.lavender,
        AppColors.primary,
      ),
      _QuickActionData(
        'assets/icons/measurements.svg',
        context.l10n.dashboardMeasurements,
        const Color(0xFFFFF1D9),
        const Color(0xFFF29B38),
      ),
      _QuickActionData(
        'assets/icons/wallet.svg',
        context.l10n.dashboardRecordPayment,
        AppColors.mint,
        const Color(0xFF22A68A),
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F2A2040),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final action in actions)
            Expanded(child: _QuickAction(data: action)),
        ],
      ),
    );
  }
}

class _QuickActionData {
  const _QuickActionData(
    this.assetName,
    this.label,
    this.fill,
    this.color, {
    this.onTap,
  });

  final String assetName;
  final String label;
  final Color fill;
  final Color color;
  final VoidCallback? onTap;
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.data});

  final _QuickActionData data;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: data.label,
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: data.fill,
                borderRadius: BorderRadius.circular(14),
              ),
              child: _SvgIcon(
                assetName: data.assetName,
                size: 21,
                color: data.color,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              data.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.ink,
                fontSize: 10.5,
                height: 1.18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttentionCards extends StatelessWidget {
  const _AttentionCards();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AttentionCard(
            assetName: 'assets/icons/time_circle.svg',
            label: context.l10n.dashboardOverdueOrders,
            value: context.l10n.dashboardOverdueOrdersValue,
            fill: const Color(0xFFFFECE8),
            color: const Color(0xFFEE765F),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _AttentionCard(
            assetName: 'assets/icons/wallet.svg',
            label: context.l10n.dashboardPendingPayments,
            value: context.l10n.dashboardPendingPaymentsValue,
            fill: const Color(0xFFFFF5D9),
            color: const Color(0xFFE6A521),
          ),
        ),
      ],
    );
  }
}

class _AttentionCard extends StatelessWidget {
  const _AttentionCard({
    required this.assetName,
    required this.label,
    required this.value,
    required this.fill,
    required this.color,
  });

  final String assetName;
  final String label;
  final String value;
  final Color fill;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _SvgIcon(assetName: assetName, size: 19, color: color),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(color: AppColors.ink, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 10,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
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

class _RecentOrders extends StatelessWidget {
  const _RecentOrders();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _OrderRow(
          customer: 'Ayesha Khan',
          detail: context.l10n.dashboardOrderDetailOne,
          status: context.l10n.dashboardReady,
          statusColor: const Color(0xFF1F9E82),
          statusFill: AppColors.mint,
        ),
        const SizedBox(height: 9),
        _OrderRow(
          customer: 'Sana Malik',
          detail: context.l10n.dashboardOrderDetailTwo,
          status: context.l10n.dashboardInProgress,
          statusColor: const Color(0xFFDF7A40),
          statusFill: const Color(0xFFFFEEE4),
        ),
      ],
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({
    required this.customer,
    required this.detail,
    required this.status,
    required this.statusColor,
    required this.statusFill,
  });

  final String customer;
  final String detail;
  final String status;
  final Color statusColor;
  final Color statusFill;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 11, 11, 11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.72)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.lavender,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const _SvgIcon(
              assetName: 'assets/icons/work.svg',
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(fontSize: 10.5, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: statusFill,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              status,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: statusColor,
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SvgIcon extends StatelessWidget {
  const _SvgIcon({
    required this.assetName,
    required this.size,
    required this.color,
  });

  final String assetName;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      excludeFromSemantics: true,
    );
  }
}
