import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import '../../../../di/injection.dart';
import '../../../../features/system/presentation/bloc/system_bloc.dart';

/// Page d'inscription de l'application.
///
/// Permet à un nouvel utilisateur de créer un compte en renseignant son nom,
/// prénom, email, mot de passe et pays de résidence.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  /// Clé globale pour la validation du formulaire d'inscription.
  final _formKey = GlobalKey<FormState>();

  /// Contrôleurs pour les différents champs du formulaire.
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  /// États locaux pour la visibilité des mots de passe.
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  /// Code pays sélectionné par l'utilisateur.
  String? _selectedCountry;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Redirection vers le dashboard après inscription réussie
        if (state.status == AuthStatus.authenticated) {
          getIt<AnalyticsManager>().trackEvent(
            feature: 'Auth',
            action: 'register_success',
            details: {'country': state.authResponse?.user.country},
          );

          final user = state.authResponse?.user;
          // Check if email is verified (skip for phone auth which might not have email verified but is phone verified)
          // Since this is RegisterPage, it's email/password registration.
          if (user != null && !user.isEmailVerified) {
            // Dispatch event to logout locally so user has to login again after verification?
            // Or just show the page. The user said "return press login button".
            // So we should probably not keep them logged in?
            // But the backend returns a token.
            // If we just go to the page, they are technically authenticated in the app state.
            // If they kill the app and restart, `AuthCheckRequested` will see they are authenticated.
            // Does `AuthCheckRequested` check email verification?
            // Currently not.

            // The prompt says: "invite a verifier son adresse mail et de revenir appuyer sur le bouton de login pour s eloguer"
            // This implies they should be logged out or at least redirected to login eventually.
            // On `EmailVerificationPendingPage`, I put a "Back to Login" button which does `context.go(RouteConstants.login)`.
            // But if they are still authenticated in `AuthBloc`, going to login might redirect them back to dashboard if there is a listener there?
            // Actually `LoginPage` usually redirects to dashboard if authenticated.

            // So I should probably logout the user or not persist the session?
            // Or maybe just show the pending page.
            context.go(RouteConstants.emailVerificationPending);
          } else {
            context.go(RouteConstants.dashboard);
          }
        }
        // Affichage d'un message d'erreur en cas d'échec
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
                  const SizedBox(height: 20),
                  // Bouton de retour vers la page de connexion
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.createAccount,
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.registerSubtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Champs Nom et Prénom sur la même ligne
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: AppLocalizations.of(context)!.firstName,
                          hint: AppLocalizations.of(context)!.firstNameHint,
                          controller: _firstNameController,
                          validator: (value) => value?.isEmpty ?? true
                              ? AppLocalizations.of(context)!.requiredField
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppTextField(
                          label: AppLocalizations.of(context)!.lastName,
                          hint: AppLocalizations.of(context)!.lastNameHint,
                          controller: _lastNameController,
                          validator: (value) => value?.isEmpty ?? true
                              ? AppLocalizations.of(context)!.requiredField
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

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

                  // Champ Mot de passe avec bouton de visibilité
                  AppTextField(
                    label: AppLocalizations.of(context)!.password,
                    hint: '••••••••',
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
                  const SizedBox(height: 24),

                  // Confirmation du mot de passe
                  AppTextField(
                    label: AppLocalizations.of(context)!.confirmPassword,
                    hint: '••••••••',
                    controller: _confirmPasswordController,
                    isPassword: !_isConfirmPasswordVisible,
                    prefixIcon: Icons.lock_outline,
                    suffix: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () => setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      }),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.requiredField;
                      }
                      if (value != _passwordController.text) {
                        return AppLocalizations.of(
                          context,
                        )!.passwordsDoNotMatch;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Sélection du pays via un menu déroulant branché sur le SystemBloc
                  BlocBuilder<SystemBloc, SystemState>(
                    builder: (context, systemState) {
                      var items = <DropdownMenuItem<String>>[];

                      if (systemState.countries.isNotEmpty) {
                        items = systemState.countries.map((country) {
                          return DropdownMenuItem(
                            value: country.code,
                            child: Text(country.name),
                          );
                        }).toList();
                      }

                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText:
                              '${AppLocalizations.of(context)!.country} (${AppLocalizations.of(context)!.optional})',
                          hintText: AppLocalizations.of(context)!.selectCountry,
                          prefixIcon: const Icon(Icons.public),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: items,
                        onChanged: (value) {
                          setState(() {
                            _selectedCountry = value;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Bouton d'inscription final
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AppButton(
                        text: AppLocalizations.of(context)!.register,
                        isLoading: state.status == AuthStatus.loading,
                        onPressed: () {
                          debugPrint(
                            '📝 [RegisterPage] Pays sélectionné : $_selectedCountry',
                          );
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              AuthRegisterRequested(
                                email: _emailController.text,
                                password: _passwordController.text,
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                country: _selectedCountry,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Lien de retour vers la connexion
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.alreadyHaveAccountQuestion,
                      ),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          AppLocalizations.of(context)!.loginAction,
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
