import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../bloc/auth_bloc.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import '../../../../di/injection.dart';
import '../../../../features/system/presentation/bloc/system_bloc.dart';

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
          context.go(RouteConstants.dashboard);
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
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
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
                              // Affiche l'option biométrique si activée dans les paramètres
                              if (settingsState.biometricsEnabled) {
                                return OutlinedButton(
                                  onPressed: () async {
                                    final localAuth = LocalAuthentication();
                                    final authBloc = context.read<AuthBloc>();
                                    try {
                                      final didAuthenticate = await localAuth
                                          .authenticate(
                                            localizedReason:
                                                'Veuillez vous authentifier pour vous connecter',
                                          );
                                      if (didAuthenticate) {
                                        getIt<AnalyticsManager>().trackEvent(
                                          feature: 'Auth',
                                          action: 'login_success',
                                          details: {'provider': 'biometric'},
                                        );
                                        authBloc.add(
                                          AuthBiometricLoginRequested(),
                                        );
                                      }
                                    } on PlatformException catch (e) {
                                      String message =
                                          'Erreur d\'authentification';
                                      if (e.code == 'noCredentialsSet' ||
                                          e.code == 'NotEnrolled') {
                                        message =
                                            'Aucune biométrie configurée sur cet appareil.';
                                      } else if (e.code == 'NotAvailable') {
                                        message =
                                            'L\'authentification biométrique n\'est pas disponible.';
                                      }
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(message)),
                                      );
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Une erreur inattendue est survenue',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(
                                      double.infinity,
                                      56,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    side: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.fingerprint,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Connexion par biométrie',
                                        style: AppTextStyles.bodyLarge.copyWith(
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

                  // Connexion Google
                  OutlinedButton(
                    onPressed: () {
                      _showSocialCountryDialog(
                        context,
                        (countryCode) =>
                            AuthGoogleSignInRequested(countryCode: countryCode),
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
                        const Icon(
                          Icons.g_mobiledata,
                          color: AppColors.info,
                          size: 28,
                        ),
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

                  // Connexion Apple (iOS uniquement)
                  if (Platform.isIOS) ...[
                    OutlinedButton(
                      onPressed: () {
                        _showSocialCountryDialog(
                          context,
                          (countryCode) => AuthAppleSignInRequested(
                            countryCode: countryCode,
                          ),
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
                          Icon(
                            Icons.apple,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 28,
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
                          color: AppColors.success.withValues(alpha: 1.0),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppLocalizations.of(context)!.phoneLogin,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
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

  /// Affiche une boîte de dialogue pour sélectionner un pays avant une connexion sociale.
  ///
  /// Ceci est nécessaire pour configurer les paramètres régionaux de l'utilisateur
  /// lors de sa première inscription via Google ou Apple.
  void _showSocialCountryDialog(
    BuildContext context,
    AuthEvent Function(String countryCode) createEvent,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectCountry),
        content: BlocBuilder<SystemBloc, SystemState>(
          builder: (context, state) {
            if (state.countries.isEmpty) {
              return const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: state.countries.where((c) => c.isActive).map((
                  country,
                ) {
                  return ListTile(
                    title: Text(country.name),
                    onTap: () {
                      getIt<AnalyticsManager>().trackEvent(
                        feature: 'Auth',
                        action: 'social_login_attempt',
                        details: {
                          'provider': createEvent is AuthGoogleSignInRequested
                              ? 'google'
                              : 'apple',
                        },
                      );
                      Navigator.pop(dialogContext);
                      context.read<AuthBloc>().add(createEvent(country.code));
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
