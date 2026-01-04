import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>()..add(AuthCheckRequested()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // Add a small delay for branding
          Future.delayed(const Duration(seconds: 2), () {
            final prefs = getIt<SharedPreferences>();
            final hasSeenOnboarding =
                prefs.getBool('hasSeenOnboarding') ?? false;

            if (!hasSeenOnboarding) {
              if (context.mounted) {
                context.go(RouteConstants.onBoarding);
              }
              return;
            }

            if (context.mounted) {
              if (state.status == AuthStatus.authenticated) {
                context.go(RouteConstants.dashboard);
              } else if (state.status == AuthStatus.unauthenticated) {
                context.go(RouteConstants.login);
              }
            }
          });
        },
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(AppAssets.logo, width: 80, height: 80),
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.appTitle,
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.appSlogan,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 48),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
