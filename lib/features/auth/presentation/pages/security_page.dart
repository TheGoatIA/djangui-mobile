import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  List<BiometricType>? _availableBiometrics;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
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
          style: const TextStyle(color: AppColors.error),
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
              context.read<AuthBloc>().add(AuthDeleteAccountRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
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
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.security)),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? l10n.genericError),
                backgroundColor: AppColors.error,
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
              _buildSecurityTile(
                icon: Icons.lock_outline,
                title: l10n.changePassword,
                onTap: () => context.push(RouteConstants.changePassword),
              ),
              const Divider(height: 1),
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
                      color: AppColors.primary,
                    ),
                    title: Text(l10n.enableBiometrics),
                    subtitle: Text(l10n.biometricsDescription),
                    value: state.biometricsEnabled,
                    onChanged:
                        (_canCheckBiometrics &&
                            (_availableBiometrics?.isNotEmpty ?? false))
                        ? (value) {
                            context.read<SettingsBloc>().add(
                              ToggleBiometrics(value),
                            );
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
                    activeThumbColor: AppColors.primary,
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
        color: AppColors.textSecondary,
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
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyLarge),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
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
          color: AppColors.error.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.error, width: 0.5),
          ),
          child: ListTile(
            leading: const Icon(
              Icons.delete_forever_outlined,
              color: AppColors.error,
            ),
            title: Text(
              l10n.deleteAccount,
              style: const TextStyle(
                color: AppColors.error,
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
}
