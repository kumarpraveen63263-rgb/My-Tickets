import '../../../core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class SeatLegend extends StatelessWidget {
  SeatLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _LegendItem(
          color: AppColors.seatAvailable,
          label: context.tr('Available'),
        ),
        _LegendItem(
          color: AppColors.seatSelected,
          label: context.tr('Selected'),
        ),
        _LegendItem(color: AppColors.seatBooked, label: context.tr('Booked')),
        _LegendItem(
          color: AppColors.seatPremium,
          label: 'Premium',
          isBorder: true,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isBorder;

  _LegendItem({
    required this.color,
    required this.label,
    this.isBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isBorder ? AppColors.surfaceElevated : color,
            borderRadius: BorderRadius.circular(4),
            border: isBorder ? Border.all(color: color, width: 1.5) : null,
          ),
        ),
        SizedBox(width: 6),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}
