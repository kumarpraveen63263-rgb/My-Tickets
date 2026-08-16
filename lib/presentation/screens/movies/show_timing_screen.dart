import 'package:flutter/material.dart';
import 'theatre_list_screen.dart';

/// Showtimes are presented together with theatres on the theatre-list screen.
/// This wrapper is kept for route completeness so a direct "show timings"
/// entry point resolves to the same combined experience.
class ShowTimingScreen extends StatelessWidget {
  final String movieId;

  const ShowTimingScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return TheatreListScreen(movieId: movieId);
  }
}
