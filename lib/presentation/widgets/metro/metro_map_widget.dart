import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/metro_model.dart';

/// Vertical timeline visualization of a metro route: source, intermediate,
/// interchange, and destination stations connected by a line.
class MetroMapWidget extends StatelessWidget {
  final List<MetroStationModel> stations;

  const MetroMapWidget({super.key, required this.stations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(stations.length, (index) {
        final station = stations[index];
        final isFirst = index == 0;
        final isLast = index == stations.length - 1;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 200 + index * 60),
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, (1 - value) * 8),
              child: child,
            ),
          ),
          child: _StationRow(
            station: station,
            isFirst: isFirst,
            isLast: isLast,
          ),
        );
      }),
    );
  }
}

class _StationRow extends StatelessWidget {
  final MetroStationModel station;
  final bool isFirst;
  final bool isLast;

  const _StationRow({
    required this.station,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isTerminal = isFirst || isLast;
    final dotSize = isTerminal ? 18.0 : (station.isInterchange ? 16.0 : 10.0);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isTerminal
                        ? AppColors.accentMetro
                        : AppColors.background,
                    border: Border.all(
                      color: AppColors.accentMetro,
                      width: station.isInterchange && !isTerminal ? 2.5 : 1.5,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: AppColors.accentMetro.withValues(alpha: 0.4),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimensions.paddingMedium,
              ),
              child: Row(
                children: [
                  Text(
                    station.name,
                    style: isTerminal
                        ? AppTypography.titleMedium
                        : AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                  ),
                  if (station.isInterchange) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Interchange',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
