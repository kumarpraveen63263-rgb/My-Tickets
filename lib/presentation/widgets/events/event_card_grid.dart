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
import 'event_card_small.dart' show EventFavoriteButton;

/// "Recommended For You" 2-column grid card: image + favorite heart on top,
/// title / category•date / price below.
class EventCardGrid extends ConsumerWidget {
  final EventModel event;
  final VoidCallback onTap;

  const EventCardGrid({super.key, required this.event, required this.onTap});

  static const double imageHeight = 140;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoriteEventsProvider).contains(event.id);

    return Material(
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
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => const ShimmerBox(
                    width: double.infinity,
                    height: imageHeight,
                    radius: 0,
                  ),
                  errorWidget: (_, _, _) => Container(
                    height: imageHeight,
                    color: AppColors.surfaceElevated,
                    child: const Icon(
                      Icons.event_outlined,
                      color: AppColors.textMuted,
                    ),
                  ),
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
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleMedium.copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${event.category} • ${AppDateUtils.formatDayMonth(event.date)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    CurrencyUtils.format(event.priceMin),
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.accentEvent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
