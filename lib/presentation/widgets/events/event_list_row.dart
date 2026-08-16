import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/event_model.dart';
import '../common/shimmer_loader.dart';

/// "Near You" row: square thumbnail, title + distance, trailing chevron.
/// Each row is its own white card with soft shadow, stacked with a small gap.
class EventListRow extends StatelessWidget {
  final EventModel event;
  final double distanceKm;
  final VoidCallback onTap;

  const EventListRow({
    super.key,
    required this.event,
    required this.distanceKm,
    required this.onTap,
  });

  static const double thumbSize = 56;
  static double totalHeight() =>
      thumbSize + 20; // 10px vertical padding each side

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                child: CachedNetworkImage(
                  imageUrl: event.bannerUrl,
                  width: thumbSize,
                  height: thumbSize,
                  fit: BoxFit.cover,
                  placeholder: (_, _) =>
                      const ShimmerBox(width: thumbSize, height: thumbSize),
                  errorWidget: (_, _, _) => Container(
                    width: thumbSize,
                    height: thumbSize,
                    color: AppColors.surfaceElevated,
                    child: const Icon(
                      Icons.event_outlined,
                      size: 20,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${distanceKm.toStringAsFixed(1)} km away',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
