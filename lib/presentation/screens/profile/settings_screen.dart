import '../../../core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/language_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final storage = ref.watch(localStorageServiceProvider);
    final language = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(context.tr('Settings')),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        children: [
          _sectionTitle('Preferences'),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              border: Border.all(color: AppColors.border),
            ),
            child: ListTile(
              leading: const Icon(Icons.language_rounded, color: AppColors.accentMovie),
              title: Text(context.tr('Language'), style: AppTypography.bodyMedium),
              subtitle: Text(
                supportedLanguages[language] ?? 'Tamil',
                style: AppTypography.caption,
              ),
              trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
              onTap: () => _showLanguagePicker(context, ref),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          _sectionTitle('Appearance'),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              border: Border.all(color: AppColors.border),
            ),
            child: SwitchListTile(
              activeThumbColor: AppColors.accentMovie,
              value: isDark,
              onChanged: (v) => ref.read(isDarkModeProvider.notifier).state = v,
              title: Text(
                context.tr('Dark Mode'),
                style: AppTypography.bodyMedium,
              ),
              subtitle: Text(
                context.tr(
                  'Switch to dark appearance',
                ),
                style: AppTypography.caption,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          _sectionTitle(context.tr('Notifications')),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              border: Border.all(color: AppColors.border),
            ),
            child: StatefulBuilder(
              builder: (context, setLocalState) => SwitchListTile(
                activeThumbColor: AppColors.accentMovie,
                value: storage.notificationsEnabled,
                onChanged: (v) async {
                  await storage.setNotificationsEnabled(v);
                  setLocalState(() {});
                },
                title: Text(
                  context.tr('Push Notifications'),
                  style: AppTypography.bodyMedium,
                ),
                subtitle: Text(
                  context.tr('Booking updates, reminders and offers'),
                  style: AppTypography.caption,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          _sectionTitle('About'),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              border: Border.all(color: AppColors.border),
            ),
            child: ListTile(
              title: Text(
                context.tr('App Version'),
                style: AppTypography.bodyMedium,
              ),
              trailing: Text(
                '${AppConstants.appName} v0.1.0',
                style: AppTypography.caption,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLanguagePicker(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusLarge)),
      ),
      builder: (sheetContext) {
        final currentLanguage = ref.read(languageProvider);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('Language Preference'),
                  style: AppTypography.titleLarge,
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                RadioGroup<String>(
                  groupValue: currentLanguage,
                  onChanged: (value) async {
                    if (value == null) return;
                    await ref
                        .read(languageProvider.notifier)
                        .setLanguage(value);
                    if (sheetContext.mounted) {
                      Navigator.of(sheetContext).pop();
                    }
                  },
                  child: Column(
                    children: [
                      for (final entry in supportedLanguages.entries)
                        RadioListTile<String>(
                          value: entry.key,
                          activeColor: AppColors.accentMovie,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            entry.value,
                            style: AppTypography.bodyLarge,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title, style: AppTypography.titleMedium),
    );
  }
}
