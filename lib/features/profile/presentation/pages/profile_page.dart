import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../../gamification/presentation/widgets/badges_list.dart';
import '../../../../core/constants/route_constants.dart';
import 'package:go_router/go_router.dart';

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
                const SizedBox(height: 24),
                if (user != null && user.badges.isNotEmpty) ...[
                  BadgesList(
                    badgeIds: user.badges.map((e) => e.toString()).toList(),
                  ),
                  const SizedBox(height: 24),
                ],
                if (user != null && !user.isPremium) ...[
                  _buildPremiumBanner(context),
                  const SizedBox(height: 24),
                ],
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
            color: Colors.black.withValues(alpha: 0.05),
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
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return _buildSettingsTile(
                Icons.language_outlined,
                AppLocalizations.of(context)!.language,
                trailing: Text(
                  state.locale.languageCode == 'fr' ? 'Français' : 'English',
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () =>
                    _showLanguageSelectionDialog(context, state.locale),
              );
            },
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            Icons.phone_android_outlined,
            AppLocalizations.of(context)!.phoneNumber,
            trailing: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final phone = state.authResponse?.user.phoneNumber;
                return Text(
                  phone ?? '',
                  style: const TextStyle(color: Colors.grey),
                );
              },
            ),
            onTap: () {
              final authState = context.read<AuthBloc>().state;
              if (authState.authResponse?.user.phoneNumber == null) {
                context.push(RouteConstants.phoneLogin);
              }
            },
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
            onTap: () => context.push(RouteConstants.about),
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
          color: AppColors.primary.withValues(alpha: 0.1),
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
              ThemeMode.light,
              currentMode,
              AppLocalizations.of(context)!.lightTheme,
              (value) {
                context.read<SettingsBloc>().add(ThemeChanged(value!));
                Navigator.pop(dialogContext);
              },
            ),
            _buildThemeOption(
              context,
              ThemeMode.dark,
              currentMode,
              AppLocalizations.of(context)!.darkTheme,
              (value) {
                context.read<SettingsBloc>().add(ThemeChanged(value!));
                Navigator.pop(dialogContext);
              },
            ),
            _buildThemeOption(
              context,
              ThemeMode.system,
              currentMode,
              AppLocalizations.of(context)!.systemTheme,
              (value) {
                context.read<SettingsBloc>().add(ThemeChanged(value!));
                Navigator.pop(dialogContext);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF8E44AD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.white, size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Passez au Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Débloquez l\'IA et les rapports avancés',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push(RouteConstants.subscription),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Découvrir les offres'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeMode mode,
    ThemeMode groupValue,
    String label,
    ValueChanged<ThemeMode?> onChanged,
  ) {
    final isSelected = mode == groupValue;
    return ListTile(
      title: Text(label),
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected ? AppColors.primary : Colors.grey,
      ),
      onTap: () => onChanged(mode),
    );
  }

  void _showLanguageSelectionDialog(
    BuildContext context,
    Locale currentLocale,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(
              context,
              'Français',
              'fr',
              currentLocale.languageCode,
              (value) {
                context.read<SettingsBloc>().add(LocaleChanged(Locale(value)));
                Navigator.pop(dialogContext);
              },
            ),
            _buildLanguageOption(
              context,
              'English',
              'en',
              currentLocale.languageCode,
              (value) {
                context.read<SettingsBloc>().add(LocaleChanged(Locale(value)));
                Navigator.pop(dialogContext);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String label,
    String value,
    String groupValue,
    ValueChanged<String> onChanged,
  ) {
    final isSelected = value == groupValue;
    return ListTile(
      title: Text(label),
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected ? AppColors.primary : Colors.grey,
      ),
      onTap: () => onChanged(value),
    );
  }
}
