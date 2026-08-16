import '../../../core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/extensions.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.accentMovie.withValues(alpha: 0.16),
                child: Text(
                  (user?.name ?? 'Guest').initials,
                  style: AppTypography.displaySmall.copyWith(
                    color: AppColors.accentMovie,
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Guest User',
                      style: AppTypography.headline,
                    ),
                    SizedBox(height: 2),
                    Text(
                      '+91 ${(user?.phone ?? '').maskedPhone}',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context.push('/profile/edit'),
                icon: Icon(Icons.edit_outlined, color: AppColors.textSecondary),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingLarge),
          Row(
            children: [
              Expanded(
                child: _statTile('${user?.bookingsCount ?? 0}', 'Bookings'),
              ),
              Expanded(child: _statTile('${user?.savedCount ?? 0}', 'Saved')),
              Expanded(
                child: _statTile('${user?.rewardPoints ?? 0}', 'Points'),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingLarge),
          _sectionTitle('Account'),
          _tile(
            context,
            Icons.person_outline_rounded,
            'Edit Profile',
            () => context.push('/profile/edit'),
          ),
          _tile(
            context,
            Icons.location_on_outlined,
            'Saved Addresses',
            () => context.showSnack('No saved addresses yet'),
          ),
          _tile(
            context,
            Icons.credit_card_outlined,
            'Saved Payment Methods',
            () => context.showSnack('No saved payment methods yet'),
          ),
          SizedBox(height: AppDimensions.paddingLarge),
          _sectionTitle('Preferences'),
          _tile(
            context,
            Icons.theaters_outlined,
            'Favourite Theatres',
            () => context.showSnack('No favourite theatres yet'),
          ),
          _tile(
            context,
            Icons.celebration_outlined,
            'Favourite Venues',
            () => context.showSnack('No favourite venues yet'),
          ),
          _tile(
            context,
            Icons.notifications_outlined,
            'Notification Settings',
            () => context.push('/profile/settings'),
          ),
          SizedBox(height: AppDimensions.paddingLarge),
          _sectionTitle('Offers & Rewards'),
          _tile(
            context,
            Icons.local_offer_outlined,
            'My Coupons',
            () => context.showSnack('No coupons available'),
          ),
          _tile(
            context,
            Icons.card_giftcard_outlined,
            'Referral Program',
            () => context.showSnack('Invite friends and earn rewards'),
          ),
          _tile(
            context,
            Icons.stars_outlined,
            'Loyalty Points',
            () =>
                context.showSnack('You have ${user?.rewardPoints ?? 0} points'),
          ),
          SizedBox(height: AppDimensions.paddingLarge),
          _sectionTitle('Support'),
          _tile(
            context,
            Icons.help_outline_rounded,
            'Help Center',
            () => context.showSnack('Help Center coming soon'),
          ),
          _tile(
            context,
            Icons.quiz_outlined,
            'FAQs',
            () => context.showSnack('FAQs coming soon'),
          ),
          _tile(
            context,
            Icons.mail_outline_rounded,
            'Contact Us',
            () => context.showSnack('support@mytickets.app'),
          ),
          _tile(
            context,
            Icons.star_outline_rounded,
            'Rate the App',
            () => context.showSnack('Thanks for your support!'),
          ),
          SizedBox(height: AppDimensions.paddingLarge),
          _sectionTitle('App'),
          _tile(
            context,
            Icons.settings_outlined,
            'Settings',
            () => context.push('/profile/settings'),
          ),
          _tile(
            context,
            Icons.privacy_tip_outlined,
            'Privacy Policy',
            () => context.showSnack('Privacy Policy coming soon'),
          ),
          _tile(
            context,
            Icons.description_outlined,
            'Terms of Service',
            () => context.showSnack('Terms of Service coming soon'),
          ),
          _tile(
            context,
            Icons.info_outline_rounded,
            context.tr('App Version'),
            () {},
            trailing: Text(
              '${AppConstants.appName} v0.1.0',
              style: AppTypography.caption,
            ),
          ),
          SizedBox(height: AppDimensions.paddingLarge),
          AppButton(
            label: 'Logout',
            variant: AppButtonVariant.danger,
            onPressed: () async {
              final confirmed = await AppDialog.show(
                context,
                title: 'Logout',
                message: 'Are you sure you want to logout of your account?',
                confirmLabel: 'Logout',
                confirmVariant: AppButtonVariant.danger,
              );
              if (confirmed == true) {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) context.go('/login');
              }
            },
          ),
          SizedBox(height: AppDimensions.bottomPadding),
        ],
      ),
    );
  }

  Widget _statTile(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.displaySmall.copyWith(
            color: AppColors.accentMovie,
          ),
        ),
        SizedBox(height: 2),
        Text(label, style: AppTypography.caption),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Text(title, style: AppTypography.titleLarge),
    );
  }

  Widget _tile(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(label, style: AppTypography.bodyLarge),
      trailing:
          trailing ??
          Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
