import 'dart:async';
import 'dart:math' as math;

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
import 'package:tailor_app/shared/widgets/gradient_page_header.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final _searchController = TextEditingController();
  Timer? _syncTimer;
  String? _activeBusinessId;
  bool _syncing = false;
  bool _showArchived = false;

  @override
  void dispose() {
    _syncTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _ensureSync(String businessId) {
    if (_activeBusinessId == businessId) return;
    _activeBusinessId = businessId;
    _syncTimer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback((_) => _synchronize());
    _syncTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _synchronize(silent: true),
    );
  }

  Future<void> _synchronize({bool silent = false}) async {
    final businessId = _activeBusinessId;
    if (businessId == null || _syncing) return;
    if (mounted) setState(() => _syncing = true);

    try {
      final report = await ref
          .read(customerRepositoryProvider)
          .synchronize(businessId);
      if (!mounted) return;
      if (!silent && report.online && report.pushed > 0) {
        unawaited(
          showAppStatusSheet(
            context,
            type: AppStatusType.success,
            title: context.l10n.syncCompleteTitle,
            message: context.l10n.customerChangesSynced,
            actionLabel: context.l10n.doneLabel,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
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

    _ensureSync(business.id);
    final customers = ref.watch(customersProvider(business.id));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go('/dashboard');
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.canvas,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.push('/customers/new'),
            elevation: 3,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            icon: SvgPicture.asset(
              'assets/icons/add_user.svg',
              width: 19,
              height: 19,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              context.l10n.addCustomer,
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: Colors.white, fontSize: 13),
            ),
          ),
          body: Column(
            children: [
              GradientPageHeader(
                title: context.l10n.customersTitle,
                onBack: () => context.go('/dashboard'),
                bottom: _CustomerTabs(
                  showArchived: _showArchived,
                  onChanged: (value) => setState(() => _showArchived = value),
                ),
              ),
              Expanded(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppColors.canvas,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppRadii.page),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: context.l10n.customerSearchHint,
                            prefixIcon: null,
                            suffixIcon: _searchController.text.isEmpty
                                ? const Icon(Icons.search_rounded, size: 20)
                                : IconButton(
                                    tooltip: context.l10n.clearSearch,
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 19,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: customers.when(
                          data: (items) => _CustomerResults(
                            customers: _filter(items),
                            hasSearch: _searchController.text.trim().isNotEmpty,
                            showingArchived: _showArchived,
                            onRefresh: _synchronize,
                          ),
                          loading: () => const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                          error: (_, _) => _LoadError(onRetry: _synchronize),
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

  List<CustomerRecord> _filter(List<CustomerRecord> customers) {
    final query = _searchController.text.trim().toLowerCase();
    return customers
        .where((customer) => customer.isArchived == _showArchived)
        .where(
          (customer) =>
              query.isEmpty ||
              customer.name.toLowerCase().contains(query) ||
              (customer.phoneE164?.contains(query) ?? false) ||
              (customer.alternatePhoneE164?.contains(query) ?? false),
        )
        .toList(growable: false);
  }
}

class _CustomerTabs extends StatelessWidget {
  const _CustomerTabs({required this.showArchived, required this.onChanged});

  final bool showArchived;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primaryDark.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _CustomerTab(
            label: context.l10n.customerStatusActive,
            selected: !showArchived,
            onTap: () => onChanged(false),
          ),
          _CustomerTab(
            label: context.l10n.customerStatusArchived,
            selected: showArchived,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _CustomerTab extends StatelessWidget {
  const _CustomerTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: selected
                    ? AppColors.primary
                    : Colors.white.withValues(alpha: 0.72),
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomerResults extends StatelessWidget {
  const _CustomerResults({
    required this.customers,
    required this.hasSearch,
    required this.showingArchived,
    required this.onRefresh,
  });

  final List<CustomerRecord> customers;
  final bool hasSearch;
  final bool showingArchived;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (customers.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 20, 28, 96),
                child: Center(
                  child: _EmptyCustomers(
                    hasSearch: hasSearch,
                    showingArchived: showingArchived,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        clipBehavior: Clip.none,
        padding: const EdgeInsets.fromLTRB(20, 2, 20, 96),
        itemCount: customers.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) => _AnimatedCustomerTile(
          key: ValueKey(customers[index].clientUuid),
          index: index,
          child: _CustomerTile(
            customer: customers[index],
            onTap: () =>
                context.push('/customers/${customers[index].clientUuid}'),
          ),
        ),
      ),
    );
  }
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({required this.customer, required this.onTap});

  final CustomerRecord customer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: Colors.white),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D2A2040),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadii.card),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 70),
            padding: const EdgeInsetsDirectional.fromSTEB(12, 11, 10, 11),
            child: Row(
              children: [
                CustomerAvatar(
                  localPhotoPath: customer.photoLocalPath,
                  photoUrl: customer.photoUrl,
                  size: 44,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        customer.phoneE164 ?? context.l10n.noPhoneNumber,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.ltr,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 19,
                  color: Color(0xFFAAA5B5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedCustomerTile extends StatefulWidget {
  const _AnimatedCustomerTile({
    required this.index,
    required this.child,
    super.key,
  });

  final int index;
  final Widget child;

  @override
  State<_AnimatedCustomerTile> createState() => _AnimatedCustomerTileState();
}

class _AnimatedCustomerTileState extends State<_AnimatedCustomerTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _opacity = curve;
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(curve);
    WidgetsBinding.instance.addPostFrameCallback((_) => _enter());
  }

  Future<void> _enter() async {
    final delay = Duration(milliseconds: math.min(widget.index * 45, 225));
    await Future<void>.delayed(delay);
    if (mounted) await _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}

class _EmptyCustomers extends StatelessWidget {
  const _EmptyCustomers({
    required this.hasSearch,
    required this.showingArchived,
  });

  final bool hasSearch;
  final bool showingArchived;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 74,
          height: 74,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.lavender,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            'assets/icons/customers.svg',
            width: 32,
            height: 32,
            colorFilter: const ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          hasSearch
              ? context.l10n.noCustomerMatches
              : showingArchived
              ? context.l10n.noArchivedCustomersTitle
              : context.l10n.noCustomersTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 7),
        Text(
          hasSearch
              ? context.l10n.tryAnotherSearch
              : showingArchived
              ? context.l10n.noArchivedCustomersMessage
              : context.l10n.noCustomersMessage,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.l10n.customerLoadFailed),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: Text(context.l10n.retryLabel)),
        ],
      ),
    );
  }
}
