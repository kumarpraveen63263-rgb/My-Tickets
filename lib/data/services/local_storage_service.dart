import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../models/booking_model.dart';

class LocalStorageService {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(AppConstants.boxAuth);
    await Hive.openBox(AppConstants.boxTickets);
    await Hive.openBox(AppConstants.boxSearch);
    await Hive.openBox(AppConstants.boxSettings);
    await Hive.openBox(AppConstants.boxFavourites);
  }

  Box get _authBox => Hive.box(AppConstants.boxAuth);
  Box get _ticketsBox => Hive.box(AppConstants.boxTickets);
  Box get _searchBox => Hive.box(AppConstants.boxSearch);
  Box get _settingsBox => Hive.box(AppConstants.boxSettings);
  Box get _favouritesBox => Hive.box(AppConstants.boxFavourites);

  // --- Auth ---
  bool get isLoggedIn =>
      _authBox.get('isLoggedIn', defaultValue: false) as bool;
  String? get userPhone => _authBox.get('userPhone') as String?;
  String? get userName => _authBox.get('userName') as String?;

  Future<void> saveSession({
    required String phone,
    required String name,
  }) async {
    await _authBox.put('isLoggedIn', true);
    await _authBox.put('userPhone', phone);
    await _authBox.put('userName', name);
  }

  Future<void> clearSession() async {
    await _authBox.delete('isLoggedIn');
    await _authBox.delete('userPhone');
    await _authBox.delete('userName');
  }

  bool get hasSeenOnboarding =>
      _authBox.get('hasSeenOnboarding', defaultValue: false) as bool;

  Future<void> setOnboardingSeen() async {
    await _authBox.put('hasSeenOnboarding', true);
  }

  String get languageCode =>
      _settingsBox.get('languageCode', defaultValue: 'en') as String;

  Future<void> setLanguageCode(String code) async {
    await _settingsBox.put('languageCode', code);
  }

  // --- Demo ticket persistence ---
  List<BookingModel> get savedBookings {
    return _ticketsBox.values
        .whereType<Map>()
        .map(BookingModel.fromMap)
        .where((booking) => booking.id.isNotEmpty)
        .toList();
  }

  Future<void> saveBooking(BookingModel booking) async {
    await _ticketsBox.put(booking.id, booking.toMap());
  }

  Future<void> clearSavedBookings() async {
    await _ticketsBox.clear();
  }

  // --- Recent searches ---
  List<String> get recentSearches =>
      (_searchBox.get('recent', defaultValue: <String>[]) as List)
          .cast<String>();

  Future<void> addRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final list = recentSearches.where((item) => item != trimmed).toList();
    list.insert(0, trimmed);
    await _searchBox.put('recent', list.take(10).toList());
  }

  Future<void> clearRecentSearches() async {
    await _searchBox.put('recent', <String>[]);
  }

  // --- Settings ---
  bool get notificationsEnabled =>
      _settingsBox.get('notificationsEnabled', defaultValue: true) as bool;

  Future<void> setNotificationsEnabled(bool value) async {
    await _settingsBox.put('notificationsEnabled', value);
  }

  // --- Favourites ---
  List<String> get favouriteTheatres =>
      (_favouritesBox.get('theatres', defaultValue: <String>[]) as List)
          .cast<String>();

  Future<void> toggleFavouriteTheatre(String theatreId) async {
    final list = favouriteTheatres.toList();
    if (list.contains(theatreId)) {
      list.remove(theatreId);
    } else {
      list.add(theatreId);
    }
    await _favouritesBox.put('theatres', list);
  }

  List<String> get favouriteEvents =>
      (_favouritesBox.get('events', defaultValue: <String>[]) as List)
          .cast<String>();

  Future<void> toggleFavouriteEvent(String eventId) async {
    final list = favouriteEvents.toList();
    if (list.contains(eventId)) {
      list.remove(eventId);
    } else {
      list.add(eventId);
    }
    await _favouritesBox.put('events', list);
  }

  List<String> get favouriteMetroRoutes =>
      (_favouritesBox.get('metroRoutes', defaultValue: <String>[]) as List)
          .cast<String>();

  Future<void> saveFavouriteMetroRoutes(List<String> routes) async {
    await _favouritesBox.put('metroRoutes', routes.take(20).toList());
  }
}
