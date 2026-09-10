import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/theatre_model.dart';
import 'home_card_style.dart';

/// Poster-style card for a cinema.
class TheatreCard extends StatelessWidget {
  final TheatreModel theatre;
  final double width;
  final VoidCallback onTap;

  const TheatreCard({
    super.key,
    required this.theatre,
    required this.onTap,
    this.width = 240,
  });

  static const double _posterHeight = 120;
  static const double _titleHeight = 22;
  static const double _metaHeight = 18;

  static double totalHeight() =>
      _posterHeight +
      10 +
      _titleHeight +
      2 +
      _metaHeight +
      20;

  @override
  Widget build(BuildContext context) {
    final showCount = theatre.shows.length;
    return SizedBox(
      width: width,
      child: HomeCardStyle.tappable(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _poster(showCount),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: _titleHeight,
                    child: Text(
                      theatre.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleMedium.copyWith(height: 1.2),
                    ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    height: _metaHeight,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            theatre.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall.copyWith(
                              height: 1.1,
                            ),
                          ),
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
    );
  }

  Widget _poster(int showCount) {
    return SizedBox(
      height: _posterHeight,
      width: width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.accentMovie.withValues(alpha: 0.12),
                  AppColors.accentMovie.withValues(alpha: 0.04),
                ],
              ),
            ),
          ),
          Positioned(
            right: -8,
            bottom: -8,
            child: Icon(
              Icons.theaters_rounded,
              size: 96,
              color: AppColors.accentMovie.withValues(alpha: 0.08),
            ),
          ),
          const Center(
            child: Icon(
              Icons.local_movies_rounded,
              size: 36,
              color: AppColors.accentMovie,
            ),
          ),
          if (showCount > 0)
            Positioned(
              left: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentMovie,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$showCount shows today',
                  style: AppTypography.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
