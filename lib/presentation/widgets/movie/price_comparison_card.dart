import '../../../core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../data/models/price_comparison_model.dart';

class PriceComparisonCard extends StatelessWidget {
  final PriceComparisonModel? comparison;

  const PriceComparisonCard({super.key, required this.comparison});

  @override
  Widget build(BuildContext context) {
    final data = comparison;
    if (data == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.accentOffer.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentOffer.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_rounded,
                color: AppColors.accentOffer,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                context.tr('Best Price Guaranteed'),
                style: AppTypography.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          _row('MyTickets', data.myTicketsPrice, highlight: true),
          const SizedBox(height: 8),
          _row('BookMyShow', data.bookMyShowPrice),
          const SizedBox(height: 8),
          _row('Paytm Tickets', data.paytmPrice),
          if (data.hasSavings) ...[
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(
              'You save ${CurrencyUtils.format(data.savings)} with MyTickets',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, double price, {bool highlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.accentOffer.withValues(alpha: 0.08)
            : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        border: highlight
            ? Border.all(color: AppColors.accentOffer.withValues(alpha: 0.5))
            : Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              if (highlight) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentOffer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Best Price',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Text(
            CurrencyUtils.format(price),
            style: AppTypography.titleMedium.copyWith(
              color: highlight
                  ? AppColors.accentOffer
                  : AppColors.textSecondary,
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
