import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../common/shimmer_loader.dart';

class MovieHeroBanner extends StatelessWidget {
  final String bannerUrl;
  final String posterUrl;

  const MovieHeroBanner({
    super.key,
    required this.bannerUrl,
    required this.posterUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 290,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: 240,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: bannerUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => const ShimmerBox(
                    width: double.infinity,
                    height: 240,
                    radius: 0,
                  ),
                  errorWidget: (_, _, _) => Container(
                    color: AppColors.surfaceElevated,
                    child: const Icon(
                      Icons.movie_outlined,
                      color: AppColors.textMuted,
                      size: 48,
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                        AppColors.background.withValues(alpha: 0.8),
                        AppColors.background,
                      ],
                      stops: const [0.0, 0.3, 0.8, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: AppDimensions.paddingMedium,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium - 2),
                child: CachedNetworkImage(
                  imageUrl: posterUrl,
                  width: 105,
                  height: 150,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => const ShimmerBox(width: 105, height: 150),
                  errorWidget: (_, _, _) => Container(
                    width: 105,
                    height: 150,
                    color: AppColors.surfaceElevated,
                    child: const Icon(Icons.movie_outlined, color: AppColors.textMuted),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
