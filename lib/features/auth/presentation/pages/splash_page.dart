import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/constants/app_assets.dart';
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
  bool _versionCheckFinished = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _timerFinished = true;
        });
        _checkAuthAndNavigate();
      }
    });
    _checkVersionAndNavigate();
  }

  Future<void> _checkVersionAndNavigate() async {
    // 1. Check App Version with timeout
    try {
      final systemRepo = getIt<SystemRepository>();
      final versionInfo = await systemRepo.checkVersion().timeout(
        const Duration(seconds: 5),
      );

      if (!mounted) return;

      if (versionInfo.forceUpdate) {
        _showUpdateDialog(versionInfo.updateUrl, true);
        return;
      }

      if (versionInfo.maintenanceMode) {
        _showMaintenanceDialog(versionInfo.maintenanceMessage);
        return;
      }
    } catch (e) {
      debugPrint('⚠️ Remote version check failed or timed out: $e');
    }

    if (!mounted) return;
    setState(() {
      _versionCheckFinished = true;
    });
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() {
    if (!mounted) return;
    final state = context.read<AuthBloc>().state;

    // Wait for BOTH timer AND version check (or its timeout)
    if (!_timerFinished || !_versionCheckFinished) return;

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
          _checkAuthAndNavigate();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(AppAssets.logo, width: 80, height: 80),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.appTitle,
                style: AppTextStyles.headlineLarge.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
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
