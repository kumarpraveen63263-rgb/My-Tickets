import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = AppDimensions.radiusMedium,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceElevated,
      highlightColor: AppColors.border,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Mirrors [MovieCard] geometry exactly (poster width*1.42 + 8 + 38 + 4 + 20)
/// so there is no layout shift when real data replaces the placeholder.
class ShimmerMovieCard extends StatelessWidget {
  final double width;
  const ShimmerMovieCard({super.key, this.width = 140});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: width, height: width * 1.42),
          const SizedBox(height: 8),
          ShimmerBox(width: width * 0.9, height: 14, radius: 4),
          const SizedBox(height: 6),
          ShimmerBox(width: width * 0.6, height: 14, radius: 4),
          const SizedBox(height: 4),
          const ShimmerBox(width: 44, height: 18, radius: 4),
        ],
      ),
    );
  }
}

/// Mirrors [EventCard] geometry exactly (130 + 8 + 20 + 4 + 18 + 2 + 18).
class ShimmerEventCard extends StatelessWidget {
  final double width;
  const ShimmerEventCard({super.key, this.width = 220});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: width, height: 130),
          const SizedBox(height: 8),
          ShimmerBox(width: width * 0.8, height: 16, radius: 4),
          const SizedBox(height: 4),
          ShimmerBox(width: width * 0.55, height: 14, radius: 4),
          const SizedBox(height: 2),
          const ShimmerBox(width: 70, height: 14, radius: 4),
        ],
      ),
    );
  }
}

/// Mirrors [EventHeroBanner]'s slide geometry (full-width, 220 tall,
/// radiusXL corners).
class ShimmerEventHero extends StatelessWidget {
  const ShimmerEventHero({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
      child: ShimmerBox(
        width: double.infinity,
        height: 220,
        radius: AppDimensions.radiusXL,
      ),
    );
  }
}

/// Mirrors [EventCardSmall]'s geometry exactly (imageHeight 110 + padded
/// title/category/venue/price rows) so the Upcoming Events row never shifts.
class ShimmerEventCardSmall extends StatelessWidget {
  final double width;
  const ShimmerEventCardSmall({super.key, this.width = 150});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: width, height: 110, radius: 0),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: width - 40, height: 13, radius: 4),
                const SizedBox(height: 6),
                ShimmerBox(width: width - 70, height: 11, radius: 4),
                const SizedBox(height: 6),
                ShimmerBox(width: width - 60, height: 11, radius: 4),
                const SizedBox(height: 10),
                ShimmerBox(width: width - 30, height: 14, radius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mirrors [EventCardGrid]'s geometry (image 140 + title/meta/price rows).
class ShimmerEventCardGrid extends StatelessWidget {
  const ShimmerEventCardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerBox(width: double.infinity, height: 140, radius: 0),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerBox(width: double.infinity, height: 13, radius: 4),
              const SizedBox(height: 6),
              ShimmerBox(width: 90, height: 11, radius: 4),
              const SizedBox(height: 8),
              ShimmerBox(width: 60, height: 16, radius: 4),
            ],
          ),
        ),
      ],
    );
  }
}

/// Mirrors [EventListRow]'s geometry exactly (56px thumbnail + 10px padding).
class ShimmerEventListRow extends StatelessWidget {
  const ShimmerEventListRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Row(
        children: [
          const ShimmerBox(width: 56, height: 56),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const ShimmerBox(width: double.infinity, height: 14, radius: 4),
                const SizedBox(height: 6),
                ShimmerBox(width: 90, height: 12, radius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerTicketCard extends StatelessWidget {
  const ShimmerTicketCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: 8,
      ),
      child: ShimmerBox(width: double.infinity, height: 100),
    );
  }
}

class ShimmerList extends StatelessWidget {
  final Axis scrollDirection;
  final int itemCount;
  final double height;
  final Widget Function() itemBuilder;

  const ShimmerList({
    super.key,
    this.scrollDirection = Axis.horizontal,
    this.itemCount = 4,
    this.height = 240,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (scrollDirection == Axis.horizontal) {
      return SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMedium,
          ),
          itemCount: itemCount,
          separatorBuilder: (_, _) => const SizedBox(width: 12),
          itemBuilder: (_, _) => itemBuilder(),
        ),
      );
    }
    return Column(children: List.generate(itemCount, (_) => itemBuilder()));
  }
}
