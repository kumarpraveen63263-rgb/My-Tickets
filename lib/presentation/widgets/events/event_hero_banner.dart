import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/event_model.dart';
import '../common/shimmer_loader.dart';

/// Featured/Trending hero carousel — full-width, rounded, auto-advancing
/// every 4s with a manual-swipe pause/resume, looping infinitely in both
/// directions. Each slide shows the event image with a gradient overlay,
/// a "Trending" badge, title/subtitle, date/venue, a "Book Now" pill and an
/// "interested" count pill.
class EventHeroBanner extends StatefulWidget {
  final List<EventModel> events;
  final void Function(EventModel event) onTap;

  const EventHeroBanner({super.key, required this.events, required this.onTap});

  @override
  State<EventHeroBanner> createState() => _EventHeroBannerState();
}

class _EventHeroBannerState extends State<EventHeroBanner> {
  static const int _virtualCount = 10000;

  late final PageController _controller;
  Timer? _autoTimer;
  Timer? _resumeTimer;
  int _realIndex = 0;

  int get _count => widget.events.length;

  @override
  void initState() {
    super.initState();
    final initialPage = _count > 0
        ? (_virtualCount ~/ 2) - ((_virtualCount ~/ 2) % _count)
        : 0;
    _controller = PageController(initialPage: initialPage, viewportFraction: 1);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoTimer?.cancel();
    if (_count <= 1) return;
    _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_controller.hasClients) return;
      _controller.nextPage(
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOut,
      );
    });
  }

  void _pauseThenResume() {
    _autoTimer?.cancel();
    _resumeTimer?.cancel();
    _resumeTimer = Timer(const Duration(seconds: 3), _startAutoPlay);
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _resumeTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.events.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification &&
                  notification.dragDetails != null) {
                _autoTimer?.cancel();
              } else if (notification is ScrollEndNotification) {
                _pauseThenResume();
              }
              return false;
            },
            child: PageView.builder(
              controller: _controller,
              itemCount: _count == 1 ? 1 : _virtualCount,
              onPageChanged: (page) =>
                  setState(() => _realIndex = page % _count),
              itemBuilder: (context, page) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                ),
                child: _HeroSlide(
                  event: widget.events[page % _count],
                  onTap: () => widget.onTap(widget.events[page % _count]),
                ),
              ),
            ),
          ),
        ),
        if (_count > 1) ...[
          const SizedBox(height: 10),
          AnimatedSmoothIndicator(
            activeIndex: _realIndex,
            count: _count,
            effect: const ExpandingDotsEffect(
              dotHeight: 6,
              dotWidth: 6,
              expansionFactor: 3,
              spacing: 6,
              activeDotColor: AppColors.accentEvent,
              dotColor: AppColors.border,
            ),
          ),
        ],
      ],
    );
  }
}

class _HeroSlide extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;
  const _HeroSlide({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: event.bannerUrl,
              fit: BoxFit.cover,
              placeholder: (_, _) => const ShimmerBox(
                width: double.infinity,
                height: 220,
                radius: 0,
              ),
              errorWidget: (_, _, _) => const ColoredBox(
                color: AppColors.surfaceElevated,
                child: Center(
                  child: Icon(Icons.image_outlined, color: AppColors.textMuted),
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                  stops: [0.35, 1],
                ),
              ),
            ),
            Positioned(
              left: 14,
              top: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentEvent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'Trending',
                      style: AppTypography.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.displaySmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 12,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${AppDateUtils.formatDayMonthYear(event.date)} • ${event.time}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 12,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          event.venue,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentEvent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Book Now',
                              style: AppTypography.button.copyWith(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 15,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.groups_rounded,
                              size: 13,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _interestedLabel(event.id),
                              style: AppTypography.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Deterministic mock "interested" count — there's no real social/RSVP
  /// data source for events yet, so this derives a stable-looking figure
  /// from the event id rather than a random one that would jump on rebuild.
  String _interestedLabel(String eventId) {
    final thousands = 2 + (eventId.hashCode.abs() % 12);
    return '+${thousands}K Interested';
  }
}
