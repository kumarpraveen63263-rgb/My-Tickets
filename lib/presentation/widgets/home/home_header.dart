import '../../../core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/services/notification_service.dart';
import '../../../providers/auth_provider.dart';
import '../common/app_badge.dart';
import '../common/app_bottom_sheet.dart';
import '../common/app_empty_state.dart';

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

final notificationsProvider = FutureProvider<List<AppNotification>>((ref) {
  return ref.watch(notificationServiceProvider).getAll();
});

String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good Morning';
  if (hour < 17) return 'Good Afternoon';
  return 'Good Evening';
}

class HomeHeader extends ConsumerWidget {
  HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final notifications = ref.watch(notificationsProvider);
    final unreadCount = notifications.maybeWhen(
      data: (list) => list.where((n) => !n.isRead).length,
      orElse: () => 0,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingMedium,
        AppDimensions.paddingSmall,
        AppDimensions.paddingMedium,
        AppDimensions.paddingSmall,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: AppColors.accentMovie,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      AppConstants.defaultCity,
                      style: AppTypography.bodySmall,
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  '${_greeting()}, ${(user?.name ?? 'Guest').split(' ').first} 👋',
                  style: AppTypography.headline,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showNotifications(context, notifications),
            child: DotBadge(
              count: unreadCount,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotifications(
    BuildContext context,
    AsyncValue<List<AppNotification>> notifications,
  ) {
    AppBottomSheet.show(
      context,
      title: context.tr('Notifications'),
      child: notifications.when(
        loading: () => SizedBox(
          height: 120,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => SizedBox(
          height: 120,
          child: Center(
            child: Text(context.tr('Failed to load notifications')),
          ),
        ),
        data: (list) {
          if (list.isEmpty) {
            return SizedBox(
              height: 160,
              child: AppEmptyState(
                icon: Icons.notifications_off_outlined,
                title: context.tr('No notifications yet'),
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            itemCount: list.length,
            separatorBuilder: (_, _) => Divider(height: 1),
            itemBuilder: (context, index) {
              final n = list[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: n.isRead
                      ? AppColors.surfaceElevated
                      : AppColors.accentMovie.withValues(alpha: 0.16),
                  child: Icon(
                    Icons.notifications_rounded,
                    size: 18,
                    color: n.isRead
                        ? AppColors.textSecondary
                        : AppColors.accentMovie,
                  ),
                ),
                title: Text(n.title, style: AppTypography.titleMedium),
                subtitle: Text(n.body, style: AppTypography.bodySmall),
                trailing: Text(
                  AppDateUtils.timeAgo(n.time),
                  style: AppTypography.caption,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
