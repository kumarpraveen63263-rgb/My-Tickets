import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

enum AppButtonVariant { primary, secondary, outlined, ghost, danger }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool fullWidth;
  final IconData? icon;
  final Color? accentColor;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = true,
    this.icon,
    this.accentColor,
  });

  double get _height {
    switch (size) {
      case AppButtonSize.small:
        return AppDimensions.buttonHeightSmall;
      case AppButtonSize.medium:
        return AppDimensions.buttonHeightMedium;
      case AppButtonSize.large:
        return AppDimensions.buttonHeightLarge;
    }
  }

  Color get _accent => accentColor ?? AppColors.accentMovie;

  bool get _disabled => onPressed == null || isLoading;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color:
                  variant == AppButtonVariant.outlined ||
                      variant == AppButtonVariant.ghost
                  ? _accent
                  : Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppDimensions.iconSmall),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: AppTypography.button.copyWith(color: _foregroundColor),
              ),
            ],
          );

    Widget button;
    switch (variant) {
      case AppButtonVariant.primary:
        button = ElevatedButton(
          onPressed: _disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _accent,
            disabledBackgroundColor: _accent.withValues(alpha: 0.4),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          ),
          child: child,
        );
        break;
      case AppButtonVariant.secondary:
        button = ElevatedButton(
          onPressed: _disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surfaceElevated,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          ),
          child: child,
        );
        break;
      case AppButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: _disabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: _disabled ? AppColors.border : _accent),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          ),
          child: child,
        );
        break;
      case AppButtonVariant.ghost:
        button = TextButton(
          onPressed: _disabled ? null : onPressed,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          ),
          child: child,
        );
        break;
      case AppButtonVariant.danger:
        button = ElevatedButton(
          onPressed: _disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.error,
            elevation: 0,
            side: const BorderSide(color: AppColors.error),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
          ),
          child: child,
        );
        break;
    }

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _height,
      child: button,
    );
  }

  Color get _foregroundColor {
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
        return variant == AppButtonVariant.primary
            ? Colors.white
            : AppColors.textPrimary;
      case AppButtonVariant.outlined:
      case AppButtonVariant.ghost:
        return _accent;
      case AppButtonVariant.danger:
        return AppColors.error;
    }
  }
}
