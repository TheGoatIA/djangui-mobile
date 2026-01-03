import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/settings/presentation/bloc/settings_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // Edit profile action
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state.authResponse?.user;
          final name = user != null
              ? '${user.firstName} ${user.lastName}'
              : 'Utilisateur';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildProfileHeader(name, user?.email ?? ''),
                const SizedBox(height: 32),
                _buildSettingsSection(context),
                const SizedBox(height: 32),
                _buildLogoutButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(String name, String email) {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(name, style: AppTextStyles.h3),
        Text(
          email,
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            Icons.notifications_outlined,
            AppLocalizations.of(context)!.notifications,
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            Icons.security_outlined,
            AppLocalizations.of(context)!.security,
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            Icons.language_outlined,
            AppLocalizations.of(context)!.language,
            trailing: const Text(
              'Français',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {},
          ),
          const Divider(height: 1),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return _buildSettingsTile(
                Icons.brightness_6_outlined,
                AppLocalizations.of(context)!.theme,
                trailing: Text(
                  _getThemeName(context, state.themeMode),
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () =>
                    _showThemeSelectionDialog(context, state.themeMode),
              );
            },
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            Icons.help_outline,
            AppLocalizations.of(context)!.helpSupport,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: AppTextStyles.bodyMedium),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.logout),
              content: Text(AppLocalizations.of(context)!.confirmLogout),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                  },
                  child: const Text(
                    'Déconnexion',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.red),
          ),
        ),
        child: const Text(
          'Se déconnecter',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String _getThemeName(BuildContext context, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return AppLocalizations.of(context)!.lightTheme;
      case ThemeMode.dark:
        return AppLocalizations.of(context)!.darkTheme;
      case ThemeMode.system:
        return AppLocalizations.of(context)!.systemTheme;
    }
  }

  void _showThemeSelectionDialog(BuildContext context, ThemeMode currentMode) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(
              context,
              dialogContext,
              ThemeMode.light,
              AppLocalizations.of(context)!.lightTheme,
              currentMode,
            ),
            _buildThemeOption(
              context,
              dialogContext,
              ThemeMode.dark,
              AppLocalizations.of(context)!.darkTheme,
              currentMode,
            ),
            _buildThemeOption(
              context,
              dialogContext,
              ThemeMode.system,
              AppLocalizations.of(context)!.systemTheme,
              currentMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    BuildContext dialogContext,
    ThemeMode mode,
    String label,
    ThemeMode currentMode,
  ) {
    return RadioListTile<ThemeMode>(
      title: Text(label),
      value: mode,
      groupValue: currentMode,
      onChanged: (value) {
        if (value != null) {
          context.read<SettingsBloc>().add(ThemeChanged(value));
          Navigator.pop(dialogContext);
        }
      },
      activeColor: AppColors.primary,
    );
  }
}
