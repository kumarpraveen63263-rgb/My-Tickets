import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  final int votes;
  final double starSize;

  const RatingBar({
    super.key,
    required this.rating,
    this.votes = 0,
    this.starSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final starRating = (rating / 2).clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          IconData icon;
          if (starRating >= i + 1) {
            icon = Icons.star_rounded;
          } else if (starRating > i) {
            icon = Icons.star_half_rounded;
          } else {
            icon = Icons.star_border_rounded;
          }
          return Icon(icon, size: starSize, color: AppColors.seatPremium);
        }),
        const SizedBox(width: 6),
        Text(
          '${rating.toStringAsFixed(1)}/10',
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (votes > 0) ...[
          const SizedBox(width: 4),
          Text('(${_formatVotes(votes)} votes)', style: AppTypography.caption),
        ],
      ],
    );
  }

  String _formatVotes(int votes) {
    if (votes >= 100000) return '${(votes / 100000).toStringAsFixed(1)}L';
    if (votes >= 1000) return '${(votes / 1000).toStringAsFixed(1)}K';
    return '$votes';
  }
}
