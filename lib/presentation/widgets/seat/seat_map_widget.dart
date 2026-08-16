import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../data/models/seat_model.dart';

class SeatMapWidget extends StatelessWidget {
  final List<SeatModel> seats;
  final ValueChanged<String> onSeatTap;

  const SeatMapWidget({
    super.key,
    required this.seats,
    required this.onSeatTap,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <String, List<SeatModel>>{};
    for (final seat in seats) {
      rows.putIfAbsent(seat.row, () => []).add(seat);
    }
    final rowKeys = rows.keys.toList()..sort();

    final sections = <SeatCategory, List<String>>{};
    for (final row in rowKeys) {
      final category = rows[row]!.first.category;
      sections.putIfAbsent(category, () => []).add(row);
    }

    return InteractiveViewer(
      minScale: 0.6,
      maxScale: 1.6,
      constrained: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingSmall,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final category in [
              SeatCategory.recliner,
              SeatCategory.premium,
              SeatCategory.executive,
              SeatCategory.normal,
            ])
              if (sections.containsKey(category))
                _buildSection(category, sections[category]!, rows),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    SeatCategory category,
    List<String> rowKeys,
    Map<String, List<SeatModel>> rows,
  ) {
    final price = rows[rowKeys.first]!.first.price;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 24),
            child: Text(
              '${category.label} · ${CurrencyUtils.format(price)}',
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          for (final row in rowKeys) _buildRow(row, rows[row]!),
        ],
      ),
    );
  }

  Widget _buildRow(String row, List<SeatModel> rowSeats) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              row,
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ...rowSeats.map(
            (seat) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: _SeatBox(seat: seat, onTap: () => onSeatTap(seat.id)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeatBox extends StatelessWidget {
  final SeatModel seat;
  final VoidCallback onTap;

  const _SeatBox({required this.seat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Border? border;
    Widget? child;

    if (seat.isBooked) {
      bg = AppColors.seatBooked;
      child = const Icon(
        Icons.close_rounded,
        size: 14,
        color: AppColors.textMuted,
      );
    } else if (seat.isSelected) {
      bg = AppColors.seatSelected;
    } else if (seat.category == SeatCategory.premium ||
        seat.category == SeatCategory.recliner) {
      bg = AppColors.surfaceElevated;
      border = Border.all(color: AppColors.seatPremium, width: 1.5);
    } else {
      bg = AppColors.seatAvailable;
    }

    return GestureDetector(
      onTap: seat.isBooked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
          border: border,
        ),
        transform: seat.isSelected
            ? (Matrix4.identity()..scaleByDouble(1.08, 1.08, 1.08, 1))
            : Matrix4.identity(),
        transformAlignment: Alignment.center,
        child:
            child ??
            Text(
              '${seat.number}',
              style: TextStyle(
                fontSize: 9,
                color: seat.isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
      ),
    );
  }
}
