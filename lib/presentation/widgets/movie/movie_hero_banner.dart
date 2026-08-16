import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
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
      height: 300,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: 260,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: bannerUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => const ShimmerBox(
                    width: double.infinity,
                    height: 260,
                    radius: 0,
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, AppColors.background],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: posterUrl,
                width: 110,
                height: 160,
                fit: BoxFit.cover,
                placeholder: (_, _) =>
                    const ShimmerBox(width: 110, height: 160),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
