import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/event_model.dart';
import '../data/models/metro_model.dart';
import '../data/models/movie_model.dart';
import 'auth_provider.dart';
import 'event_provider.dart';
import 'metro_provider.dart';
import 'movie_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchTabIndexProvider = StateProvider<int>((ref) => 0);

const List<String> trendingSearches = [
  'Kalki 2898 AD',
  'Pushpa 2',
  'Anirudh Concert',
  'Chennai Central',
  'Leo',
  'TechSpark Summit',
];

class SearchResults {
  final List<MovieModel> movies;
  final List<EventModel> events;
  final List<MetroStationModel> stations;

  const SearchResults({
    this.movies = const [],
    this.events = const [],
    this.stations = const [],
  });

  bool get isEmpty => movies.isEmpty && events.isEmpty && stations.isEmpty;
}

final searchResultsProvider = Provider<SearchResults>((ref) {
  final query = ref.watch(searchQueryProvider).trim();
  if (query.isEmpty) return const SearchResults();

  final movies = ref.watch(movieRepositoryProvider).searchSync(query);
  final events = ref.watch(eventRepositoryProvider).searchSync(query);
  final stations = ref.watch(metroRepositoryProvider).searchSync(query);

  return SearchResults(movies: movies, events: events, stations: stations);
});

class RecentSearchesNotifier extends StateNotifier<List<String>> {
  final Ref ref;
  RecentSearchesNotifier(this.ref)
    : super(ref.read(localStorageServiceProvider).recentSearches);

  void add(String query) {
    if (query.trim().isEmpty) return;
    ref.read(localStorageServiceProvider).addRecentSearch(query.trim());
    state = ref.read(localStorageServiceProvider).recentSearches;
  }

  void clear() {
    ref.read(localStorageServiceProvider).clearRecentSearches();
    state = [];
  }
}

final recentSearchesProvider =
    StateNotifierProvider<RecentSearchesNotifier, List<String>>((ref) {
      return RecentSearchesNotifier(ref);
    });
