import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/event_model.dart';
import '../data/repositories/event_repository.dart';
import 'auth_provider.dart' show localStorageServiceProvider;

final eventRepositoryProvider = Provider<EventRepository>(
  (ref) => EventRepository(),
);

final eventsProvider = FutureProvider<List<EventModel>>((ref) {
  return ref.watch(eventRepositoryProvider).getAll();
});

final featuredEventsProvider = FutureProvider<List<EventModel>>((ref) {
  return ref.watch(eventRepositoryProvider).getFeatured();
});

final trendingEventsProvider = FutureProvider<List<EventModel>>((ref) {
  return ref.watch(eventRepositoryProvider).getTrending();
});

final eventDetailProvider = FutureProvider.family<EventModel, String>((
  ref,
  id,
) {
  return ref.watch(eventRepositoryProvider).getById(id);
});

final selectedTicketCategoryProvider = StateProvider<String?>((ref) => null);

// ---- Events Discover screen ----

/// Selected category-chip slug on the Discover screen. `null` means no
/// filter is applied (all events shown); tapping an already-selected chip
/// clears it back to `null`.
final selectedEventCategoryProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);

/// Upcoming Events section — soonest first.
final upcomingEventsProvider = FutureProvider<List<EventModel>>((ref) async {
  final events = await ref.watch(eventsProvider.future);
  final sorted = [...events]..sort((a, b) => a.date.compareTo(b.date));
  return sorted;
});

/// Recommended For You section — a distinct ordering from Upcoming
/// (featured first) so the two sections don't just mirror each other.
final recommendedEventsProvider = FutureProvider<List<EventModel>>((ref) async {
  final events = await ref.watch(eventsProvider.future);
  final sorted = [...events]
    ..sort((a, b) {
      if (a.isFeatured != b.isFeatured) return a.isFeatured ? -1 : 1;
      return a.title.compareTo(b.title);
    });
  return sorted;
});

/// Near You section. There's no real geolocation for events in this mock
/// dataset, so distance is a small stable pseudo-value derived from the
/// event id — deterministic across rebuilds, not meant to be real.
final nearbyEventsProvider =
    FutureProvider<List<({EventModel event, double distanceKm})>>((ref) async {
      final events = await ref.watch(eventsProvider.future);
      final withDistance =
          events
              .map((e) => (event: e, distanceKm: _mockDistanceKm(e.id)))
              .toList()
            ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      return withDistance;
    });

double _mockDistanceKm(String eventId) {
  final seed = eventId.hashCode.abs() % 400;
  return 0.8 + seed / 40; // spreads roughly between 0.8km and 10.8km
}

class FavoriteEventsNotifier extends StateNotifier<Set<String>> {
  final Ref ref;
  FavoriteEventsNotifier(this.ref)
    : super(ref.read(localStorageServiceProvider).favouriteEvents.toSet());

  void toggle(String eventId) {
    ref.read(localStorageServiceProvider).toggleFavouriteEvent(eventId);
    state = ref.read(localStorageServiceProvider).favouriteEvents.toSet();
  }

  bool isFavorite(String eventId) => state.contains(eventId);
}

/// Persisted (Hive-backed) set of favourited event IDs — survives navigating
/// away and back, and app restarts.
final favoriteEventsProvider =
    StateNotifierProvider<FavoriteEventsNotifier, Set<String>>((ref) {
      return FavoriteEventsNotifier(ref);
    });
