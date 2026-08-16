import '../../core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_typography.dart';

/// Bottom-nav shell. The [StatefulNavigationShell] is the single source of
/// truth for the active tab index and owns one persistent navigator + state
/// per branch (via the underlying IndexedStack), so switching tabs preserves
/// each tab's scroll position and navigation stack.
class MainNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  MainNavigation({super.key, required this.navigationShell});

  List<_NavItem> _items(BuildContext context) => [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: context.tr('Home'),
      color: AppColors.accentMovie,
    ),
    _NavItem(
      icon: Icons.movie_outlined,
      activeIcon: Icons.movie_rounded,
      label: context.tr('Movies'),
      color: AppColors.accentMovie,
    ),
    _NavItem(
      icon: Icons.celebration_outlined,
      activeIcon: Icons.celebration_rounded,
      label: context.tr('Events'),
      color: AppColors.accentEvent,
    ),
    _NavItem(
      icon: Icons.train_outlined,
      activeIcon: Icons.train_rounded,
      label: context.tr('Metro'),
      color: AppColors.accentMetro,
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: context.tr('Profile'),
      color: AppColors.accentMovie,
    ),
  ];

  void _onTap(int index) {
    // Tapping the already-active tab pops that branch back to its root;
    // tapping another tab switches branches (preserving the other stacks).
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _items(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: AppDimensions.bottomNavHeight,
            child: Row(
              children: List.generate(items.length, (index) {
                return _NavButton(
                  item: items[index],
                  isActive: index == navigationShell.currentIndex,
                  onTap: () => _onTap(index),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color color;

  _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.color,
  });
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  _NavButton({required this.item, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? item.color : AppColors.textSecondary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isActive ? 1.18 : 1.0,
              duration: Duration(milliseconds: 160),
              curve: Curves.easeOutBack,
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                color: color,
                size: 24,
              ),
            ),
            SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 160),
              style: AppTypography.caption.copyWith(
                color: color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}
