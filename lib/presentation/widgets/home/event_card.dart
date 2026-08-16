import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/event_model.dart';
import '../common/shimmer_loader.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final double width;

  const EventCard({super.key, required this.event, this.width = 220});

  // ---- Layout constants (single source of truth for the card's geometry) ----
  static const double _imageHeight = 130;
  static const double _titleHeight = 20; // 1 line of titleMedium
  static const double _metaHeight = 18; // 1 line of bodySmall
  static const double _priceHeight = 18; // 1 line of bodySmall

  /// Exact height this card needs (banner + gaps + title + meta + price).
  static double totalHeight() =>
      _imageHeight + 8 + _titleHeight + 4 + _metaHeight + 2 + _priceHeight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      onTap: () => context.push('/events/${event.id}'),
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusMedium,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: event.bannerUrl,
                    width: width,
                    height: _imageHeight,
                    fit: BoxFit.cover,
                    placeholder: (_, _) =>
                        ShimmerBox(width: width, height: _imageHeight),
                    errorWidget: (_, _, _) => Container(
                      width: width,
                      height: _imageHeight,
                      color: AppColors.surfaceElevated,
                      child: const Icon(
                        Icons.event_outlined,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentEvent,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSmall,
                      ),
                    ),
                    child: Text(
                      event.category,
                      style: AppTypography.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: _titleHeight,
              child: Text(
                event.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleMedium.copyWith(height: 1.2),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: _metaHeight,
              child: Text(
                '${AppDateUtils.formatDayMonth(event.date)} · ${event.venue}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(height: 1.2),
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              height: _priceHeight,
              child: Text(
                event.priceRangeLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.accentEvent,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
