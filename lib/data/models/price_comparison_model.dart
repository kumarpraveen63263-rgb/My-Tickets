class PriceComparisonModel {
  final double myTicketsPrice;
  final double bookMyShowPrice;
  final double paytmPrice;

  const PriceComparisonModel({
    required this.myTicketsPrice,
    required this.bookMyShowPrice,
    required this.paytmPrice,
  });

  double get maxCompetitorPrice =>
      bookMyShowPrice > paytmPrice ? bookMyShowPrice : paytmPrice;

  double get savings =>
      (maxCompetitorPrice - myTicketsPrice).clamp(0, double.infinity);

  bool get hasSavings => savings > 0;
}
