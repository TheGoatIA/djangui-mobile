import 'package:flutter/material.dart';
import 'package:kauri/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/auth_bloc.dart';

class AccountSuspendedPage extends StatelessWidget {
  const AccountSuspendedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.gpp_bad_outlined, size: 80, color: Colors.red),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.accountSuspendedTitle,
                style: AppTextStyles.h2.copyWith(color: Colors.red),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.accountSuspendedMessage,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.accountSuspendedThreeStrikes,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 32),
              AppButton(
                text: AppLocalizations.of(context)!.contactSupport,
                onPressed: () {
                  context.push(RouteConstants.createTicket);
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                },
                child: Text(AppLocalizations.of(context)!.signOut),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
