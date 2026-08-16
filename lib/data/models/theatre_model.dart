import 'show_model.dart';

class TheatreModel {
  final String id;
  final String name;
  final String location;
  final List<String> amenities;
  final List<ShowModel> shows;

  const TheatreModel({
    required this.id,
    required this.name,
    required this.location,
    required this.amenities,
    required this.shows,
  });

  List<ShowModel> showsOnDate(DateTime date) {
    return shows
        .where(
          (s) =>
              s.date.year == date.year &&
              s.date.month == date.month &&
              s.date.day == date.day,
        )
        .toList();
  }
}
