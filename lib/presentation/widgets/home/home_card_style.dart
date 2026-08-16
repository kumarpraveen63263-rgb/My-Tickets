import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

/// Shared visual language for every Home poster card (Movies, Theatres, Events,
/// Metro) so the four sections read as one cohesive design system rather than
/// four different styles. Centralises radius, shadow and ripple treatment.
class HomeCardStyle {
  HomeCardStyle._();

  static const double radius = AppDimensions.radiusLarge; // 16

  static const List<BoxShadow> shadow = [
    BoxShadow(color: Color(0x33000000), blurRadius: 14, offset: Offset(0, 6)),
  ];

  static BorderRadius get borderRadius => BorderRadius.circular(radius);

  /// Wraps [child] in a rounded, shadowed, ripple-clipped tappable surface.
  static Widget tappable({required Widget child, required VoidCallback onTap}) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: shadow,
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias, // clips the ink ripple to rounded corners
        child: InkWell(onTap: onTap, child: child),
      ),
    );
  }
}
