import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../di/injection.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late List<OnboardingContent> _contents;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contents = [
      OnboardingContent(
        title: AppLocalizations.of(context)!.onboardingTitle1,
        description: AppLocalizations.of(context)!.onboardingDesc1,
        image: AppAssets.onboarding1,
      ),
      OnboardingContent(
        title: AppLocalizations.of(context)!.onboardingTitle2,
        description: AppLocalizations.of(context)!.onboardingDesc2,
        image: AppAssets.onboarding2,
      ),
      OnboardingContent(
        title: AppLocalizations.of(context)!.onboardingTitle3,
        description: AppLocalizations.of(context)!.onboardingDesc3,
        image: AppAssets.onboarding3,
      ),
    ];
  }

  void _onNext() async {
    if (_currentPage < _contents.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final router = GoRouter.of(context);
      final prefs = getIt<SharedPreferences>();
      await prefs.setBool('hasSeenOnboarding', true);
      if (!mounted) return;
      router.go(RouteConstants.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () async {
                  final router = GoRouter.of(context);
                  final prefs = getIt<SharedPreferences>();
                  await prefs.setBool('hasSeenOnboarding', true);
                  if (!mounted) return;
                  router.go(RouteConstants.login);
                },
                child: Text(
                  AppLocalizations.of(context)!.skip,
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.grey),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _contents.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          _contents[index].image,
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 60),
                        Text(
                          _contents[index].title,
                          style: AppTextStyles.headlineMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onBackground,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _contents[index].description,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _contents.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  AppButton(
                    text: _currentPage == _contents.length - 1
                        ? AppLocalizations.of(context)!.start
                        : AppLocalizations.of(context)!.next,
                    onPressed: _onNext,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final String image;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.image,
  });
}
