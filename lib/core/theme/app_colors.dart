import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF0F1F3);
  static const Color border = Color(0xFFE0E0E8);

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
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B6B80);
  static const Color textMuted = Color(0xFFA0A0B0);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Seat Colors
  static const Color seatAvailable = Color(0xFFE8E8F0);
  static const Color seatSelected = Color(0xFFE63946);
  static const Color seatBooked = Color(0xFFD0D0DA);
  static const Color seatPremium = Color(0xFFFFD700);
  static const Color seatRecliner = Color(0xFF7B2FBE);
}
