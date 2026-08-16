import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/event_model.dart';
import '../../../providers/event_provider.dart';
import '../common/shimmer_loader.dart';

/// "Upcoming Events" horizontal card: image with an overlaid date badge and
/// favorite heart, then title / category / venue / price+attendees below.
class EventCardSmall extends ConsumerWidget {
  final EventModel event;
  final VoidCallback onTap;
  final double width;

  const EventCardSmall({
    super.key,
    required this.event,
    required this.onTap,
    this.width = 150,
  });

  static const double imageHeight = 110;
  static const double _titleHeight = 18;
  static const double _categoryHeight = 16;
  static const double _venueHeight = 16;
  static const double _priceRowHeight = 20;

  static double totalHeight() =>
      imageHeight +
      10 +
      _titleHeight +
      4 +
      _categoryHeight +
      4 +
      _venueHeight +
      8 +
      _priceRowHeight +
      10;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoriteEventsProvider).contains(event.id);

    return SizedBox(
      width: width,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: event.bannerUrl,
                    width: width,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => ShimmerBox(
                      width: width,
                      height: imageHeight,
                      radius: 0,
                    ),
                    errorWidget: (_, _, _) => Container(
                      width: width,
                      height: imageHeight,
                      color: AppColors.surfaceElevated,
                      child: const Icon(
                        Icons.event_outlined,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: _DateBadge(date: event.date),
                  ),
                  Positioned(
                    right: 6,
                    top: 6,
                    child: EventFavoriteButton(
                      isFavorite: isFavorite,
                      onTap: () => ref
                          .read(favoriteEventsProvider.notifier)
                          .toggle(event.id),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: _titleHeight,
                      child: Text(
                        event.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleMedium.copyWith(
                          fontSize: 13,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: _categoryHeight,
                      child: Text(
                        event.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: _venueHeight,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 11,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              event.venue,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: _priceRowHeight,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'From ${CurrencyUtils.format(event.priceMin)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.accentEvent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.people_alt_rounded,
                            size: 12,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            _attendeeLabel(event.id),
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _attendeeLabel(String eventId) {
    final tenths = 4 + (eventId.hashCode.abs() % 40);
    return '${(tenths / 10).toStringAsFixed(1)}K';
  }
}

class _DateBadge extends StatelessWidget {
  final DateTime date;
  const _DateBadge({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppDateUtils.formatDayNumber(date),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.accentEvent,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          Text(
            AppDateUtils.formatMonthAbbrev(date).toUpperCase(),
            style: AppTypography.caption.copyWith(
              color: const Color(0xFF1A1A2E),
              fontSize: 9,
              height: 1.1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// The visible badge stays a small 30px circle (matching the reference), but
/// the tappable region is enlarged to 44px — as close to the 48px minimum as
/// fits without the hit area spilling past the card's own rounded corner
/// clip (radiusLarge=16) at this inset.
class EventFavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  const EventFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: 16,
                color: isFavorite
                    ? const Color(0xFFE0245E)
                    : const Color(0xFF1A1A2E),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
