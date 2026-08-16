/// Canonical slugs for the Discover screen's category chips.
class EventCategorySlugs {
  EventCategorySlugs._();

  static const String music = 'music';
  static const String comedy = 'comedy';
  static const String sports = 'sports';
  static const String workshops = 'workshops';
  static const String artCulture = 'art_culture';
}

class TicketCategoryModel {
  final String name;
  final double price;
  final int available;

  const TicketCategoryModel({
    required this.name,
    required this.price,
    required this.available,
  });
}

class EventModel {
  final String id;
  final String title;
  final String bannerUrl;
  final String category;

  /// Coarse taxonomy used only by the Events Discover screen's category
  /// chips (music / comedy / sports / workshops / art_culture). Kept
  /// separate from [category] — which stays a free-form display label shown
  /// on cards everywhere else in the app (e.g. "Concert", "Conference") — so
  /// adding this filter doesn't touch any existing category-string usage.
  final String categorySlug;
  final String venue;
  final String city;
  final DateTime date;
  final String time;
  final double priceMin;
  final double priceMax;
  final String description;
  final String organizer;
  final List<TicketCategoryModel> ticketCategories;
  final bool isPopular;
  final bool isFeatured;

  const EventModel({
    required this.id,
    required this.title,
    required this.bannerUrl,
    required this.category,
    required this.categorySlug,
    required this.venue,
    required this.city,
    required this.date,
    required this.time,
    required this.priceMin,
    required this.priceMax,
    required this.description,
    required this.organizer,
    required this.ticketCategories,
    this.isPopular = false,
    this.isFeatured = false,
  });

  String get priceRangeLabel => priceMin == priceMax
      ? '₹${priceMin.toInt()}'
      : '₹${priceMin.toInt()} - ₹${priceMax.toInt()}';
}
