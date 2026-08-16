import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/movie_model.dart';
import '../data/models/show_model.dart';
import '../data/models/theatre_model.dart';
import '../data/repositories/movie_repository.dart';

final movieRepositoryProvider = Provider<MovieRepository>(
  (ref) => MovieRepository(),
);

final nowShowingMoviesProvider = FutureProvider<List<MovieModel>>((ref) {
  return ref.watch(movieRepositoryProvider).getNowShowing();
});

final upcomingMoviesProvider = FutureProvider<List<MovieModel>>((ref) {
  return ref.watch(movieRepositoryProvider).getUpcoming();
});

final allMoviesProvider = FutureProvider<List<MovieModel>>((ref) {
  return ref.watch(movieRepositoryProvider).getAll();
});

/// Distinct theatres currently screening now-showing movies — used for the
/// "Theatres" poster section on Home. Derived from loaded movie data so no
/// extra data source is needed.
final featuredTheatresProvider = FutureProvider<List<TheatreModel>>((
  ref,
) async {
  final movies = await ref.watch(nowShowingMoviesProvider.future);
  final seen = <String>{};
  final theatres = <TheatreModel>[];
  for (final m in movies) {
    for (final t in m.theatres) {
      if (seen.add(t.id)) theatres.add(t);
    }
  }
  return theatres;
});

final movieDetailProvider = FutureProvider.family<MovieModel, String>((
  ref,
  id,
) {
  return ref.watch(movieRepositoryProvider).getById(id);
});

/// Selected date for the theatre-list / showtimes screen.
final selectedShowDateProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

/// Resolves a specific ShowModel by (movieId, showId) for the seat screen.
final showByIdProvider =
    FutureProvider.family<ShowModel?, ({String movieId, String showId})>((
      ref,
      args,
    ) async {
      final movie = await ref
          .watch(movieRepositoryProvider)
          .getById(args.movieId);
      for (final theatre in movie.theatres) {
        for (final show in theatre.shows) {
          if (show.id == args.showId) return show;
        }
      }
      return null;
    });
