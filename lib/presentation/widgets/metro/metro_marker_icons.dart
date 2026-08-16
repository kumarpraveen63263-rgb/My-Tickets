import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/theme/app_colors.dart';

/// Pre-renders every marker bitmap the interactive metro map needs, once,
/// via [Canvas] (never a default red Google pin, never hand-authored SVG
/// path data). Regular stations are small colored dots; interchanges get a
/// double ring; the selected From/To stations get a larger badge — a
/// shadowed circle with a glyph — so they read as clearly different from
/// the rest of the network at a glance.
class MetroMarkerIcons {
  MetroMarkerIcons._();

  static const double _dotLogicalSize = 18;
  static const double _interchangeLogicalSize = 24;
  static const double _badgeLogicalSize = 40;
  static const double _renderScale =
      3; // physical px per logical px, for crisp icons on retina displays

  static Future<Map<String, BitmapDescriptor>> load() async {
    final results = await Future.wait([
      _dot(fill: AppColors.metroLineBlue),
      _dot(fill: AppColors.metroLineGreen),
      _interchangeDot(),
      _badge(
        color: AppColors.metroSelectedRoute,
        icon: Icons.trip_origin_rounded,
      ),
      _badge(color: AppColors.accentMovie, icon: Icons.location_on_rounded),
    ]);
    return {
      'blue': results[0],
      'green': results[1],
      'interchange': results[2],
      'from': results[3],
      'to': results[4],
    };
  }

  static Future<BitmapDescriptor> _dot({required Color fill}) async {
    final size = _dotLogicalSize * _renderScale;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final center = Offset(size / 2, size / 2);
    final radius = size / 2 - _renderScale;

    canvas.drawCircle(center, radius, Paint()..color = fill);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = _renderScale * 1.6,
    );

    return _toBitmap(recorder, size, _dotLogicalSize);
  }

  static Future<BitmapDescriptor> _interchangeDot() async {
    final size = _interchangeLogicalSize * _renderScale;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final center = Offset(size / 2, size / 2);
    final outerRadius = size / 2 - _renderScale;

    canvas.drawCircle(center, outerRadius, Paint()..color = Colors.white);
    canvas.drawCircle(
      center,
      outerRadius,
      Paint()
        ..color = AppColors.metroInterchange
        ..style = PaintingStyle.stroke
        ..strokeWidth = _renderScale * 2,
    );
    canvas.drawCircle(
      center,
      outerRadius * 0.42,
      Paint()..color = AppColors.metroInterchange,
    );

    return _toBitmap(recorder, size, _interchangeLogicalSize);
  }

  static Future<BitmapDescriptor> _badge({
    required Color color,
    required IconData icon,
  }) async {
    // Extra vertical room below the circle for a soft "grounded" shadow.
    final width = _badgeLogicalSize * _renderScale;
    final height = (_badgeLogicalSize + 8) * _renderScale;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final circleCenter = Offset(width / 2, width / 2);
    final radius = width / 2 - _renderScale * 2;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(width / 2, height - _renderScale * 6),
        width: radius * 1.1,
        height: radius * 0.4,
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.32),
    );
    canvas.drawCircle(circleCenter, radius, Paint()..color = Colors.white);
    canvas.drawCircle(
      circleCenter,
      radius - _renderScale * 2,
      Paint()..color = color,
    );

    final textPainter = TextPainter(textDirection: TextDirection.ltr)
      ..text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: radius * 0.95,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: Colors.white,
        ),
      )
      ..layout();
    textPainter.paint(
      canvas,
      circleCenter - Offset(textPainter.width / 2, textPainter.height / 2),
    );

    return _toBitmap(
      recorder,
      width,
      _badgeLogicalSize,
      height: height,
      logicalHeight: _badgeLogicalSize + 8,
    );
  }

  static Future<BitmapDescriptor> _toBitmap(
    ui.PictureRecorder recorder,
    double width,
    double logicalWidth, {
    double? height,
    double? logicalHeight,
  }) async {
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      width.toInt(),
      (height ?? width).toInt(),
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = data!.buffer.asUint8List();
    return BitmapDescriptor.bytes(
      bytes,
      width: logicalWidth,
      height: logicalHeight ?? logicalWidth,
    );
  }
}
