import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  double _page = 0;

  late List<OnboardingContent> _contents;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() => _page = _pageController.page ?? 0);
    });
  }

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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final router = GoRouter.of(context);
    final prefs = getIt<SharedPreferences>();
    await prefs.setBool('hasSeenOnboarding', true);
    if (!mounted) return;
    router.go(RouteConstants.login);
  }

  void _onNext() {
    final currentPage = _page.round();
    if (currentPage < _contents.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentPage = _page.round();

    return Scaffold(
      body: DecoratedBox(
        // Fond en dégradé doux aux couleurs signature Kauri, désaturé pour
        // rester lisible en fond d'écran plutôt que comme élément d'accent.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.primaryDark.withValues(alpha: 0.35),
                    theme.scaffoldBackgroundColor,
                  ]
                : [
                    AppColors.primaryLight.withValues(alpha: 0.10),
                    AppColors.secondaryLight.withValues(alpha: 0.06),
                    theme.scaffoldBackgroundColor,
                  ],
            stops: isDark ? const [0, 0.6] : const [0, 0.4, 0.8],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(
                    AppLocalizations.of(context)!.skip,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _contents.length,
                  itemBuilder: (context, index) {
                    // Effet de parallaxe léger : l'illustration se décale et
                    // s'estompe légèrement plus vite que le texte pendant le
                    // glissement entre deux pages, pour donner une sensation
                    // de profondeur plutôt qu'un simple slide plat.
                    final delta = (_page - index).clamp(-1.0, 1.0);
                    return Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.translate(
                            offset: Offset(delta * -32, 0),
                            child: Opacity(
                              opacity: (1 - delta.abs() * 0.6).clamp(0.4, 1.0),
                              child:
                                  Image.asset(
                                        _contents[index].image,
                                        height: 250,
                                        fit: BoxFit.contain,
                                      )
                                      .animate(
                                        onPlay: (c) => c.repeat(reverse: true),
                                      )
                                      .scaleXY(
                                        begin: 1,
                                        end: 1.03,
                                        duration: 3000.ms,
                                        curve: Curves.easeInOut,
                                      ),
                            ),
                          ),
                          const SizedBox(height: 60),
                          Text(
                                _contents[index].title,
                                style: AppTextStyles.headlineMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              )
                              .animate(delay: 100.ms)
                              .fadeIn(duration: 450.ms)
                              .slideY(
                                begin: 0.15,
                                end: 0,
                                curve: Curves.easeOutCubic,
                              ),
                          const SizedBox(height: 24),
                          Text(
                                _contents[index].description,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              )
                              .animate(delay: 220.ms)
                              .fadeIn(duration: 450.ms)
                              .slideY(
                                begin: 0.15,
                                end: 0,
                                curve: Curves.easeOutCubic,
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
                      children: List.generate(_contents.length, (index) {
                        final active = currentPage == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: active ? 24 : 8,
                          decoration: BoxDecoration(
                            color: active
                                ? theme.colorScheme.primary
                                : theme.colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 48),
                    AppButton(
                      text: currentPage == _contents.length - 1
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
