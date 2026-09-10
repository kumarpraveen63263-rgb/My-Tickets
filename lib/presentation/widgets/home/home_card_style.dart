import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

/// Shared visual language for every Home poster card (Movies, Theatres, Events,
/// Metro) so the four sections read as one cohesive design system.
class HomeCardStyle {
  HomeCardStyle._();

  static const double radius = AppDimensions.radiusLarge; // 16

  static const List<BoxShadow> shadow = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static BorderRadius get borderRadius => BorderRadius.circular(radius);

  /// Wraps [child] in a rounded, bordered, soft-shadowed, ripple-clipped surface.
  static Widget tappable({required Widget child, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: shadow,
        border: Border.all(
          color: AppColors.border,
          width: AppDimensions.cardBorderWidth,
        ),
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: child),
      ),
    );
  }
}
