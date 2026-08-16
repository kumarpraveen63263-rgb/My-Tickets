import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF13131A);
  static const Color surfaceElevated = Color(0xFF1C1C26);
  static const Color border = Color(0xFF2A2A38);

  // Accent Colors
  static const Color accentMovie = Color(0xFFE63946);
  static const Color accentEvent = Color(0xFF7B2FBE);
  static const Color accentMetro = Color(0xFF0096FF);
  static const Color accentOffer = Color(0xFFFF6B2B);

  // Metro line colors — used for polylines, markers and station badges on
  // the interactive map so each line reads consistently everywhere.
  static const Color metroLineBlue = accentMetro;
  static const Color metroLineGreen = Color(0xFF22C55E);
  static const Color metroInterchange = Color(0xFFFFD700);
  static const Color metroSelectedRoute = Color(0xFF22D3EE);

  // Text
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFF8E8EA0);
  static const Color textMuted = Color(0xFF4A4A5E);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Seat Colors
  static const Color seatAvailable = Color(0xFF2A2A38);
  static const Color seatSelected = Color(0xFFE63946);
  static const Color seatBooked = Color(0xFF3A3A4A);
  static const Color seatPremium = Color(0xFFFFD700);
  static const Color seatRecliner = Color(0xFF7B2FBE);
}
