import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/metro_provider.dart';

class MetroPassCard extends StatelessWidget {
  final PopularMetroRoute route;
  final double width;
  final VoidCallback onTap;
  final bool isFavourite;
  final VoidCallback onToggleFavourite;

  const MetroPassCard({
    super.key,
    required this.route,
    required this.onTap,
    required this.isFavourite,
    required this.onToggleFavourite,
    this.width = 260,
  });

  static double totalHeight() => 172;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: totalHeight(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0B2A44), Color(0xFF13131A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            border: Border.all(
              color: AppColors.accentMetro.withValues(alpha: 0.5),
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        context.tr('METRO'),
                        style: AppTypography.caption.copyWith(
                          color: AppColors.accentMetro,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.confirmation_number_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          route.from,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.titleMedium.copyWith(
                            height: 1.1,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: AppColors.accentMetro,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          route.to,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.titleMedium.copyWith(
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.accentMetro.withValues(alpha: 0.6),
                          thickness: 1.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${route.result.stations.length} ${context.tr('stops')}',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _badge(
                        Icons.currency_rupee_rounded,
                        '${route.result.fare}',
                      ),
                      const SizedBox(width: 8),
                      _badge(
                        Icons.schedule_rounded,
                        '${route.result.travelMinutes} min',
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: -10,
                right: -10,
                child: IconButton(
                  tooltip: isFavourite
                      ? context.tr('Remove from favourites')
                      : context.tr('Add to favourites'),
                  onPressed: onToggleFavourite,
                  icon: Icon(
                    isFavourite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFavourite
                        ? AppColors.error
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textPrimary),
          const SizedBox(width: 3),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
