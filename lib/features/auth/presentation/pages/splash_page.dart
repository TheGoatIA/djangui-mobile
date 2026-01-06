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
import '../../../system/domain/repositories/system_repository.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _timerFinished = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _timerFinished = true;
        });
        _checkVersionAndNavigate();
      }
    });
  }

  Future<void> _checkVersionAndNavigate() async {
    // 1. Check App Version
    try {
      final systemRepo = getIt<SystemRepository>();
      final versionInfo = await systemRepo.checkVersion();

      if (!mounted) return;

      if (versionInfo.forceUpdate) {
        // Show Blocking Dialog
        _showUpdateDialog(versionInfo.updateUrl, true);
        return;
      }

      if (versionInfo.maintenanceMode) {
        _showMaintenanceDialog(versionInfo.maintenanceMessage);
        return;
      } else if (versionInfo.updateAvailable) {
        // Show Optional Dialog (optional flow, we can just proceed for now or show snackbar)
        // For this task, we verify logic mostly. Let's just log it.
        debugPrint('📲 Update available: ${versionInfo.latestVersion}');
      }
    } catch (e) {
      debugPrint('⚠️ Remote version check failed: $e');
      // Proceed even if check fails (robustness)
    }

    if (!mounted) return;
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() {
    final state = context.read<AuthBloc>().state;
    if (!_timerFinished) return;

    if (state.status == AuthStatus.authenticated ||
        state.status == AuthStatus.unauthenticated) {
      final prefs = getIt<SharedPreferences>();
      final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

      if (!hasSeenOnboarding) {
        context.go(RouteConstants.onBoarding);
        return;
      }

      if (state.status == AuthStatus.authenticated) {
        context.go(RouteConstants.dashboard);
      } else {
        context.go(RouteConstants.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        debugPrint('🌊 [SplashPage] Auth state changed: ${state.status}');
        if (state.status == AuthStatus.authenticated ||
            state.status == AuthStatus.unauthenticated) {
          // If auth state changes while on splash (e.g. from listener), we might re-trigger.
          // But usually we wait for timer + version.
          // Let's rely on _checkVersionAndNavigate calling _checkAuth.
        }
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
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 48),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUpdateDialog(String? url, bool isForce) {
    showDialog(
      context: context,
      barrierDismissible: !isForce,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.updateAvailable),
        content: Text(AppLocalizations.of(context)!.updateRequiredMessage),
        actions: [
          if (!isForce)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          TextButton(
            onPressed: () {
              // Launch URL
              // launchUrl(Uri.parse(url ?? '...'));
            },
            child: Text(AppLocalizations.of(context)!.updateNow),
          ),
        ],
      ),
    );
  }

  void _showMaintenanceDialog(String? message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: Text(AppLocalizations.of(context)!.maintenanceMode),
          content: Text(
            message ?? AppLocalizations.of(context)!.maintenanceMessage,
          ),
          actions: [], // No actions, blocking dialog
        ),
      ),
    );
  }
}
