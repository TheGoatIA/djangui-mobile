import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../di/injection.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/log_service.dart';
import '../../../../core/mixins/secure_screen_mixin.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage>
    with WidgetsBindingObserver, SecureScreenMixin<SecurityPage> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  List<BiometricType>? _availableBiometrics;
  bool _isPasswordProvider = false;
  bool _isLoadingProvider = true;

  @override
  void initState() {
    super.initState();
    getIt<LogService>().info(
      'Affichage de la page de sécurité.',
      component: 'SecurityPage',
    );
    _checkBiometrics();
    _checkLoginProvider();
  }

  Future<void> _checkLoginProvider() async {
    final provider = await getIt<AuthRepository>().getLoginProvider();
    if (mounted) {
      setState(() {
        _isPasswordProvider = provider == 'password' || provider == null;
        _isLoadingProvider = false;
      });
    }
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      canCheckBiometrics = false;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });

    if (canCheckBiometrics) {
      try {
        final availableBiometrics = await auth.getAvailableBiometrics();
        if (!mounted) return;
        setState(() {
          _availableBiometrics = availableBiometrics;
        });
      } catch (e) {
        // Handle error
      }
    }
  }

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.deleteAccount,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
        content: Text(AppLocalizations.of(context)!.deleteAccountDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              getIt<LogService>().info(
                'Action: Suppression de compte confirmée',
                component: 'SecurityPage',
              );
              context.read<AuthBloc>().add(AuthDeleteAccountRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text(l10n.security)),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? l10n.genericError),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          } else if (state.status == AuthStatus.biometricCredentialsSaved) {
            // Success! Now actually enable it in settings
            context.read<SettingsBloc>().add(const ToggleBiometrics(true));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.operationSuccess),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(l10n.securitySettings),
              const SizedBox(height: 12),
              if (!_isLoadingProvider && _isPasswordProvider) ...[
                _buildSecurityTile(
                  icon: Icons.lock_outline,
                  title: l10n.changePassword,
                  onTap: () => context.push(RouteConstants.changePassword),
                ),
                const Divider(height: 1, color: Colors.transparent),
              ],
              _buildSecurityTile(
                icon: Icons.devices_outlined,
                title: l10n.activeSessions,
                onTap: () => context.push(RouteConstants.sessions),
              ),
              const SizedBox(height: 32),
              _buildSectionTitle(l10n.biometrics),
              const SizedBox(height: 12),
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  return SwitchListTile(
                    secondary: Icon(
                      _getBiometricIcon(),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(l10n.enableBiometrics),
                    subtitle: Text(l10n.biometricsDescription),
                    value: state.biometricsEnabled,
                    onChanged:
                        (_canCheckBiometrics &&
                            (_availableBiometrics?.isNotEmpty ?? false))
                        ? (value) async {
                            if (value) {
                              // If enabling, check if we already have a biometric token
                              final repo = getIt<AuthRepository>();
                              final biometricToken = await repo
                                  .getBiometricToken();
                              final provider = await repo.getLoginProvider();

                              if (!context.mounted) return;

                              if (biometricToken == null &&
                                  provider == 'password') {
                                _showPasswordDialog(context);
                              } else if (biometricToken == null &&
                                  provider != null &&
                                  provider != 'password') {
                                // For social logins, just save the token
                                context.read<AuthBloc>().add(
                                  AuthSetupBiometricsSocialRequested(),
                                );
                              } else {
                                context.read<SettingsBloc>().add(
                                  ToggleBiometrics(value),
                                );
                              }
                            } else {
                              context.read<SettingsBloc>().add(
                                ToggleBiometrics(value),
                              );
                            }
                          }
                        : (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enroll biometrics in your device settings first.',
                                ),
                              ),
                            );
                          },
                    activeThumbColor: Theme.of(context).colorScheme.primary,
                  );
                },
              ),
              const SizedBox(height: 48),
              _buildDangerZone(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: AppTextStyles.bodySmall.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSecurityTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: AppTextStyles.bodyLarge),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildDangerZone(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(l10n.dangerZone),
        const SizedBox(height: 12),
        Card(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 0.5,
            ),
          ),
          child: ListTile(
            leading: Icon(
              Icons.delete_forever_outlined,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              l10n.deleteAccount,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(l10n.deleteAccountWarning),
            onTap: _showDeleteAccountConfirmation,
          ),
        ),
      ],
    );
  }

  IconData _getBiometricIcon() {
    if (_availableBiometrics?.contains(BiometricType.face) ?? false) {
      return Icons.face;
    }
    return Icons.fingerprint;
  }

  void _showPasswordDialog(BuildContext context) {
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.biometricCredentialsSaved) {
            Navigator.pop(dialogContext);
            context.read<SettingsBloc>().add(const ToggleBiometrics(true));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Biometrics enabled successfully')),
            );
          }
        },
        builder: (context, state) {
          return AlertDialog(
            title: const Text('Confirm Password'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Please enter your password to enable biometric login.',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  if (state.status == AuthStatus.error) ...[
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage ?? 'Error verifying password',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: state.status == AuthStatus.loading
                    ? null
                    : () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: state.status == AuthStatus.loading
                    ? null
                    : () {
                        if (formKey.currentState?.validate() ?? false) {
                          final email = state.authResponse?.user.email ?? '';
                          context.read<AuthBloc>().add(
                            AuthSaveBiometricCredentialsRequested(
                              email: email,
                              password: passwordController.text,
                            ),
                          );
                        }
                      },
                child: state.status == AuthStatus.loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Confirm'),
              ),
            ],
          );
        },
      ),
    );
  }
}
