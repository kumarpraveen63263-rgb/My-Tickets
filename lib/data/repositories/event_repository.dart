import '../models/event_model.dart';

class EventRepository {
  static final List<EventModel> _events = [
    EventModel(
      id: 'e001',
      title: 'Anirudh Live in Concert',
      bannerUrl: 'https://picsum.photos/seed/anirudhconcert/800/450',
      category: 'Concert',
      categorySlug: EventCategorySlugs.music,
      venue: 'YMCA Grounds',
      city: 'Chennai',
      date: DateTime.now().add(const Duration(days: 12)),
      time: '6:30 PM',
      priceMin: 999,
      priceMax: 5999,
      description:
          'Experience an electrifying night of music as Anirudh Ravichander performs his biggest hits live on stage with a full orchestra.',
      organizer: 'BeatBox Events',
      ticketCategories: const [
        TicketCategoryModel(name: 'General', price: 999, available: 400),
        TicketCategoryModel(name: 'Gold', price: 2499, available: 150),
        TicketCategoryModel(name: 'VIP', price: 5999, available: 40),
      ],
      isPopular: true,
      isFeatured: true,
    ),
    EventModel(
      id: 'e002',
      title: 'Zakir Khan — Standup Special',
      bannerUrl: 'https://picsum.photos/seed/zakirkhan/800/450',
      category: 'Comedy',
      categorySlug: EventCategorySlugs.comedy,
      venue: 'Sir Mutha Venkatasubba Rao Concert Hall',
      city: 'Chennai',
      date: DateTime.now().add(const Duration(days: 6)),
      time: '8:00 PM',
      priceMin: 599,
      priceMax: 2499,
      description:
          'India\'s favourite storyteller returns with an all-new hour of stand-up comedy, blending humour and heart.',
      organizer: 'Only Much Louder',
      ticketCategories: const [
        TicketCategoryModel(name: 'Silver', price: 599, available: 200),
        TicketCategoryModel(name: 'Gold', price: 1299, available: 100),
        TicketCategoryModel(name: 'Platinum', price: 2499, available: 30),
      ],
      isPopular: true,
    ),
    EventModel(
      id: 'e003',
      title: 'TechSpark Summit 2026',
      bannerUrl: 'https://picsum.photos/seed/techspark/800/450',
      category: 'Conference',
      categorySlug: EventCategorySlugs.workshops,
      venue: 'Chennai Trade Centre',
      city: 'Chennai',
      date: DateTime.now().add(const Duration(days: 20)),
      time: '9:00 AM',
      priceMin: 1499,
      priceMax: 8999,
      description:
          'A two-day summit bringing together India\'s top engineers, founders, and AI researchers for keynotes, workshops, and networking.',
      organizer: 'TechSpark Media',
      ticketCategories: const [
        TicketCategoryModel(name: 'Day Pass', price: 1499, available: 500),
        TicketCategoryModel(name: 'Full Access', price: 4999, available: 200),
        TicketCategoryModel(
          name: 'All Access + Workshops',
          price: 8999,
          available: 60,
        ),
      ],
      isFeatured: true,
    ),
    EventModel(
      id: 'e004',
      title: 'Chennai Food & Flavours Festival',
      bannerUrl: 'https://picsum.photos/seed/foodfest/800/450',
      category: 'Food Festival',
      categorySlug: EventCategorySlugs.artCulture,
      venue: 'Island Grounds',
      city: 'Chennai',
      date: DateTime.now().add(const Duration(days: 9)),
      time: '11:00 AM',
      priceMin: 199,
      priceMax: 199,
      description:
          'Explore over 150 food stalls from across South India, live cooking shows, and family entertainment zones.',
      organizer: 'Flavours Collective',
      ticketCategories: const [
        TicketCategoryModel(name: 'Entry Pass', price: 199, available: 1000),
      ],
      isPopular: true,
    ),
    EventModel(
      id: 'e005',
      title: 'Chennai Marathon 2026',
      bannerUrl: 'https://picsum.photos/seed/marathon/800/450',
      category: 'Sports',
      categorySlug: EventCategorySlugs.sports,
      venue: 'Marina Beach',
      city: 'Chennai',
      date: DateTime.now().add(const Duration(days: 35)),
      time: '5:00 AM',
      priceMin: 499,
      priceMax: 1499,
      description:
          'Run along the iconic Marina coastline in the city\'s biggest marathon event, with 5K, 10K, and Full Marathon categories.',
      organizer: 'Chennai Runners Club',
      ticketCategories: const [
        TicketCategoryModel(name: '5K Run', price: 499, available: 2000),
        TicketCategoryModel(name: '10K Run', price: 899, available: 1500),
        TicketCategoryModel(name: 'Full Marathon', price: 1499, available: 800),
      ],
    ),
    EventModel(
      id: 'e006',
      title: 'A.R. Rahman — Symphony of Souls',
      bannerUrl: 'https://picsum.photos/seed/arrahman/800/450',
      category: 'Concert',
      categorySlug: EventCategorySlugs.music,
      venue: 'Jawaharlal Nehru Stadium',
      city: 'Chennai',
      date: DateTime.now().add(const Duration(days: 45)),
      time: '7:00 PM',
      priceMin: 1499,
      priceMax: 9999,
      description:
          'The Oscar-winning composer brings a night of orchestral magic, blending his timeless classics with new compositions.',
      organizer: 'KM Musical Productions',
      ticketCategories: const [
        TicketCategoryModel(name: 'Bronze', price: 1499, available: 600),
        TicketCategoryModel(name: 'Silver', price: 3499, available: 300),
        TicketCategoryModel(name: 'Diamond', price: 9999, available: 50),
      ],
      isFeatured: true,
      isPopular: true,
    ),
    EventModel(
      id: 'e007',
      title: 'Improv Comedy Night',
      bannerUrl: 'https://picsum.photos/seed/improv/800/450',
      category: 'Comedy',
      categorySlug: EventCategorySlugs.comedy,
      venue: 'The Music Academy',
      city: 'Chennai',
      date: DateTime.now().add(const Duration(days: 3)),
      time: '7:30 PM',
      priceMin: 349,
      priceMax: 899,
      description:
          'A hilarious night of unscripted comedy games, audience suggestions, and spontaneous storytelling.',
      organizer: 'Chennai Improv Collective',
      ticketCategories: const [
        TicketCategoryModel(name: 'General', price: 349, available: 150),
        TicketCategoryModel(name: 'Front Row', price: 899, available: 40),
      ],
    ),
    EventModel(
      id: 'e008',
      title: 'Startup Founders Meetup',
      bannerUrl: 'https://picsum.photos/seed/startupmeet/800/450',
      category: 'Networking',
      categorySlug: EventCategorySlugs.workshops,
      venue: 'ITC Grand Chola',
      city: 'Chennai',
      date: DateTime.now().add(const Duration(days: 15)),
      time: '6:00 PM',
      priceMin: 0,
      priceMax: 999,
      description:
          'Connect with founders, investors, and operators building the next generation of Indian startups.',
      organizer: 'Chennai Founders Circle',
      ticketCategories: const [
        TicketCategoryModel(name: 'Standard (Free)', price: 0, available: 300),
        TicketCategoryModel(name: 'Investor Lounge', price: 999, available: 50),
      ],
    ),
  ];

  Future<List<EventModel>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _events;
  }

  Future<List<EventModel>> getFeatured() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _events.where((e) => e.isFeatured).toList();
  }

  Future<List<EventModel>> getTrending() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _events.where((e) => e.isPopular).toList();
  }

  Future<EventModel> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _events.firstWhere((e) => e.id == id, orElse: () => _events.first);
  }

  List<EventModel> searchSync(String query) {
    final q = query.toLowerCase();
    return _events
        .where(
          (e) =>
              e.title.toLowerCase().contains(q) ||
              e.category.toLowerCase().contains(q),
        )
        .toList();
  }
}
