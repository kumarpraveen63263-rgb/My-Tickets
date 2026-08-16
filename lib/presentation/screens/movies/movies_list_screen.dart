import '../../../core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../data/models/movie_model.dart';
import '../../../providers/movie_provider.dart';
import '../../widgets/common/app_chip.dart';
import '../../widgets/common/app_empty_state.dart';
import '../../widgets/common/app_error_widget.dart';
import '../../widgets/common/shimmer_loader.dart';
import '../../widgets/home/movie_card.dart';

final _movieFilterProvider = StateProvider.autoDispose<String>((ref) => 'All');

class MoviesListScreen extends ConsumerWidget {
  /// When rendered as a bottom-nav tab root there is nothing to pop, so the
  /// back button is hidden. When pushed from elsewhere it shows normally.
  final bool isTab;

  MoviesListScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(allMoviesProvider);
    final filter = ref.watch(_movieFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.tr('Movies')),
        automaticallyImplyLeading: false,
        leading: isTab
            ? null
            : IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back_rounded),
              ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium,
              ),
              children:
                  ['All', 'Now Showing', 'Upcoming', 'Tamil', 'Telugu', 'Hindi']
                      .map(
                        (f) => Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: AppChip(
                            label: f,
                            isSelected: filter == f,
                            onTap: () =>
                                ref.read(_movieFilterProvider.notifier).state =
                                    f,
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          Expanded(
            child: moviesAsync.when(
              loading: () => GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(AppDimensions.paddingMedium),
                childAspectRatio: 0.55,
                children: List.generate(6, (_) => ShimmerMovieCard()),
              ),
              error: (_, _) => AppErrorWidget(
                onRetry: () => ref.invalidate(allMoviesProvider),
              ),
              data: (movies) {
                final filtered = _applyFilter(movies, filter);
                if (filtered.isEmpty) {
                  return AppEmptyState(
                    icon: Icons.movie_filter_outlined,
                    title: context.tr('No movies found'),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.accentMovie,
                  onRefresh: () async {
                    ref.invalidate(allMoviesProvider);
                    await Future.delayed(Duration(milliseconds: 500));
                  },
                  child: GridView.builder(
                    padding: EdgeInsets.fromLTRB(
                      AppDimensions.paddingMedium,
                      0,
                      AppDimensions.paddingMedium,
                      AppDimensions.bottomPadding,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.52,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) =>
                        MovieCard(movie: filtered[i], width: double.infinity),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<MovieModel> _applyFilter(List<MovieModel> movies, String filter) {
    switch (filter) {
      case 'Now Showing':
        return movies.where((m) => m.isNowShowing).toList();
      case 'Upcoming':
        return movies.where((m) => m.isUpcoming).toList();
      case 'All':
        return movies;
      default:
        return movies.where((m) => m.language.contains(filter)).toList();
    }
  }
}
