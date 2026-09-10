import '../../../core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/event_model.dart';
import '../../../data/services/notification_service.dart' show AppNotification;
import '../../../providers/event_provider.dart';
import '../../widgets/common/app_badge.dart';
import '../../widgets/common/app_bottom_sheet.dart';
import '../../widgets/common/app_chip.dart';
import '../../widgets/common/app_empty_state.dart';
import '../../widgets/common/app_error_widget.dart';
import '../../widgets/common/shimmer_loader.dart';
import '../../widgets/events/category_chip_widget.dart';
import '../../widgets/events/event_card_grid.dart';
import '../../widgets/events/event_card_small.dart';
import '../../widgets/events/event_hero_banner.dart';
import '../../widgets/events/event_list_row.dart';
import '../../widgets/events/events_search_bar.dart';
import '../../widgets/home/home_header.dart' show notificationsProvider;

const _kSectionPadding = EdgeInsets.fromLTRB(
  AppDimensions.paddingMedium,
  AppDimensions.paddingLarge,
  AppDimensions.paddingMedium,
  AppDimensions.paddingSmall,
);

final _kCategories = [
  (
    slug: EventCategorySlugs.music,
    label: AppLocale.tr('Music'),
    icon: Icons.music_note_rounded,
  ),
  (
    slug: EventCategorySlugs.comedy,
    label: AppLocale.tr('Comedy'),
    icon: Icons.emoji_emotions_rounded,
  ),
  (
    slug: EventCategorySlugs.sports,
    label: AppLocale.tr('Sports'),
    icon: Icons.sports_soccer_rounded,
  ),
  (
    slug: EventCategorySlugs.workshops,
    label: AppLocale.tr('Workshops'),
    icon: Icons.work_outline_rounded,
  ),
  (
    slug: EventCategorySlugs.artCulture,
    label: AppLocale.tr('Art & Culture'),
    icon: Icons.palette_rounded,
  ),
];

List<EventModel> _filterByCategory(List<EventModel> events, String? slug) {
  if (slug == null) return events;
  return events.where((e) => e.categorySlug == slug).toList();
}

class EventsHomeScreen extends ConsumerWidget {
  const EventsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.accentEvent,
          onRefresh: () async {
            ref.invalidate(eventsProvider);
            ref.invalidate(featuredEventsProvider);
            ref.invalidate(upcomingEventsProvider);
            ref.invalidate(recommendedEventsProvider);
            ref.invalidate(nearbyEventsProvider);
            await Future.delayed(const Duration(milliseconds: 600));
          },
          child: ListView(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: const [
              _EventsHeader(),
              SizedBox(height: AppDimensions.paddingSmall),
              _SearchBarSection(),
              SizedBox(height: AppDimensions.paddingLarge),
              _CategoryChipRow(),
              SizedBox(height: AppDimensions.paddingSmall),
              _HeroSection(),
              _UpcomingSection(),
              _NearYouSection(),
              _RecommendedSection(),
              SizedBox(height: AppDimensions.bottomPadding),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventsHeader extends ConsumerWidget {
  const _EventsHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final unreadCount = notifications.maybeWhen(
      data: (list) => list.where((n) => !n.isRead).length,
      orElse: () => 0,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingMedium,
        AppDimensions.paddingSmall,
        AppDimensions.paddingMedium,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.accentEvent,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppConstants.defaultCity.split(',').first,
                      style: AppTypography.titleMedium,
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showNotifications(context, notifications),
                child: DotBadge(
                  count: unreadCount,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceElevated,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          RichText(
            text: TextSpan(
              style: AppTypography.displayMedium.copyWith(height: 1.15),
              children: const [
                TextSpan(text: 'Discover '),
                TextSpan(
                  text: 'experiences',
                  style: TextStyle(
                    color: AppColors.accentEvent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(text: '\nthat stay with you'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNotifications(
    BuildContext context,
    AsyncValue<List<AppNotification>> notifications,
  ) {
    AppBottomSheet.show(
      context,
      title: AppLocale.tr('Notifications'),
      child: notifications.when(
        loading: () => const SizedBox(
          height: 120,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => SizedBox(
          height: 120,
          child: Center(
            child: Text(AppLocale.tr('Failed to load notifications')),
          ),
        ),
        data: (list) {
          if (list.isEmpty) {
            return SizedBox(
              height: 160,
              child: AppEmptyState(
                icon: Icons.notifications_off_outlined,
                title: AppLocale.tr('No notifications yet'),
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            itemCount: list.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final n = list[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: n.isRead
                      ? AppColors.surfaceElevated
                      : AppColors.accentEvent.withValues(alpha: 0.16),
                  child: Icon(
                    Icons.notifications_rounded,
                    size: 18,
                    color: n.isRead
                        ? AppColors.textSecondary
                        : AppColors.accentEvent,
                  ),
                ),
                title: Text(n.title, style: AppTypography.titleMedium),
                subtitle: Text(n.body, style: AppTypography.bodySmall),
              );
            },
          );
        },
      ),
    );
  }
}

class _SearchBarSection extends StatelessWidget {
  const _SearchBarSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
      child: EventsSearchBar(
        onTap: () => context.push('/events/search'),
        onFilterTap: () => _showFilterSheet(context),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    AppBottomSheet.show(
      context,
      title: 'Filter by Category',
      child: Consumer(
        builder: (context, ref, _) {
          final selected = ref.watch(selectedEventCategoryProvider);
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _kCategories
                .map(
                  (c) => AppChip(
                    label: c.label,
                    icon: c.icon,
                    accentColor: AppColors.accentEvent,
                    isSelected: selected == c.slug,
                    onTap: () {
                      ref.read(selectedEventCategoryProvider.notifier).state =
                          selected == c.slug ? null : c.slug;
                      Navigator.of(context).pop();
                    },
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

class _CategoryChipRow extends ConsumerWidget {
  const _CategoryChipRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedEventCategoryProvider);

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
        itemCount: _kCategories.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          if (i == _kCategories.length) {
            return CategoryChipWidget(
              icon: Icons.more_horiz_rounded,
              label: 'More',
              isSelected: false,
              onTap: () => context.push('/events/list'),
            );
          }
          final c = _kCategories[i];
          return CategoryChipWidget(
            icon: c.icon,
            label: c.label,
            isSelected: selected == c.slug,
            onTap: () =>
                ref.read(selectedEventCategoryProvider.notifier).state =
                    selected == c.slug ? null : c.slug,
          );
        },
      ),
    );
  }
}

class _HeroSection extends ConsumerWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = ref.watch(featuredEventsProvider);
    return featured.when(
      loading: () => const ShimmerEventHero(),
      error: (_, _) => const SizedBox.shrink(),
      data: (events) {
        if (events.isEmpty) return const SizedBox.shrink();
        return EventHeroBanner(
          events: events,
          onTap: (e) => context.push('/events/${e.id}'),
        );
      },
    );
  }
}

class _UpcomingSection extends ConsumerWidget {
  const _UpcomingSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(upcomingEventsProvider);
    final selected = ref.watch(selectedEventCategoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: AppLocale.tr('Upcoming Events'),
          onViewAll: () => context.push('/events/list'),
        ),
        events.when(
          loading: () => ShimmerList(
            height: EventCardSmall.totalHeight(),
            itemBuilder: () => const ShimmerEventCardSmall(),
          ),
          error: (_, _) => SizedBox(
            height: EventCardSmall.totalHeight(),
            child: AppErrorWidget(
              onRetry: () => ref.invalidate(upcomingEventsProvider),
            ),
          ),
          data: (list) {
            final filtered = _filterByCategory(list, selected);
            if (filtered.isEmpty) {
              return SizedBox(
                height: EventCardSmall.totalHeight(),
                child: AppEmptyState(
                  icon: Icons.event_busy_rounded,
                  title: AppLocale.tr('No events in this category yet'),
                ),
              );
            }
            return SizedBox(
              height: EventCardSmall.totalHeight(),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                ),
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, i) => EventCardSmall(
                  event: filtered[i],
                  onTap: () => context.push('/events/${filtered[i].id}'),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _NearYouSection extends ConsumerWidget {
  const _NearYouSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearby = ref.watch(nearbyEventsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Near You',
          onViewAll: () => context.push('/events/list'),
        ),
        nearby.when(
          loading: () => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
            ),
            child: Column(
              children: List.generate(
                3,
                (i) => const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: ShimmerEventListRow(),
                ),
              ),
            ),
          ),
          error: (_, _) => AppErrorWidget(
            onRetry: () => ref.invalidate(nearbyEventsProvider),
          ),
          data: (list) {
            final top = list.take(4).toList();
            if (top.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                ),
                child: AppEmptyState(
                  icon: Icons.location_off_outlined,
                  title: AppLocale.tr('No events near you yet'),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium,
              ),
              child: Column(
                children: [
                  for (final item in top)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: EventListRow(
                        event: item.event,
                        distanceKm: item.distanceKm,
                        onTap: () => context.push('/events/${item.event.id}'),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _RecommendedSection extends ConsumerWidget {
  const _RecommendedSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(recommendedEventsProvider);
    final selected = ref.watch(selectedEventCategoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: AppLocale.tr('Recommended For You'),
          onViewAll: () => context.push('/events/list'),
        ),
        events.when(
          loading: () => _grid(6, (_) => const ShimmerEventCardGrid()),
          error: (_, _) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
            ),
            child: AppErrorWidget(
              onRetry: () => ref.invalidate(recommendedEventsProvider),
            ),
          ),
          data: (list) {
            final filtered = _filterByCategory(list, selected);
            if (filtered.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                ),
                child: AppEmptyState(
                  icon: Icons.event_busy_rounded,
                  title: AppLocale.tr('No events in this category yet'),
                ),
              );
            }
            return _grid(
              filtered.length,
              (i) => EventCardGrid(
                event: filtered[i],
                onTap: () => context.push('/events/${filtered[i].id}'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _grid(int count, Widget Function(int) builder) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.58,
        ),
        itemBuilder: (context, i) => builder(i),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;
  const _SectionHeader({required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _kSectionPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.headline),
          GestureDetector(
            onTap: onViewAll,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocale.tr('View All'),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.accentEvent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: AppColors.accentEvent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
