import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/auth_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final bool isLinking;

  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
    this.isLinking = false,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _pinController = TextEditingController();

  void _onVerify(String code) {
    if (widget.isLinking) {
      context.read<AuthBloc>().add(
        AuthLinkPhoneRequested(
          verificationId: widget.verificationId,
          smsCode: code,
        ),
      );
    } else {
      context.read<AuthBloc>().add(
        AuthPhoneSignInRequested(
          verificationId: widget.verificationId,
          smsCode: code,
        ),
      );
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: AppTextStyles.h3.copyWith(color: AppColors.primary),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.go('/dashboard');
        } else if (state.status == AuthStatus.phoneLinked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.phoneLinkedSuccess),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop(); // Back to Settings/Profile
          context.pop(); // Back to Phone Input
        } else if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? l10n.genericError),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.p24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.enterOtp,
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2),
                AppSpacing.gap8,
                Text(
                  widget.phoneNumber,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.secondary,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                AppSpacing.gap48,
                Center(
                  child: Pinput(
                    length: 6,
                    controller: _pinController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                    ),
                    onCompleted: _onVerify,
                  ).animate().fadeIn(delay: 400.ms, duration: 400.ms).scale(),
                ),
                AppSpacing.gap48,
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return AppButton(
                      text: l10n.verify,
                      onPressed: () => _onVerify(_pinController.text),
                      isLoading: state.status == AuthStatus.loading,
                    );
                  },
                ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
                AppSpacing.gap24,
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      AuthPhoneVerificationRequested(widget.phoneNumber),
                    );
                  },
                  child: Text(l10n.resendCode),
                ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
