import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/metro_model.dart';
import '../data/repositories/metro_repository.dart';

final metroRepositoryProvider = Provider<MetroRepository>(
  (ref) => MetroRepository(),
);

final metroStationsProvider = Provider<List<MetroStationModel>>((ref) {
  return ref.watch(metroRepositoryProvider).getAllStationsUnique();
});

final fromStationProvider = StateProvider<String?>((ref) => null);
final toStationProvider = StateProvider<String?>((ref) => null);
final metroPassengerCountProvider = StateProvider<int>((ref) => 1);

final metroRouteProvider = Provider<MetroRouteResult?>((ref) {
  final from = ref.watch(fromStationProvider);
  final to = ref.watch(toStationProvider);
  if (from == null || to == null) return null;
  return ref.watch(metroRepositoryProvider).findRoute(from, to);
});

class RecentRoute {
  final String from;
  final String to;
  const RecentRoute(this.from, this.to);
}

/// A precomputed popular route (from → to + fare/duration) for the Home
/// "Metro" poster section.
class PopularMetroRoute {
  final String from;
  final String to;
  final MetroRouteResult result;
  const PopularMetroRoute({
    required this.from,
    required this.to,
    required this.result,
  });
}

final popularMetroRoutesProvider = Provider<List<PopularMetroRoute>>((ref) {
  final repo = ref.watch(metroRepositoryProvider);
  const pairs = [
    ('Chennai Central', 'Guindy'),
    ('Koyambedu', 'Alandur'),
    ('Vadapalani', 'Chennai Airport'),
    ('Chennai Central', 'Chennai Airport'),
  ];
  final routes = <PopularMetroRoute>[];
  for (final (from, to) in pairs) {
    try {
      routes.add(
        PopularMetroRoute(from: from, to: to, result: repo.findRoute(from, to)),
      );
    } catch (_) {
      // Skip any pair whose stations aren't in the current network.
    }
  }
  return routes;
});

class RecentRoutesNotifier extends StateNotifier<List<RecentRoute>> {
  RecentRoutesNotifier()
    : super(const [
        RecentRoute('Chennai Central', 'Guindy'),
        RecentRoute('Koyambedu', 'Alandur'),
        RecentRoute('Vadapalani', 'Chennai Airport'),
      ]);

  void addRoute(String from, String to) {
    final route = RecentRoute(from, to);
    state = [
      route,
      ...state.where((r) => !(r.from == from && r.to == to)),
    ].take(5).toList();
  }
}

final recentRoutesProvider =
    StateNotifierProvider<RecentRoutesNotifier, List<RecentRoute>>((ref) {
      return RecentRoutesNotifier();
    });
