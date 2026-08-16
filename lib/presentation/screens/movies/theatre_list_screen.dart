import '../../../core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/movie_model.dart';
import '../../../data/models/show_model.dart';
import '../../../data/models/theatre_model.dart';
import '../../../providers/movie_provider.dart';
import '../../widgets/common/app_empty_state.dart';
import '../../widgets/common/app_error_widget.dart';
import '../../widgets/common/app_loader.dart';

class TheatreListScreen extends ConsumerWidget {
  final String movieId;

  TheatreListScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(movieDetailProvider(movieId));
    final selectedDate = ref.watch(selectedShowDateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_rounded),
        ),
        title: movieAsync.maybeWhen(
          data: (m) => Text(m.title),
          orElse: () => Text(context.tr('Select Show')),
        ),
      ),
      body: movieAsync.when(
        loading: () => AppLoader(),
        error: (_, _) => AppErrorWidget(
          onRetry: () => ref.invalidate(movieDetailProvider(movieId)),
        ),
        data: (movie) => Column(
          children: [
            _dateSelector(ref, selectedDate),
            Divider(height: 1),
            Expanded(child: _theatreList(context, movie, selectedDate)),
          ],
        ),
      ),
    );
  }

  Widget _dateSelector(WidgetRef ref, DateTime selectedDate) {
    final dates = AppDateUtils.nextNDays(7);
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        itemCount: dates.length,
        separatorBuilder: (_, _) => SizedBox(width: 10),
        itemBuilder: (context, i) {
          final date = dates[i];
          final isSelected =
              date.day == selectedDate.day && date.month == selectedDate.month;
          return GestureDetector(
            onTap: () =>
                ref.read(selectedShowDateProvider.notifier).state = date,
            child: Container(
              width: 56,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accentMovie
                    : AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(
                  color: isSelected ? AppColors.accentMovie : AppColors.border,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppDateUtils.formatDayLabel(date),
                    style: AppTypography.caption.copyWith(
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    AppDateUtils.formatDayNumber(date),
                    style: AppTypography.titleLarge.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _theatreList(
    BuildContext context,
    MovieModel movie,
    DateTime selectedDate,
  ) {
    final theatresWithShows = movie.theatres
        .map((t) => (theatre: t, shows: t.showsOnDate(selectedDate)))
        .where((e) => e.shows.isNotEmpty)
        .toList();

    if (theatresWithShows.isEmpty) {
      return AppEmptyState(
        icon: Icons.theaters_outlined,
        title: context.tr('No shows on this date'),
        subtitle: context.tr('Try selecting another date'),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingMedium,
        AppDimensions.paddingSmall,
        AppDimensions.paddingMedium,
        AppDimensions.bottomPadding,
      ),
      itemCount: theatresWithShows.length,
      itemBuilder: (context, i) {
        final entry = theatresWithShows[i];
        return _TheatreCard(
          movie: movie,
          theatre: entry.theatre,
          shows: entry.shows,
        );
      },
    );
  }
}

class _TheatreCard extends StatelessWidget {
  final MovieModel movie;
  final TheatreModel theatre;
  final List<ShowModel> shows;

  _TheatreCard({
    required this.movie,
    required this.theatre,
    required this.shows,
  });

  Color _availabilityColor(ShowAvailability a) {
    switch (a) {
      case ShowAvailability.available:
        return AppColors.success;
      case ShowAvailability.fastFilling:
        return AppColors.warning;
      case ShowAvailability.almostFull:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(theatre.name, style: AppTypography.titleLarge),
          SizedBox(height: 2),
          Text(theatre.location, style: AppTypography.caption),
          SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: theatre.amenities
                .take(3)
                .map(
                  (a) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(a, style: AppTypography.caption),
                    ],
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: shows.map((show) {
              final color = _availabilityColor(show.availability);
              return GestureDetector(
                onTap: () => context.push(
                  '/movies/${movie.id}/seats',
                  extra: {'showId': show.id, 'theatreName': theatre.name},
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                    border: Border.all(color: color),
                  ),
                  child: Text(
                    show.time,
                    style: AppTypography.bodySmall.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
