import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/metro_model.dart';

/// Maps a [MetroLine] to its brand color. Lives on the presentation side
/// (not on the model) so `data/models` stays free of theme/UI dependencies.
extension MetroLineColor on MetroLine {
  Color get color => this == MetroLine.blue
      ? AppColors.metroLineBlue
      : AppColors.metroLineGreen;
}
