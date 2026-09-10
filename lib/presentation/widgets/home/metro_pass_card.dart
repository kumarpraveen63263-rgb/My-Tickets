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
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            border: Border.all(
              color: AppColors.accentMetro.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentMetro.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentMetro.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          context.tr('METRO'),
                          style: AppTypography.caption.copyWith(
                            color: AppColors.accentMetro,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.train_rounded,
                        size: 18,
                        color: AppColors.accentMetro,
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
                            fontWeight: FontWeight.w700,
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
                            fontWeight: FontWeight.w700,
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
                          color: AppColors.accentMetro.withValues(alpha: 0.4),
                          thickness: 1.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${route.result.stations.length} ${context.tr('stops')}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
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
                top: -8,
                right: -8,
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
                    size: 20,
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
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.accentMetro),
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
