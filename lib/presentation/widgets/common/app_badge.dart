import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

enum AppBadgeVariant { soft, solid, outline }

class AppBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;
  final IconData? icon;
  final AppBadgeVariant variant;

  const AppBadge({
    super.key,
    required this.label,
    this.color = AppColors.success,
    this.textColor,
    this.icon,
    this.variant = AppBadgeVariant.soft,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Border? border;

    switch (variant) {
      case AppBadgeVariant.soft:
        bg = color.withValues(alpha: 0.12);
        fg = textColor ?? color;
        border = Border.all(color: color.withValues(alpha: 0.25));
        break;
      case AppBadgeVariant.solid:
        bg = color;
        fg = textColor ?? Colors.white;
        border = null;
        break;
      case AppBadgeVariant.outline:
        bg = Colors.transparent;
        fg = textColor ?? color;
        border = Border.all(color: color);
        break;
    }

    return Semantics(
      label: label,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingSmall,
          vertical: 3,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          border: border,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: fg),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: fg,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DotBadge extends StatelessWidget {
  final int count;
  final Widget child;

  const DotBadge({super.key, required this.count, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (count > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Semantics(
              label: '$count notifications',
              child: Container(
                padding: const EdgeInsets.all(3),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count > 9 ? '9+' : '$count',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
