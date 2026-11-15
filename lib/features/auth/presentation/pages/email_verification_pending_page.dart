import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/route_constants.dart';
import '../bloc/auth_bloc.dart';

class EmailVerificationPendingPage extends StatelessWidget {
  const EmailVerificationPendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.mark_email_unread_outlined,
                size: 100,
                color: Colors.orange,
              ),
              const SizedBox(height: 32),
              Text(
                l10n.verifyYourEmail,
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.verifyEmailDescription,
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              AppButton(
                text: l10n.backToLogin,
                onPressed: () async {
                  // Attendre la déconnexion EFFECTIVE avant d'aller au login :
                  // sinon le routeur voyait encore une session ouverte et
                  // redirigeait vers l'accueil (vérification contournée).
                  final auth = context.read<AuthBloc>();
                  final router = GoRouter.of(context);
                  auth.add(AuthLogoutRequested());
                  await auth.stream
                      .firstWhere((s) => s.status == AuthStatus.unauthenticated)
                      .timeout(
                        const Duration(seconds: 10),
                        onTimeout: () => auth.state,
                      );
                  router.go(RouteConstants.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
