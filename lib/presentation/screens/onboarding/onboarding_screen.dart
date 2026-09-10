import '../../../core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/common/app_button.dart';

class _OnboardingSlide {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static final List<_OnboardingSlide> _slides = [
    const _OnboardingSlide(
      icon: Icons.movie_filter_rounded,
      title: 'Discover & Book Movies',
      subtitle:
          'Browse the latest releases, compare prices, and grab the best seats in seconds.',
      color: AppColors.accentMovie,
    ),
    _OnboardingSlide(
      icon: Icons.celebration_rounded,
      title: AppLocale.tr('Events Near You'),
      subtitle:
          'Concerts, comedy nights, food festivals and more — never miss what\'s happening in your city.',
      color: AppColors.accentEvent,
    ),
    const _OnboardingSlide(
      icon: Icons.train_rounded,
      title: 'Ride the Metro Smarter',
      subtitle:
          'Plan routes, check fares, and book metro tickets with a single tap.',
      color: AppColors.accentMetro,
    ),
  ];

  Future<void> _finish() async {
    await ref.read(localStorageServiceProvider).setOnboardingSeen();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _slides.length - 1;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(
                  AppLocale.tr('Skip'),
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            color: slide.color.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: slide.color.withValues(alpha: 0.25),
                              width: 2,
                            ),
                          ),
                          child: Icon(slide.icon, size: 80, color: slide.color),
                        ),
                        const SizedBox(height: AppDimensions.paddingXL),
                        Text(
                          slide.title,
                          style: AppTypography.displaySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.paddingMedium),
                        Text(
                          slide.subtitle,
                          style: AppTypography.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SmoothPageIndicator(
              controller: _controller,
              count: _slides.length,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: _slides[_page].color,
                dotColor: AppColors.border,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: AppButton(
                label: isLast
                    ? AppLocale.tr('Get Started')
                    : AppLocale.tr('Next'),
                accentColor: _slides[_page].color,
                onPressed: () {
                  if (isLast) {
                    _finish();
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
