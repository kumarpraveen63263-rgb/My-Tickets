enum ShowAvailability { available, fastFilling, almostFull }

class ShowModel {
  final String id;
  final String movieId;
  final String theatreId;
  final DateTime date;
  final String time;
  final String screen;
  final ShowAvailability availability;
  final double priceRecliner;
  final double pricePremium;
  final double priceExecutive;
  final double priceNormal;

  const ShowModel({
    required this.id,
    required this.movieId,
    required this.theatreId,
    required this.date,
    required this.time,
    required this.screen,
    required this.availability,
    this.priceRecliner = 380,
    this.pricePremium = 260,
    this.priceExecutive = 200,
    this.priceNormal = 150,
  });
}
