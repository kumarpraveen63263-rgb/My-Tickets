import 'price_comparison_model.dart';
import 'theatre_model.dart';

class CastMember {
  final String name;
  final String imageUrl;
  final String role;

  const CastMember({
    required this.name,
    required this.imageUrl,
    required this.role,
  });
}

class ReviewModel {
  final String id;
  final String userName;
  final String userAvatarUrl;
  final double rating;
  final String comment;
  final DateTime date;

  const ReviewModel({
    required this.id,
    required this.userName,
    required this.userAvatarUrl,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class MovieModel {
  final String id;
  final String title;
  final String posterUrl;
  final String bannerUrl;
  final double rating;
  final int votes;
  final int duration;
  final List<String> genre;
  final List<String> language;
  final String certification;
  final String synopsis;
  final List<CastMember> cast;
  final String director;
  final DateTime releaseDate;
  final bool isNowShowing;
  final bool isUpcoming;
  final String trailerUrl;
  final List<TheatreModel> theatres;
  final PriceComparisonModel? priceComparison;
  final List<ReviewModel> reviews;

  const MovieModel({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.bannerUrl,
    required this.rating,
    required this.votes,
    required this.duration,
    required this.genre,
    required this.language,
    required this.certification,
    required this.synopsis,
    required this.cast,
    required this.director,
    required this.releaseDate,
    required this.isNowShowing,
    required this.isUpcoming,
    required this.trailerUrl,
    this.theatres = const [],
    this.priceComparison,
    this.reviews = const [],
  });
}
