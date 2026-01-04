import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/auth_bloc.dart';
import '../../../../l10n/app_localizations.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onVerify() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthPhoneVerificationRequested(_phoneController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.codeSent) {
          context.push(
            '/otp-verification',
            extra: {
              'phoneNumber': _phoneController.text.trim(),
              'verificationId': state.verificationId,
            },
          );
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
        appBar: AppBar(
          title: Text(l10n.phoneLogin),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.p24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.enterPhone,
                    style: AppTextStyles.h2,
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2),
                  AppSpacing.gap32,
                  AppTextField(
                    controller: _phoneController,
                    label: l10n.phoneNumber,
                    hint: '+237 6xx xxx xxx',
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.requiredField;
                      }
                      // Basic phone validation
                      if (!RegExp(
                        r'^\+?[0-9]{9,15}$',
                      ).hasMatch(value.replaceAll(' ', ''))) {
                        return l10n.invalidPhone;
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                  AppSpacing.gap24,
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AppButton(
                        text: l10n.verify,
                        onPressed: _onVerify,
                        isLoading: state.status == AuthStatus.loading,
                      );
                    },
                  ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
