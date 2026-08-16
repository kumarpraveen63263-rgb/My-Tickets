import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/local_storage_service.dart';
import 'auth_provider.dart';

String metroRouteKey(String from, String to) => '$from||$to';

final metroFavouriteRoutesProvider =
    StateNotifierProvider<MetroFavouriteRoutesNotifier, Set<String>>((ref) {
      final storage = ref.watch(localStorageServiceProvider);
      return MetroFavouriteRoutesNotifier(
        storage.favouriteMetroRoutes,
        storage,
      );
    });

class MetroFavouriteRoutesNotifier extends StateNotifier<Set<String>> {
  MetroFavouriteRoutesNotifier(List<String> initialRoutes, this._storage)
    : super(initialRoutes.toSet());

  final LocalStorageService _storage;

  Future<void> toggle(String routeKey) async {
    final next = {...state};
    if (!next.add(routeKey)) {
      next.remove(routeKey);
    }
    state = next;
    await _storage.saveFavouriteMetroRoutes(next.toList());
  }

  bool contains(String routeKey) => state.contains(routeKey);
}
