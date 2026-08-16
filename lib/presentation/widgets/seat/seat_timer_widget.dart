import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_utils.dart';

class SeatTimerWidget extends StatelessWidget {
  final Duration remaining;

  const SeatTimerWidget({super.key, required this.remaining});

  @override
  Widget build(BuildContext context) {
    final isLow = remaining.inSeconds < 60;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: isLow
          ? AppColors.error.withValues(alpha: 0.15)
          : AppColors.surfaceElevated,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 16,
            color: isLow ? AppColors.error : AppColors.textSecondary,
          ),
          const SizedBox(width: AppDimensions.paddingXS),
          Text(
            'Seats reserved for ${AppDateUtils.formatCountdown(remaining)}',
            style: AppTypography.bodySmall.copyWith(
              color: isLow ? AppColors.error : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
