class OfferModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String discountText;
  final String code;
  final DateTime expiresAt;

  const OfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.discountText,
    required this.code,
    required this.expiresAt,
  });

  Duration get timeLeft => expiresAt.difference(DateTime.now());
  bool get isExpiringSoon =>
      timeLeft.inHours < 48 && timeLeft.isNegative == false;
}
