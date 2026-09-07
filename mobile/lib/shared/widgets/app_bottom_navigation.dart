import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tailor_app/core/theme/app_theme.dart';
import 'package:tailor_app/shared/extensions/localization_extension.dart';

enum AppSection { home, customers, calendar, orders, profile }

class TailorBottomNavigation extends StatelessWidget {
  const TailorBottomNavigation({required this.selected, super.key});

  final AppSection selected;

  @override
  Widget build(BuildContext context) {
    final items = <_NavigationDestination>[
      _NavigationDestination(
        section: AppSection.home,
        assetName: 'assets/icons/home.svg',
        label: context.l10n.dashboardHome,
        onTap: () => context.go('/dashboard'),
      ),
      _NavigationDestination(
        section: AppSection.customers,
        assetName: 'assets/icons/customers.svg',
        label: context.l10n.dashboardCustomers,
        onTap: () => context.go('/customers'),
      ),
      _NavigationDestination(
        section: AppSection.calendar,
        assetName: 'assets/icons/calendar.svg',
        label: context.l10n.dashboardCalendar,
      ),
      _NavigationDestination(
        section: AppSection.orders,
        assetName: 'assets/icons/orders.svg',
        label: context.l10n.dashboardOrders,
      ),
      _NavigationDestination(
        section: AppSection.profile,
        assetName: 'assets/icons/profile.svg',
        label: context.l10n.dashboardProfile,
      ),
    ];

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: AlignmentDirectional.centerStart,
            end: AlignmentDirectional.centerEnd,
            colors: [AppColors.primaryDark, AppColors.primary],
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: const [
            BoxShadow(
              color: Color(0x285F33E1),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: SizedBox(
          height: AppSizes.navigationHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final item in items)
                  _NavItem(
                    destination: item,
                    selected: item.section == selected,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationDestination {
  const _NavigationDestination({
    required this.section,
    required this.assetName,
    required this.label,
    this.onTap,
  });

  final AppSection section;
  final String assetName;
  final String label;
  final VoidCallback? onTap;
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.destination, required this.selected});

  final _NavigationDestination destination;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: InkWell(
        onTap: destination.onTap,
        borderRadius: BorderRadius.circular(22),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 38,
            constraints: BoxConstraints(
              minWidth: 38,
              maxWidth: selected ? 112 : 38,
            ),
            padding: EdgeInsets.symmetric(horizontal: selected ? 10 : 8),
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  destination.assetName,
                  width: AppSizes.icon,
                  height: AppSizes.icon,
                  colorFilter: ColorFilter.mode(
                    selected
                        ? AppColors.primary
                        : Colors.white.withValues(alpha: 0.68),
                    BlendMode.srcIn,
                  ),
                  excludeFromSemantics: true,
                ),
                if (selected) ...[
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      destination.label,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
