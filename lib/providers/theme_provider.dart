import 'package:flutter_riverpod/flutter_riverpod.dart';

/// MyTickets ships a single, carefully designed dark theme (see core/theme).
/// This flag drives the Settings toggle and is persisted for user preference,
/// but the visual design system in this app is dark-first by spec.
final isDarkModeProvider = StateProvider<bool>((ref) => true);
