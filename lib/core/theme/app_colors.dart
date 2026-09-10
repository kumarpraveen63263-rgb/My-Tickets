import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background & Surface
  static const Color background = Color(0xFFF8F9FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF3F4F6);
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE5E7EB);

  // Accent Colors
  static const Color accentMovie = Color(0xFFE92F4F);
  static const Color accentEvent = Color(0xFF6D35C9);
  static const Color accentMetro = Color(0xFF159BEA);
  static const Color accentOffer = Color(0xFFFF6B2B);

  // Metro line colors — used for polylines, markers and station badges on
  // the interactive map so each line reads consistently everywhere.
  static const Color metroLineBlue = accentMetro;
  static const Color metroLineGreen = Color(0xFF16A34A);
  static const Color metroInterchange = Color(0xFFF59E0B);
  static const Color metroSelectedRoute = Color(0xFF0EA5E9);

  // Text
  static const Color textPrimary = Color(0xFF18181B);
  static const Color textSecondary = Color(0xFF71717A);
  static const Color textMuted = Color(0xFFA1A1AA);

  // Status
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  // Seat Colors
  static const Color seatAvailable = Color(0xFFE4E4E7);
  static const Color seatSelected = Color(0xFFE92F4F);
  static const Color seatBooked = Color(0xFFD4D4D8);
  static const Color seatPremium = Color(0xFFF59E0B);
  static const Color seatRecliner = Color(0xFF6D35C9);

  // Shimmer & Overlay
  static const Color shimmerBase = Color(0xFFE5E7EB);
  static const Color shimmerHighlight = Color(0xFFF3F4F6);
  static const Color overlay = Color(0x66000000);
}
