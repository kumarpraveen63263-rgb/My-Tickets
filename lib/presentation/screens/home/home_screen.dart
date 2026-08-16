import '../../../core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/event_provider.dart';
import '../../../providers/metro_provider.dart';
import '../../../providers/metro_favourites_provider.dart';
import '../../../providers/movie_provider.dart';
import '../../../providers/offer_provider.dart';
import '../../widgets/common/app_error_widget.dart';
import '../../widgets/common/shimmer_loader.dart';
import '../../widgets/home/event_card.dart';
import '../../widgets/home/featured_banner.dart';
import '../../widgets/home/home_header.dart';
import '../../widgets/home/metro_pass_card.dart';
import '../../widgets/home/movie_card.dart';
import '../../widgets/home/offer_card.dart';
import '../../widgets/home/section_header.dart';
import '../../widgets/home/theatre_card.dart';

/// Horizontal list padding shared by every poster section.
final _kListPadding = EdgeInsets.symmetric(
  horizontal: AppDimensions.paddingMedium,
);

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: AppColors.accentMovie,
        onRefresh: () async {
          ref.invalidate(nowShowingMoviesProvider);
          ref.invalidate(upcomingMoviesProvider);
          ref.invalidate(featuredTheatresProvider);
          ref.invalidate(trendingEventsProvider);
          ref.invalidate(featuredEventsProvider);
          ref.invalidate(offersProvider);
          await Future.delayed(Duration(milliseconds: 600));
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            HomeHeader(),
            _SearchBarButton(),
            SizedBox(height: AppDimensions.paddingMedium),
            _FeaturedSection(),
            SizedBox(height: AppDimensions.paddingLarge),
            _QuickActionsRow(),
            SizedBox(height: AppDimensions.paddingSmall),
            _NowShowingSection(),
            _TheatresSection(),
            _EventsSection(),
            _MetroSection(),
            _UpcomingSection(),
            _TrendingEventsSection(),
            _OffersSection(),
            SizedBox(height: AppDimensions.bottomPadding),
          ],
        ),
      ),
    );
  }
}

/// Wraps a horizontal poster list, applying a fast one-shot staggered
/// fade + slide entrance to the first few cards. Because Home lives inside the
/// bottom-nav IndexedStack it is not rebuilt on tab switches, so this plays
/// only once.
class _PosterRow extends StatelessWidget {
  final double height;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  _PosterRow({
    required this.height,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: _kListPadding,
        itemCount: itemCount,
        separatorBuilder: (_, _) => SizedBox(width: 12),
        itemBuilder: (context, i) {
          final card = itemBuilder(context, i);
          if (i >= 6) return card; // only stagger the initial viewport
          return card
              .animate()
              .fadeIn(duration: 260.ms, delay: (i * 45).ms)
              .slideX(
                begin: 0.12,
                end: 0,
                duration: 300.ms,
                delay: (i * 45).ms,
                curve: Curves.easeOut,
              );
        },
      ),
    );
  }
}

class _SearchBarButton extends StatelessWidget {
  _SearchBarButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
      child: GestureDetector(
        onTap: () => context.go('/home/search'),
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMedium,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: AppColors.textSecondary),
              SizedBox(width: 10),
              Text('Movies, Events, Metro...', style: AppTypography.bodyMedium),
              Spacer(),
              Icon(Icons.mic_none_rounded, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedSection extends ConsumerWidget {
  _FeaturedSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(nowShowingMoviesProvider);
    final events = ref.watch(featuredEventsProvider);

    return movies.when(
      loading: () => Padding(
        padding: _kListPadding,
        child: ShimmerBox(width: double.infinity, height: 200),
      ),
      error: (_, _) => SizedBox.shrink(),
      data: (movieList) {
        final items = <FeaturedBannerItem>[];
        for (final m in movieList.take(5)) {
          items.add(
            FeaturedBannerItem(
              imageUrl: m.bannerUrl,
              title: m.title,
              category: 'Now Showing',
              accentColor: AppColors.accentMovie,
              onTap: () => context.push('/movies/${m.id}'),
            ),
          );
        }
        events.whenData((eventList) {
          for (final e in eventList.take(3)) {
            items.add(
              FeaturedBannerItem(
                imageUrl: e.bannerUrl,
                title: e.title,
                category: e.category,
                accentColor: AppColors.accentEvent,
                onTap: () => context.push('/events/${e.id}'),
              ),
            );
          }
        });
        return FeaturedBanner(items: items);
      },
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    final actions = [
      (_QuickAction(
        Icons.movie_rounded,
        'Movies',
        AppColors.accentMovie,
        () => context.go('/movies'),
      )),
      (_QuickAction(
        Icons.celebration_rounded,
        'Events',
        AppColors.accentEvent,
        () => context.go('/events'),
      )),
      (_QuickAction(
        Icons.train_rounded,
        'Metro',
        AppColors.accentMetro,
        () => context.go('/metro'),
      )),
      (_QuickAction(
        Icons.local_offer_rounded,
        'Offers',
        AppColors.accentOffer,
        () => context.go('/home/search'),
      )),
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions,
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _QuickAction(this.icon, this.label, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NowShowingSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(nowShowingMoviesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.tr('Now Showing'),
          onSeeAll: () => context.go('/movies'),
        ),
        movies.when(
          loading: () => ShimmerList(
            height: MovieCard.totalHeight(140),
            itemBuilder: () => ShimmerMovieCard(),
          ),
          error: (_, _) => SizedBox(
            height: MovieCard.totalHeight(140),
            child: AppErrorWidget(
              onRetry: () => ref.invalidate(nowShowingMoviesProvider),
            ),
          ),
          data: (list) => _PosterRow(
            height: MovieCard.totalHeight(140),
            itemCount: list.length,
            itemBuilder: (_, i) => MovieCard(movie: list[i]),
          ),
        ),
      ],
    );
  }
}

class _TheatresSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theatres = ref.watch(featuredTheatresProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.tr('Popular Theatres'),
          onSeeAll: () => context.go('/movies'),
        ),
        theatres.when(
          loading: () => ShimmerList(
            height: TheatreCard.totalHeight(),
            itemBuilder: () => _ShimmerBoxCard(width: 240, height: 120),
          ),
          error: (_, _) => SizedBox.shrink(),
          data: (list) {
            if (list.isEmpty) return SizedBox.shrink();
            return _PosterRow(
              height: TheatreCard.totalHeight(),
              itemCount: list.length,
              itemBuilder: (_, i) => TheatreCard(
                theatre: list[i],
                onTap: () => context.go('/movies'),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _EventsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.tr('Events Near You'),
          accentColor: AppColors.accentEvent,
          onSeeAll: () => context.go('/events'),
        ),
        events.when(
          loading: () => ShimmerList(
            height: EventCard.totalHeight(),
            itemBuilder: () => ShimmerEventCard(),
          ),
          error: (_, _) => SizedBox.shrink(),
          data: (list) => _PosterRow(
            height: EventCard.totalHeight(),
            itemCount: list.length,
            itemBuilder: (_, i) => EventCard(event: list[i]),
          ),
        ),
      ],
    );
  }
}

class _MetroSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(popularMetroRoutesProvider);
    final favouriteKeys = ref.watch(metroFavouriteRoutesProvider);
    final favouriteRoutes = routes
        .where(
          (route) =>
              favouriteKeys.contains(metroRouteKey(route.from, route.to)),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (favouriteRoutes.isNotEmpty) ...[
          SectionHeader(
            title: context.tr('Favourite Metro Routes'),
            accentColor: AppColors.accentMetro,
            onSeeAll: () => context.go('/metro'),
          ),
          _routeRow(context, ref, favouriteRoutes, favouriteKeys),
          const SizedBox(height: AppDimensions.paddingLarge),
        ],
        SectionHeader(
          title: context.tr('Metro Routes'),
          accentColor: AppColors.accentMetro,
          onSeeAll: () => context.go('/metro'),
        ),
        if (routes.isEmpty)
          const SizedBox.shrink()
        else
          _routeRow(context, ref, routes, favouriteKeys),
      ],
    );
  }

  Widget _routeRow(
    BuildContext context,
    WidgetRef ref,
    List<PopularMetroRoute> routes,
    Set<String> favouriteKeys,
  ) {
    return _PosterRow(
      height: MetroPassCard.totalHeight(),
      itemCount: routes.length,
      itemBuilder: (_, i) {
        final route = routes[i];
        final key = metroRouteKey(route.from, route.to);
        return MetroPassCard(
          route: route,
          isFavourite: favouriteKeys.contains(key),
          onToggleFavourite: () =>
              ref.read(metroFavouriteRoutesProvider.notifier).toggle(key),
          onTap: () {
            ref.read(fromStationProvider.notifier).state = route.from;
            ref.read(toStationProvider.notifier).state = route.to;
            context.push('/metro/route');
          },
        );
      },
    );
  }
}

class _UpcomingSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(upcomingMoviesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.tr('Upcoming Movies'),
          onSeeAll: () => context.go('/movies'),
        ),
        movies.when(
          loading: () => ShimmerList(
            height: MovieCard.totalHeight(140),
            itemBuilder: () => ShimmerMovieCard(),
          ),
          error: (_, _) => SizedBox.shrink(),
          data: (list) => _PosterRow(
            height: MovieCard.totalHeight(140),
            itemCount: list.length,
            itemBuilder: (_, i) => MovieCard(movie: list[i]),
          ),
        ),
      ],
    );
  }
}

class _TrendingEventsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(trendingEventsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.tr('Trending Events'),
          accentColor: AppColors.accentEvent,
          onSeeAll: () => context.go('/events'),
        ),
        events.when(
          loading: () => ShimmerList(
            height: EventCard.totalHeight(),
            itemBuilder: () => ShimmerEventCard(),
          ),
          error: (_, _) => SizedBox.shrink(),
          data: (list) => _PosterRow(
            height: EventCard.totalHeight(),
            itemCount: list.length,
            itemBuilder: (_, i) => EventCard(event: list[i]),
          ),
        ),
      ],
    );
  }
}

class _OffersSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(offersProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.tr('Hot Offers'),
          accentColor: AppColors.accentOffer,
        ),
        offers.when(
          loading: () => ShimmerList(
            height: 150,
            itemBuilder: () => _ShimmerBoxCard(width: 260, height: 130),
          ),
          error: (_, _) => SizedBox.shrink(),
          data: (list) => _PosterRow(
            height: 150,
            itemCount: list.length,
            itemBuilder: (_, i) => OfferCard(offer: list[i]),
          ),
        ),
      ],
    );
  }
}

/// Generic shimmer placeholder matching an arbitrary card box size.
class _ShimmerBoxCard extends StatelessWidget {
  final double width;
  final double height;
  _ShimmerBoxCard({required this.width, required this.height});

  @override
  Widget build(BuildContext context) =>
      ShimmerBox(width: width, height: height);
}
