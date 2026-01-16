import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../../gamification/presentation/widgets/badges_list.dart';
import '../../../../core/constants/route_constants.dart';
import 'package:go_router/go_router.dart';
import '../../../../di/injection.dart';
// import '../../../../core/services/sms_service.dart';
// import '../../../insights/data/datasources/ai_remote_datasource.dart';
// import '../../../transactions/data/models/transaction_model.dart';
// import '../../../transactions/presentation/bloc/transactions_bloc.dart';
// import 'package:uuid/uuid.dart';
// import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../auth/data/models/user_model.dart';
import 'package:kauri/features/upload/domain/repositories/upload_repository.dart';
import 'package:kauri/features/system/presentation/bloc/system_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/services/tutorial_service.dart';
import 'package:showcaseview/showcaseview.dart';
// import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // bool _isLoadingSms = false;
  final GlobalKey _resetTutorialsKey = GlobalKey();
  final ImagePicker _picker = ImagePicker();
  final GlobalKey _profileHeaderKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();
  final GlobalKey _premiumKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.watch<TutorialService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (!tutorialService.hasSeenTutorial('profile')) {
      try {
        final shell = StatefulNavigationShell.of(context);
        if (shell.currentIndex != 4) return;
      } catch (_) {
        if (ModalRoute.of(context)?.isCurrent != true) return;
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        ShowCaseWidget.of(
          context,
        ).startShowCase([_profileHeaderKey, _settingsKey, _premiumKey]);
        tutorialService.markTutorialAsSeen('profile');
      });
    }
  }

  @override
  void dispose() {
    try {
      ShowCaseWidget.of(context).dismiss();
    } catch (_) {}
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 500,
    );

    if (image != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.uploadingImage),
            duration: const Duration(seconds: 1),
          ),
        );

        final uploadRepo = getIt<UploadRepository>();
        final result = await uploadRepo.uploadAvatar(image.path);

        result.fold(
          (failure) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(failure.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          (response) {
            if (mounted) {
              context.read<AuthBloc>().add(AuthRefreshUserRequested());
            }
          },
        );
      }
    }
  }

  void _showEditProfileDialog(BuildContext context) {
    final user = context.read<AuthBloc>().state.authResponse?.user;
    if (user == null) return;

    final firstNameController = TextEditingController(text: user.firstName);
    final lastNameController = TextEditingController(text: user.lastName);
    final incomeController = TextEditingController(
      text: user.monthlyIncome?.toStringAsFixed(0) ?? '',
    );
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
              const SizedBox(height: 16),
              TextFormField(
                controller: incomeController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.monthlyIncome,
                  suffixText: 'FCFA',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      double.tryParse(value) == null) {
                    return AppLocalizations.of(context)!.invalidAmount;
                  }
                  return null;
                },
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
                    monthlyIncome: incomeController.text.isNotEmpty
                        ? double.tryParse(incomeController.text)
                        : null,
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
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          } else if (state.status == AuthStatus.countryChangeRequestSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      AppLocalizations.of(
                        context,
                      )!.countryChangeRequestSubmitted,
                ),
                backgroundColor: AppColors.success,
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
              RefreshIndicator(
                onRefresh: () async {
                  context.read<AuthBloc>().add(AuthRefreshUserRequested());
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Showcase(
                        key: _profileHeaderKey,
                        title: AppLocalizations.of(
                          context,
                        )!.tutorialProfileTitle,
                        description: AppLocalizations.of(
                          context,
                        )!.tutorialProfileDesc,
                        child: _buildProfileHeader(
                          context,
                          name,
                          user?.email ?? '',
                          user?.avatar,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (user != null && user.badges.isNotEmpty) ...[
                        BadgesList(
                          badgeIds: user.badges
                              .map((e) => e.toString())
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                      ],
                      if (user != null && !user.isPremium) ...[
                        Showcase(
                          key: _premiumKey,
                          title: AppLocalizations.of(
                            context,
                          )!.tutorialSubscriptionTitle,
                          description: AppLocalizations.of(
                            context,
                          )!.tutorialSubscriptionDesc,
                          child: _buildPremiumBanner(context),
                        ),
                        const SizedBox(height: 24),
                      ] else if (user != null && user.isPremium) ...[
                        Showcase(
                          key: _premiumKey,
                          title: AppLocalizations.of(
                            context,
                          )!.tutorialSubscriptionTitle,
                          description: AppLocalizations.of(
                            context,
                          )!.tutorialSubscriptionDesc,
                          child: _buildPremiumStatusCard(context, user),
                        ),
                        const SizedBox(height: 24),
                      ],
                      Showcase(
                        key: _settingsKey,
                        title: AppLocalizations.of(context)!.settings,
                        description: AppLocalizations.of(
                          context,
                        )!.tutorialProfileDesc, // Reuse or find better
                        child: _buildSettingsSection(context),
                      ),
                      const SizedBox(height: 32),
                      _buildLogoutButton(context),
                    ],
                  ),
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
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                    ? (avatarUrl.startsWith('http')
                              ? NetworkImage(avatarUrl)
                              : (avatarUrl.startsWith('/')
                                    ? NetworkImage(
                                        '${dotenv.env['API_BASE_URL']?.replaceAll('/api/v1', '') ?? ''}$avatarUrl',
                                      )
                                    : MemoryImage(base64Decode(avatarUrl))))
                          as ImageProvider
                    : null,
                child: (avatarUrl == null || avatarUrl.isEmpty)
                    ? Icon(
                        Icons.person,
                        size: 50,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
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
                  child: Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
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
            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
            onTap: () => context.push(RouteConstants.notifications),
          ),
          const Divider(height: 1, color: Colors.transparent),
          /*
          _buildSettingsTile(
            Icons.sms_outlined,
            AppLocalizations.of(context)!.importSms,
            onTap: _isLoadingSms ? null : () => _handleSmsImport(context),
          ),
          const Divider(height: 1, color: Colors.transparent),
          */
          _buildSettingsTile(
            Icons.security_outlined,
            AppLocalizations.of(context)!.security,
            onTap: () => context.push(RouteConstants.security),
          ),
          const Divider(height: 1, color: Colors.transparent),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return _buildSettingsTile(
                Icons.language_outlined,
                AppLocalizations.of(context)!.language,
                trailing: Text(
                  state.locale.languageCode == 'fr' ? 'Français' : 'English',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                onTap: () =>
                    _showLanguageSelectionDialog(context, state.locale),
              );
            },
          ),
          const Divider(height: 1, color: Colors.transparent),
          _buildSettingsTile(
            Icons.phone_android_outlined,
            AppLocalizations.of(context)!.phoneNumber,
            trailing: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final phone = state.authResponse?.user.phone;
                return Text(
                  phone ?? '',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
          const Divider(height: 1, color: Colors.transparent),
          _buildSettingsTile(
            Icons.public_outlined,
            AppLocalizations.of(context)!.countryLabel,
            trailing: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final country = state.authResponse?.user.country;
                return Text(
                  country ?? AppLocalizations.of(context)!.notSet,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
          const Divider(height: 1, color: Colors.transparent),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return _buildSettingsTile(
                Icons.brightness_6_outlined,
                AppLocalizations.of(context)!.theme,
                trailing: Text(
                  _getThemeName(context, state.themeMode),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                onTap: () =>
                    _showThemeSelectionDialog(context, state.themeMode),
              );
            },
          ),
          const Divider(height: 1, color: Colors.transparent),
          Showcase(
            key: _resetTutorialsKey,
            title: AppLocalizations.of(context)!.resetTutorials,
            description: AppLocalizations.of(
              context,
            )!.resetTutorialsDesc, // Assuming this exists or using resetTutorials
            child: _buildSettingsTile(
              Icons.restart_alt_outlined,
              AppLocalizations.of(context)!.resetTutorials,
              onTap: () => _resetTutorials(context),
            ),
          ),
          const Divider(height: 1, color: Colors.transparent),
          _buildSettingsTile(
            Icons.help_outline,
            AppLocalizations.of(context)!.helpSupport,
            onTap: () => context.push(RouteConstants.supportTickets),
          ),
          const Divider(height: 1, color: Colors.transparent),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.legalSection,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<SystemBloc, SystemState>(
            builder: (context, state) {
              return Column(
                children: [
                  _buildSettingsTile(
                    Icons.description_outlined,
                    AppLocalizations.of(context)!.termsOfService,
                    onTap: () async {
                      final url = state.settings?.termsOfServiceUrl;
                      if (url != null) {
                        await launchUrl(Uri.parse(url));
                      }
                    },
                  ),
                  const Divider(height: 1, color: Colors.transparent),
                  _buildSettingsTile(
                    Icons.privacy_tip_outlined,
                    AppLocalizations.of(context)!.privacyPolicy,
                    onTap: () async {
                      final url = state.settings?.privacyPolicyUrl;
                      if (url != null) {
                        await launchUrl(Uri.parse(url));
                      }
                    },
                  ),
                  const Divider(height: 1, color: Colors.transparent),
                  _buildSettingsTile(
                    Icons.info_outline,
                    AppLocalizations.of(context)!.aboutApp,
                    onTap: () => _showAboutDialog(context),
                  ),
                ],
              );
            },
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
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(title, style: AppTextStyles.bodyMedium),
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
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
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
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
            side: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.logout,
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _resetTutorials(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.resetTutorials),
        content: Text(AppLocalizations.of(context)!.resetTutorialsConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              AppLocalizations.of(context)!.confirm,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final tutorialService = getIt<TutorialService>();
      await tutorialService.resetAllTutorials();
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.resetTutorialsSuccess),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _showAboutDialog(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (!context.mounted) return;

    showAboutDialog(
      context: context,
      applicationName: packageInfo.appName,
      applicationVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset('assets/images/logo.png', width: 60, height: 60),
      ),
      applicationLegalese: '© 2026 Kauri Team',
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
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            const Color(0xFF8E44AD),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
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
                foregroundColor: Theme.of(context).colorScheme.primary,
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

  Widget _buildPremiumStatusCard(BuildContext context, UserModel user) {
    final endDate = user.subscription?.endDate;
    final locale = Localizations.localeOf(context).languageCode;
    final dateFormat = DateFormat('dd MMMM yyyy', locale);
    final formattedDate = endDate != null
        ? dateFormat.format(endDate)
        : AppLocalizations.of(context)!.unknownRenewalDate;

    return GestureDetector(
      onTap: () => context.push(RouteConstants.subscription),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          ),
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFFFD700),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.premiumMember,
                        style: AppTextStyles.h3.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.subscription?.status == 'cancelled'
                            ? AppLocalizations.of(
                                context,
                              )!.subscriptionCancelled
                            : (endDate != null
                                  ? AppLocalizations.of(
                                      context,
                                    )!.expiresOn(formattedDate)
                                  : AppLocalizations.of(
                                      context,
                                    )!.activeSubscription),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: user.subscription?.status == 'cancelled'
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ],
        ),
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
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
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
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
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
                  return _buildCountryOption(
                    context,
                    country.name,
                    country.code,
                    currentCountry,
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCountryOption(
    BuildContext dialogContext,
    String label,
    String code,
    String currentCode,
  ) {
    // ... (previous implementation)
    final isSelected = code == currentCode;
    return ListTile(
      title: Text(label),
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected
            ? Theme.of(dialogContext).colorScheme.primary
            : Theme.of(dialogContext).colorScheme.onSurfaceVariant,
      ),
      onTap: () async {
        if (isSelected) {
          Navigator.pop(dialogContext);
          return;
        }

        Navigator.pop(dialogContext); // Close selection dialog first

        if (!mounted) return;

        // Show confirmation dialog logic
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (confirmContext) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.confirmCountryChange),
            content: Text(AppLocalizations.of(context)!.countryChangeWarning),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(confirmContext, false),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(confirmContext, true),
                child: Text(AppLocalizations.of(context)!.confirm),
              ),
            ],
          ),
        );

        if (confirmed == true && mounted) {
          context.read<AuthBloc>().add(AuthRequestCountryChange(code));
        }
      },
    );
  }

  /*
  Future<void> _handleSmsImport(BuildContext context) async {
    // ... (logic)
  }
  */
}
