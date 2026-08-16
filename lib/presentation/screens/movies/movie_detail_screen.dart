import '../../../core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/movie_model.dart';
import '../../../providers/movie_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_error_widget.dart';
import '../../widgets/common/app_loader.dart';
import '../../widgets/home/movie_card.dart';
import '../../widgets/home/section_header.dart';
import '../../widgets/movie/cast_crew_row.dart';
import '../../widgets/movie/movie_hero_banner.dart';
import '../../widgets/movie/price_comparison_card.dart';
import '../../widgets/movie/rating_bar.dart';
import '../../widgets/movie/review_card.dart';

class MovieDetailScreen extends ConsumerWidget {
  final String movieId;

  MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(movieDetailProvider(movieId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: movieAsync.when(
        loading: () => AppLoader(),
        error: (_, _) => AppErrorWidget(
          onRetry: () => ref.invalidate(movieDetailProvider(movieId)),
        ),
        data: (movie) => _content(context, ref, movie),
      ),
      bottomNavigationBar: movieAsync.maybeWhen(
        data: (movie) => movie.isNowShowing
            ? SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingMedium),
                  child: AppButton(
                    label: context.tr('Book Tickets'),
                    icon: Icons.confirmation_number_rounded,
                    size: AppButtonSize.large,
                    onPressed: () =>
                        context.push('/movies/${movie.id}/theatres'),
                  ),
                ),
              )
            : SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingMedium),
                  child: AppButton(
                    label:
                        'Coming ${AppDateUtils.formatDayMonth(movie.releaseDate)}',
                    variant: AppButtonVariant.secondary,
                    size: AppButtonSize.large,
                    onPressed: null,
                  ),
                ),
              ),
        orElse: () => SizedBox.shrink(),
      ),
    );
  }

  Widget _content(BuildContext context, WidgetRef ref, MovieModel movie) {
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.zero,
          children: [
            MovieHeroBanner(
              bannerUrl: movie.bannerUrl,
              posterUrl: movie.posterUrl,
            ),
            Padding(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: AppTypography.displaySmall),
                  SizedBox(height: 8),
                  RatingBar(rating: movie.rating, votes: movie.votes),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _infoChip(movie.language.join(', ')),
                      _infoChip(AppDateUtils.formatDuration(movie.duration)),
                      _infoChip(movie.certification),
                    ],
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: movie.genre.map((g) => _genreTag(g)).toList(),
                  ),
                ],
              ),
            ),
            _ExpandableSynopsis(synopsis: movie.synopsis),
            SizedBox(height: AppDimensions.paddingSmall),
            _trailerCard(context, movie),
            SizedBox(height: AppDimensions.paddingMedium),
            SectionHeader(title: context.tr('Cast')),
            CastCrewRow(cast: movie.cast),
            SizedBox(height: AppDimensions.paddingMedium),
            if (movie.isNowShowing)
              SectionHeader(
                title: context.tr('Available Theatres'),
                onSeeAll: () => context.push('/movies/${movie.id}/theatres'),
              ),
            if (movie.isNowShowing)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                ),
                child: AppButton(
                  label: 'View ${movie.theatres.length} Theatres',
                  variant: AppButtonVariant.outlined,
                  icon: Icons.location_on_outlined,
                  onPressed: () => context.push('/movies/${movie.id}/theatres'),
                ),
              ),
            SizedBox(height: AppDimensions.paddingLarge),
            PriceComparisonCard(comparison: movie.priceComparison),
            SizedBox(height: AppDimensions.paddingLarge),
            SectionHeader(title: context.tr('User Reviews')),
            ...movie.reviews.take(3).map((r) => ReviewCard(review: r)),
            SizedBox(height: AppDimensions.paddingMedium),
            _RelatedMovies(currentId: movie.id),
            SizedBox(height: AppDimensions.bottomPadding),
          ],
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 8,
          child: CircleAvatar(
            backgroundColor: Colors.black.withValues(alpha: 0.5),
            child: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _genreTag(String genre) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accentMovie.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Text(
        genre,
        style: AppTypography.caption.copyWith(color: AppColors.accentMovie),
      ),
    );
  }

  Widget _trailerCard(BuildContext context, MovieModel movie) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
      child: GestureDetector(
        onTap: () => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                context.tr('Trailer playback is not available in this demo'),
              ),
            ),
          ),
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMedium,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accentMovie,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.play_arrow_rounded, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text('Watch Trailer', style: AppTypography.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpandableSynopsis extends StatefulWidget {
  final String synopsis;

  _ExpandableSynopsis({required this.synopsis});

  @override
  State<_ExpandableSynopsis> createState() => _ExpandableSynopsisState();
}

class _ExpandableSynopsisState extends State<_ExpandableSynopsis> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr('Synopsis'), style: AppTypography.titleLarge),
          SizedBox(height: 6),
          Text(
            widget.synopsis,
            maxLines: _expanded ? null : 3,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: AppTypography.bodyMedium.copyWith(height: 1.5),
          ),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                _expanded ? context.tr('Read Less') : context.tr('Read More'),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.accentMovie,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RelatedMovies extends ConsumerWidget {
  final String currentId;

  _RelatedMovies({required this.currentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(nowShowingMoviesProvider);
    return moviesAsync.maybeWhen(
      data: (movies) {
        final related = movies.where((m) => m.id != currentId).take(6).toList();
        if (related.isEmpty) return SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: context.tr('You May Also Like')),
            SizedBox(
              height: MovieCard.totalHeight(140),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                ),
                itemCount: related.length,
                separatorBuilder: (_, _) => SizedBox(width: 12),
                itemBuilder: (_, i) => MovieCard(movie: related[i]),
              ),
            ),
          ],
        );
      },
      orElse: () => SizedBox.shrink(),
    );
  }
}
