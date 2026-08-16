import '../models/offer_model.dart';

class OfferRepository {
  static final List<OfferModel> _offers = [
    OfferModel(
      id: 'o001',
      title: 'Flat ₹100 Off',
      description: 'On your first movie booking with MyTickets',
      imageUrl: 'https://picsum.photos/seed/offer1/400/240',
      discountText: '₹100 OFF',
      code: 'FIRST100',
      expiresAt: DateTime.now().add(const Duration(hours: 30)),
    ),
    OfferModel(
      id: 'o002',
      title: '20% Off on Events',
      description: 'Valid on all concert and comedy show bookings',
      imageUrl: 'https://picsum.photos/seed/offer2/400/240',
      discountText: '20% OFF',
      code: 'EVENT20',
      expiresAt: DateTime.now().add(const Duration(days: 5)),
    ),
    OfferModel(
      id: 'o003',
      title: 'Metro Combo Saver',
      description: 'Book 5 metro rides and save ₹25 instantly',
      imageUrl: 'https://picsum.photos/seed/offer3/400/240',
      discountText: '₹25 OFF',
      code: 'METRO5',
      expiresAt: DateTime.now().add(const Duration(hours: 20)),
    ),
    OfferModel(
      id: 'o004',
      title: 'Weekend Movie Bonanza',
      description: 'Extra 15% off on weekend shows above ₹300',
      imageUrl: 'https://picsum.photos/seed/offer4/400/240',
      discountText: '15% OFF',
      code: 'WEEKEND15',
      expiresAt: DateTime.now().add(const Duration(days: 3)),
    ),
  ];

  Future<List<OfferModel>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _offers;
  }

  Future<OfferModel?> validateCode(String code) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _offers.firstWhere(
        (o) => o.code.toUpperCase() == code.toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
