import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../../gamification/presentation/widgets/badges_list.dart';
import '../../../../core/constants/route_constants.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 500,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      if (mounted) {
        context.read<AuthBloc>().add(
          AuthUpdateProfileRequested(avatar: base64Image),
        );
      }
    }
  }

  void _showEditProfileDialog(BuildContext context) {
    final user = context.read<AuthBloc>().state.authResponse?.user;
    if (user == null) return;

    final firstNameController = TextEditingController(text: user.firstName);
    final lastNameController = TextEditingController(text: user.lastName);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.profile),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.firstName,
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? AppLocalizations.of(context)!.requiredField
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.lastName,
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? AppLocalizations.of(context)!.requiredField
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                  AuthUpdateProfileRequested(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                  ),
                );
                Navigator.pop(dialogContext);
              }
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditProfileDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      AppLocalizations.of(context)!.genericError,
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final user = state.authResponse?.user;
          final name = user != null
              ? '${user.firstName} ${user.lastName}'
              : AppLocalizations.of(context)!.user;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildProfileHeader(
                      context,
                      name,
                      user?.email ?? '',
                      user?.avatar,
                    ),
                    const SizedBox(height: 24),
                    if (user != null && user.badges.isNotEmpty) ...[
                      BadgesList(
                        badgeIds: user.badges.map((e) => e.toString()).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (user != null && user.role != 'premium') ...[
                      _buildPremiumBanner(context),
                      const SizedBox(height: 24),
                    ],
                    _buildSettingsSection(context),
                    const SizedBox(height: 32),
                    _buildLogoutButton(context),
                  ],
                ),
              ),
              if (state.status == AuthStatus.loading)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    String name,
    String email,
    String? avatarUrl,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary,
                backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                    ? (avatarUrl.startsWith('http')
                              ? NetworkImage(avatarUrl)
                              : MemoryImage(base64Decode(avatarUrl)))
                          as ImageProvider
                    : null,
                child: (avatarUrl == null || avatarUrl.isEmpty)
                    ? const Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
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
        ),
        const SizedBox(height: 16),
        Text(name, style: AppTextStyles.h3),
        Text(
          email,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
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
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
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
                final phone = state.authResponse?.user.phone;
                return Text(
                  phone ?? '',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
            onTap: () {
              final authState = context.read<AuthBloc>().state;
              if (authState.authResponse?.user.phone == null) {
                context.push(RouteConstants.phoneLogin);
              }
            },
          ),
          const Divider(height: 1),
          _buildSettingsTile(
            Icons.public_outlined,
            AppLocalizations.of(context)!.countryLabel,
            trailing: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final country = state.authResponse?.user.country;
                return Text(
                  country ?? AppLocalizations.of(context)!.notSet,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
            onTap: () {
              final country = context
                  .read<AuthBloc>()
                  .state
                  .authResponse
                  ?.user
                  .country;
              _showCountrySelectionDialog(context, country ?? 'CM');
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
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
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
      trailing:
          trailing ?? Icon(Icons.chevron_right, color: AppColors.textSecondary),
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
                  child: Text(
                    AppLocalizations.of(context)!.logout,
                    style: const TextStyle(color: AppColors.error),
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
            side: const BorderSide(color: AppColors.error),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.logout,
          style: const TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
          ),
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
                    Text(
                      AppLocalizations.of(context)!.upgradeToPremium,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.premiumBannerDescription,
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
              child: Text(AppLocalizations.of(context)!.discoverOffers),
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
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
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
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      onTap: () => onChanged(value),
    );
  }

  void _showCountrySelectionDialog(
    BuildContext context,
    String currentCountry,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectCountry),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCountryOption(
              context,
              AppLocalizations.of(context)!.cameroon,
              'CM',
              currentCountry,
            ),
            _buildCountryOption(
              context,
              AppLocalizations.of(context)!.france,
              'FR',
              currentCountry,
            ),
            _buildCountryOption(
              context,
              AppLocalizations.of(context)!.usa,
              'US',
              currentCountry,
            ),
            _buildCountryOption(
              context,
              AppLocalizations.of(context)!.belgium,
              'BE',
              currentCountry,
            ),
            _buildCountryOption(
              context,
              AppLocalizations.of(context)!.canada,
              'CA',
              currentCountry,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryOption(
    BuildContext context,
    String label,
    String code,
    String currentCode,
  ) {
    final isSelected = code == currentCode;
    return ListTile(
      title: Text(label),
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      onTap: () {
        context.read<AuthBloc>().add(AuthUpdateProfileRequested(country: code));
        Navigator.pop(context);
      },
    );
  }
}
