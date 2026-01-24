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
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                  context.go(RouteConstants.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
