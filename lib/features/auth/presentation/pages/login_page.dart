import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/brand_icons.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/auth_bloc.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../di/injection.dart';

/// Page de connexion de l'application.
///
/// Permet l'authentification par email/mot de passe, biométrie (empreinte/visage),
/// Google, Apple et Téléphone.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// Clé globale pour la validation du formulaire.
  final _formKey = GlobalKey<FormState>();

  /// Contrôleur pour le champ email.
  final _emailController = TextEditingController();

  /// Contrôleur pour le champ mot de passe.
  final _passwordController = TextEditingController();

  /// Bascule l'affichage en clair du mot de passe.
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Redirection vers le tableau de bord en cas de succès
        if (state.status == AuthStatus.authenticated) {
          getIt<AnalyticsManager>().trackEvent(
            feature: 'Auth',
            action: 'login_success',
            details: {'provider': 'email'},
          );
          final user = state.authResponse?.user;
          // Check for verification (Email OR Phone)
          final isVerified =
              (user?.isEmailVerified ?? false) ||
              (user?.isPhoneVerified ?? false) ||
              (user?.phone != null && user!.phone!.isNotEmpty);

          if (user != null && !isVerified) {
            context.go(RouteConstants.emailVerificationPending);
          } else {
            context.go(RouteConstants.dashboard);
          }
        }
        // Affichage d'une erreur via SnackBar
        else if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ??
                    AppLocalizations.of(context)!.genericError,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    AppLocalizations.of(context)!.welcomeBack,
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.loginSubtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Champ Email
                  AppTextField(
                    label: AppLocalizations.of(context)!.email,
                    hint: AppLocalizations.of(context)!.emailHint,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enterEmailError;
                      }
                      if (!value.contains('@')) {
                        return AppLocalizations.of(context)!.invalidEmailError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Champ Mot de passe
                  AppTextField(
                    label: AppLocalizations.of(context)!.password,
                    hint: '********',
                    controller: _passwordController,
                    isPassword: !_isPasswordVisible,
                    prefixIcon: Icons.lock_outline,
                    suffix: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () => setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      }),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enterPasswordError;
                      }
                      if (value.length < 6) {
                        return AppLocalizations.of(
                          context,
                        )!.passwordLengthError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Lien Mot de passe oublié
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.push(RouteConstants.forgotPassword);
                      },
                      child: Text(AppLocalizations.of(context)!.forgotPassword),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Boutons d'action : Connexion standard et Biométrique
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          AppButton(
                            text: AppLocalizations.of(context)!.loginAction,
                            isLoading: state.status == AuthStatus.loading,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  AuthLoginRequested(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<SettingsBloc, SettingsState>(
                            builder: (context, settingsState) {
                              return BlocBuilder<SystemBloc, SystemState>(
                                builder: (context, systemState) {
                                  final flags = systemState.featureFlags;
                                  // Affiche l'option biométrique si activée dans les paramètres ET via feature flag
                                  if (settingsState.biometricsEnabled &&
                                      flags.authBiometric.isEnabled) {
                                    return OutlinedButton(
                                      // Aucune vérification biométrique séparée ici (audit
                                      // F-01) : la vérification a lieu au moment du
                                      // déchiffrement du token dans BiometricGatedStorage
                                      // (Keystore/Keychain), déclenché par le bloc — c'est
                                      // le SEUL geste biométrique, il ne peut pas être
                                      // contourné en interceptant un simple booléen Dart.
                                      onPressed: () {
                                        getIt<TelemetryService>().recordEvent(
                                          'auth.biometric',
                                          {'result': 'attempted'},
                                        );
                                        context.read<AuthBloc>().add(
                                          AuthBiometricLoginRequested(),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        minimumSize: const Size(
                                          double.infinity,
                                          56,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        side: BorderSide(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.fingerprint,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.biometricLogin,
                                            style: AppTextStyles.bodyLarge
                                                .copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          AppLocalizations.of(context)!.orContinueWith,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  BlocBuilder<SystemBloc, SystemState>(
                    builder: (context, systemState) {
                      final flags = systemState.featureFlags;
                      return Column(
                        children: [
                          if (flags.authGoogle.isEnabled) ...[
                            // Connexion Google
                            OutlinedButton(
                              onPressed: () {
                                getIt<AnalyticsManager>().trackEvent(
                                  feature: 'Auth',
                                  action: 'social_login_attempt',
                                  details: {'provider': 'google'},
                                );
                                context.read<AuthBloc>().add(
                                  const AuthGoogleSignInRequested(),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const GoogleLogo(size: 22),
                                  const SizedBox(width: 12),
                                  Text(
                                    AppLocalizations.of(context)!.googleSignIn,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Connexion Apple (iOS uniquement)
                          if (Platform.isIOS && flags.authApple.isEnabled) ...[
                            OutlinedButton(
                              onPressed: () {
                                getIt<AnalyticsManager>().trackEvent(
                                  feature: 'Auth',
                                  action: 'social_login_attempt',
                                  details: {'provider': 'apple'},
                                );
                                context.read<AuthBloc>().add(
                                  const AuthAppleSignInRequested(),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.onSurface,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppleLogo(
                                    size: 22,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    AppLocalizations.of(context)!.appleSignIn,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Connexion par Téléphone
                          if (flags.authPhone.isEnabled)
                            OutlinedButton(
                              onPressed: () {
                                context.push(RouteConstants.phoneLogin);
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.phone_android_outlined,
                                    color: AppColors.success.withValues(
                                      alpha: 1.0,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    AppLocalizations.of(context)!.phoneLogin,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Lien vers l'inscription
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.noAccountQuestion),
                      TextButton(
                        onPressed: () => context.push(RouteConstants.register),
                        child: Text(
                          AppLocalizations.of(context)!.register,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
