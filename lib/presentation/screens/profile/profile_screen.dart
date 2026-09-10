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
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.accentMovie.withValues(alpha: 0.12),
                    child: Text(
                      (user?.name ?? 'Guest').initials,
                      style: AppTypography.displaySmall.copyWith(
                        color: AppColors.accentMovie,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Guest User',
                          style: AppTypography.headline,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '+91 ${(user?.phone ?? '').maskedPhone}',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/profile/edit'),
                    icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            Row(
              children: [
                Expanded(
                  child: _statTile('${user?.bookingsCount ?? 0}', 'Bookings'),
                ),
                const SizedBox(width: 10),
                Expanded(child: _statTile('${user?.savedCount ?? 0}', 'Saved')),
                const SizedBox(width: 10),
                Expanded(
                  child: _statTile('${user?.rewardPoints ?? 0}', 'Points'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            _cardSection(
              title: 'Account',
              children: [
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
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            _cardSection(
              title: 'Preferences',
              children: [
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
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            _cardSection(
              title: 'Offers & Rewards',
              children: [
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
                  () => context.showSnack('You have ${user?.rewardPoints ?? 0} points'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            _cardSection(
              title: 'Support',
              children: [
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
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            _cardSection(
              title: 'App',
              children: [
                _tile(
                  context,
                  Icons.analytics_outlined,
                  'Ticket Report',
                  () => context.push('/profile/report'),
                ),
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
              ],
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
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
            const SizedBox(height: AppDimensions.bottomPadding),
          ],
        ),
      ),
    );
  }

  Widget _statTile(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.displaySmall.copyWith(
              color: AppColors.accentMovie,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }

  Widget _cardSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: AppTypography.titleMedium),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                children[i],
              ],
            ],
          ),
        ),
      ],
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
      leading: Icon(icon, color: AppColors.textSecondary, size: 20),
      title: Text(label, style: AppTypography.bodyMedium),
      trailing:
          trailing ??
          const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20),
      onTap: onTap,
    );
  }
}
