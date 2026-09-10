import '../../../core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/metro_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/metro/interactive_metro_map.dart';
import '../../widgets/metro/route_card.dart';

class MetroHomeScreen extends ConsumerWidget {
  const MetroHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final from = ref.watch(fromStationProvider);
    final to = ref.watch(toStationProvider);
    final recentRoutes = ref.watch(recentRoutesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          children: [
            Row(
              children: [
                const Icon(Icons.train_rounded, color: AppColors.accentMetro, size: 26),
                const SizedBox(width: 8),
                Text('Metro Tickets', style: AppTypography.displaySmall),
                const Spacer(),
                IconButton(
                  onPressed: () => context.push('/metro/map'),
                  icon: const Icon(Icons.map_outlined, color: AppColors.accentMetro),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _stationField(
                    context,
                    ref,
                    label: context.tr('From'),
                    value: from,
                    isFrom: true,
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      const Divider(height: 1),
                      Positioned(
                        right: 8,
                        child: Material(
                          color: AppColors.accentMetro,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              final f = ref.read(fromStationProvider);
                              final t = ref.read(toStationProvider);
                              ref.read(fromStationProvider.notifier).state = t;
                              ref.read(toStationProvider.notifier).state = f;
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.swap_vert_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _stationField(
                    context,
                    ref,
                    label: context.tr('To'),
                    value: to,
                    isFrom: false,
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  AppButton(
                    label: context.tr('Check Route'),
                    accentColor: AppColors.accentMetro,
                    onPressed: from == null || to == null
                        ? null
                        : () {
                            ref
                                .read(recentRoutesProvider.notifier)
                                .addRoute(from, to);
                            context.push('/metro/route');
                          },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                  const SizedBox(width: 8),
                  Text(
                    context.tr('All lines operational'),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr('Live Network Map'),
                  style: AppTypography.titleLarge,
                ),
                GestureDetector(
                  onTap: () => context.push('/metro/map'),
                  child: Text(
                    'Fullscreen',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.accentMetro,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingSmall),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                border: Border.all(color: AppColors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: const InteractiveMetroMap(height: 340),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            if (recentRoutes.isNotEmpty) ...[
              Text(
                context.tr('Recently Travelled'),
                style: AppTypography.titleLarge,
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: recentRoutes
                    .map(
                      (r) => RouteCard(
                        from: r.from,
                        to: r.to,
                        onTap: () {
                          ref.read(fromStationProvider.notifier).state = r.from;
                          ref.read(toStationProvider.notifier).state = r.to;
                          context.push('/metro/route');
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppDimensions.paddingLarge),
            ],
            Text(context.tr('Favourite Routes'), style: AppTypography.titleLarge),
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(
              'Save routes you travel often for quick access.',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: AppDimensions.bottomPadding),
          ],
        ),
      ),
    );
  }

  Widget _stationField(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required String? value,
    required bool isFrom,
  }) {
    return InkWell(
      onTap: () async {
        final result = await context.push<String>('/metro/search-station');
        if (result != null) {
          if (isFrom) {
            ref.read(fromStationProvider.notifier).state = result;
          } else {
            ref.read(toStationProvider.notifier).state = result;
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
        child: Row(
          children: [
            Icon(
              isFrom ? Icons.trip_origin : Icons.location_on_rounded,
              size: 18,
              color: AppColors.accentMetro,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.caption),
                  Text(
                    value ?? context.tr('Select station'),
                    style: AppTypography.titleMedium.copyWith(
                      color: value == null
                          ? AppColors.textMuted
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
