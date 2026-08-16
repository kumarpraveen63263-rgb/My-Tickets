import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_dimensions.dart';

class QrDisplayWidget extends StatelessWidget {
  final String data;
  final double size;

  const QrDisplayWidget({super.key, required this.data, this.size = 180});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showExpanded(context),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: QrImageView(
          data: data,
          version: QrVersions.auto,
          size: size,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  void _showExpanded(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: QrImageView(
            data: data,
            version: QrVersions.auto,
            size: 280,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
