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
import 'package:tailor_app/shared/widgets/app_bottom_navigation.dart';
import 'package:tailor_app/shared/widgets/app_status_sheet.dart';
import 'package:tailor_app/shared/widgets/gradient_page_header.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final _searchController = TextEditingController();
  final _pageController = PageController();
  Timer? _syncTimer;
  String? _activeBusinessId;
  bool _syncing = false;
  bool _showArchived = false;
  bool _batchUpdating = false;
  final Set<String> _selectedCustomerIds = <String>{};

  bool get _isSelecting => _selectedCustomerIds.isNotEmpty;

  @override
  void dispose() {
    _syncTimer?.cancel();
    _searchController.dispose();
    _pageController.dispose();
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

  void _clearSelection() {
    if (_selectedCustomerIds.isEmpty) return;
    setState(_selectedCustomerIds.clear);
  }

  void _toggleSelection(String clientUuid) {
    setState(() {
      if (!_selectedCustomerIds.add(clientUuid)) {
        _selectedCustomerIds.remove(clientUuid);
      }
    });
  }

  void _selectAll(List<CustomerRecord> visibleCustomers) {
    if (visibleCustomers.isEmpty) return;
    setState(() {
      _selectedCustomerIds.addAll(
        visibleCustomers.map((customer) => customer.clientUuid),
      );
    });
  }

  void _changeCustomerTab(bool showArchived) {
    if (_showArchived == showArchived) return;
    setState(() {
      _showArchived = showArchived;
      _selectedCustomerIds.clear();
    });
    if (_pageController.hasClients) {
      unawaited(
        _pageController.animateToPage(
          showArchived ? 1 : 0,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
        ),
      );
    }
  }

  void _handlePageChanged(int page) {
    final showArchived = page == 1;
    if (_showArchived == showArchived) return;
    setState(() {
      _showArchived = showArchived;
      _selectedCustomerIds.clear();
    });
  }

  Future<void> _changeSelectedStatus(
    List<CustomerRecord> customers, {
    required bool archive,
  }) async {
    final selected = customers
        .where((customer) => _selectedCustomerIds.contains(customer.clientUuid))
        .toList(growable: false);
    if (selected.isEmpty || _batchUpdating) return;

    final confirmed = await showAppConfirmationSheet(
      context,
      type: archive ? AppStatusType.warning : AppStatusType.info,
      title: archive
          ? context.l10n.archiveSelectedCustomers
          : context.l10n.restoreSelectedCustomers,
      message: archive
          ? context.l10n.archiveSelectedCustomersMessage(selected.length)
          : context.l10n.restoreSelectedCustomersMessage(selected.length),
      confirmLabel: archive
          ? context.l10n.archiveLabel
          : context.l10n.restoreCustomer,
      cancelLabel: context.l10n.cancelLabel,
    );
    if (!confirmed || !mounted) return;

    setState(() => _batchUpdating = true);
    try {
      final repository = ref.read(customerRepositoryProvider);
      if (archive) {
        await repository.archiveMany(selected);
      } else {
        await repository.restoreMany(selected);
      }
      if (!mounted) return;
      setState(_selectedCustomerIds.clear);
      unawaited(_synchronize(silent: true));
      await showAppStatusSheet(
        context,
        type: AppStatusType.success,
        title: context.l10n.successTitle,
        message: archive
            ? context.l10n.customersArchived(selected.length)
            : context.l10n.customersRestored(selected.length),
        actionLabel: context.l10n.doneLabel,
      );
    } catch (_) {
      if (!mounted) return;
      await showAppStatusSheet(
        context,
        type: AppStatusType.danger,
        title: context.l10n.errorTitle,
        message: context.l10n.customerStatusChangeFailed,
        actionLabel: context.l10n.okayLabel,
      );
    } finally {
      if (mounted) setState(() => _batchUpdating = false);
    }
  }

  Future<void> _deleteSelectedPermanently(
    List<CustomerRecord> customers,
  ) async {
    final selected = customers
        .where(
          (customer) =>
              customer.isArchived &&
              _selectedCustomerIds.contains(customer.clientUuid),
        )
        .toList(growable: false);
    if (selected.isEmpty || _batchUpdating) return;

    final confirmed = await showAppConfirmationSheet(
      context,
      type: AppStatusType.danger,
      title: context.l10n.deletePermanentlyTitle,
      message: context.l10n.deleteSelectedPermanentlyMessage(selected.length),
      confirmLabel: context.l10n.deleteLabel,
      cancelLabel: context.l10n.cancelLabel,
    );
    if (!confirmed || !mounted) return;

    setState(() => _batchUpdating = true);
    try {
      await ref
          .read(customerRepositoryProvider)
          .deletePermanentlyMany(selected);
      if (!mounted) return;
      setState(_selectedCustomerIds.clear);
      unawaited(_synchronize(silent: true));
      await showAppStatusSheet(
        context,
        type: AppStatusType.success,
        title: context.l10n.successTitle,
        message: context.l10n.customersDeletedPermanently(selected.length),
        actionLabel: context.l10n.doneLabel,
      );
    } catch (_) {
      if (!mounted) return;
      await showAppStatusSheet(
        context,
        type: AppStatusType.danger,
        title: context.l10n.errorTitle,
        message: context.l10n.customerStatusChangeFailed,
        actionLabel: context.l10n.okayLabel,
      );
    } finally {
      if (mounted) setState(() => _batchUpdating = false);
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
    final allCustomers = customers.valueOrNull ?? const <CustomerRecord>[];
    final visibleCustomers = _filter(allCustomers, showArchived: _showArchived);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_isSelecting) {
          _clearSelection();
        } else {
          context.go('/dashboard');
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.canvas,
          bottomNavigationBar: const TailorBottomNavigation(
            selected: AppSection.customers,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: _isSelecting
              ? null
              : Padding(
                  padding: const EdgeInsetsDirectional.only(end: 4),
                  child: FloatingActionButton.extended(
                    heroTag: 'add-customer',
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
                ),
          body: Column(
            children: [
              GradientPageHeader(
                title: _isSelecting
                    ? context.l10n.customersSelected(
                        _selectedCustomerIds.length,
                      )
                    : context.l10n.customersTitle,
                onBack: _isSelecting
                    ? _clearSelection
                    : () => context.go('/dashboard'),
                leading: _isSelecting
                    ? IconButton(
                        tooltip: context.l10n.clearSelection,
                        onPressed: _clearSelection,
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      )
                    : null,
                trailing: _isSelecting
                    ? IconButton(
                        tooltip: context.l10n.selectAllCustomers,
                        onPressed: () => _selectAll(visibleCustomers),
                        icon: const Icon(
                          Icons.select_all_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      )
                    : null,
                bottom: _isSelecting
                    ? _CustomerSelectionActions(
                        archived: _showArchived,
                        loading: _batchUpdating,
                        onArchiveOrRestore: () => _changeSelectedStatus(
                          allCustomers,
                          archive: !_showArchived,
                        ),
                        onDeletePermanently: () =>
                            _deleteSelectedPermanently(allCustomers),
                      )
                    : _CustomerTabs(
                        showArchived: _showArchived,
                        onChanged: _changeCustomerTab,
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
                          data: (items) => PageView(
                            controller: _pageController,
                            physics: _isSelecting
                                ? const NeverScrollableScrollPhysics()
                                : const PageScrollPhysics(),
                            onPageChanged: _handlePageChanged,
                            children: [
                              _CustomerResults(
                                customers: _filter(items, showArchived: false),
                                hasSearch: _searchController.text
                                    .trim()
                                    .isNotEmpty,
                                showingArchived: false,
                                onRefresh: _synchronize,
                                selectedCustomerIds: _selectedCustomerIds,
                                onToggleSelection: _toggleSelection,
                              ),
                              _CustomerResults(
                                customers: _filter(items, showArchived: true),
                                hasSearch: _searchController.text
                                    .trim()
                                    .isNotEmpty,
                                showingArchived: true,
                                onRefresh: _synchronize,
                                selectedCustomerIds: _selectedCustomerIds,
                                onToggleSelection: _toggleSelection,
                              ),
                            ],
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

  List<CustomerRecord> _filter(
    List<CustomerRecord> customers, {
    required bool showArchived,
  }) {
    final query = _searchController.text.trim().toLowerCase();
    return customers
        .where(
          (customer) =>
              customer.status == (showArchived ? 'archived' : 'active'),
        )
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

class _CustomerSelectionActions extends StatelessWidget {
  const _CustomerSelectionActions({
    required this.archived,
    required this.loading,
    required this.onArchiveOrRestore,
    required this.onDeletePermanently,
  });

  final bool archived;
  final bool loading;
  final VoidCallback onArchiveOrRestore;
  final VoidCallback onDeletePermanently;

  @override
  Widget build(BuildContext context) {
    final statusAction = _SelectionButton(
      label: archived
          ? context.l10n.restoreCustomer
          : context.l10n.archiveLabel,
      icon: archived ? Icons.unarchive_outlined : Icons.archive_outlined,
      foreground: archived ? AppColors.success : AppColors.primary,
      loading: loading,
      onPressed: onArchiveOrRestore,
    );

    if (!archived) return statusAction;

    return Row(
      children: [
        Expanded(
          child: _SelectionButton(
            label: context.l10n.deleteLabel,
            icon: Icons.delete_outline_rounded,
            foreground: AppColors.danger,
            loading: false,
            outlined: true,
            onPressed: loading ? null : onDeletePermanently,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: statusAction),
      ],
    );
  }
}

class _SelectionButton extends StatelessWidget {
  const _SelectionButton({
    required this.label,
    required this.icon,
    required this.foreground,
    required this.loading,
    required this.onPressed,
    this.outlined = false,
  });

  final String label;
  final IconData icon;
  final Color foreground;
  final bool loading;
  final VoidCallback? onPressed;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    );
    final iconWidget = loading
        ? SizedBox(
            width: 17,
            height: 17,
            child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
          )
        : Icon(icon, size: 19);
    final labelWidget = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelLarge
          ?.copyWith(color: foreground, fontSize: 12),
    );

    return SizedBox(
      width: double.infinity,
      height: 44,
      child: outlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: foreground,
                side: BorderSide(color: foreground.withValues(alpha: 0.55)),
                shape: shape,
              ),
              icon: iconWidget,
              label: labelWidget,
            )
          : FilledButton.icon(
              onPressed: loading ? null : onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: foreground,
                disabledBackgroundColor: Colors.white.withValues(alpha: 0.7),
                shape: shape,
              ),
              icon: iconWidget,
              label: labelWidget,
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
    required this.selectedCustomerIds,
    required this.onToggleSelection,
  });

  final List<CustomerRecord> customers;
  final bool hasSearch;
  final bool showingArchived;
  final Future<void> Function() onRefresh;
  final Set<String> selectedCustomerIds;
  final ValueChanged<String> onToggleSelection;

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
                padding: const EdgeInsets.fromLTRB(28, 20, 28, 156),
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
        padding: const EdgeInsets.fromLTRB(20, 2, 20, 156),
        itemCount: customers.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) => _AnimatedCustomerTile(
          key: ValueKey(customers[index].clientUuid),
          index: index,
          child: _CustomerTile(
            customer: customers[index],
            selected: selectedCustomerIds.contains(customers[index].clientUuid),
            selectionMode: selectedCustomerIds.isNotEmpty,
            onTap: () {
              if (selectedCustomerIds.isNotEmpty) {
                onToggleSelection(customers[index].clientUuid);
              } else {
                context.push('/customers/${customers[index].clientUuid}');
              }
            },
            onLongPress: () => onToggleSelection(customers[index].clientUuid),
          ),
        ),
      ),
    );
  }
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({
    required this.customer,
    required this.selected,
    required this.selectionMode,
    required this.onTap,
    required this.onLongPress,
  });

  final CustomerRecord customer;
  final bool selected;
  final bool selectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: selected ? AppColors.lavender : Colors.white,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.55)
                : Colors.white,
          ),
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
            onLongPress: onLongPress,
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
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
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
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 160),
                    child: selectionMode
                        ? Icon(
                            selected
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            key: ValueKey(selected),
                            size: 22,
                            color: selected
                                ? AppColors.primary
                                : const Color(0xFFAAA5B5),
                          )
                        : const Icon(
                            Icons.chevron_right_rounded,
                            key: ValueKey('chevron'),
                            size: 19,
                            color: Color(0xFFAAA5B5),
                          ),
                  ),
                ],
              ),
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
