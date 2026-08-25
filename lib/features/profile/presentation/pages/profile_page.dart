import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:kauri/core/theme/app_theme_type.dart';
import '../../../../core/theme/app_colors.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/onboarding_page.dart';
import '../../../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../../gamification/presentation/widgets/badges_list.dart';
import '../../../../core/constants/route_constants.dart';
import 'package:go_router/go_router.dart';
import '../../../../di/injection.dart';
// import 'dart:io';
import 'package:kauri/core/config/env_config.dart';
import '../../../auth/data/models/user_model.dart';
import 'package:kauri/features/upload/domain/repositories/upload_repository.dart';
import 'package:kauri/features/system/presentation/bloc/system_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../notifications/presentation/bloc/notifications_bloc.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/widgets/tutorial/tutorial_step.dart';
// import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import '../../../../core/services/log_service.dart';
import '../../../../core/mixins/secure_screen_mixin.dart';

/// Page de profil de l'utilisateur regroupant ses informations et les paramètres de l'application.
///
/// Cette page permet :
/// - La modification des informations personnelles (nom, revenus).
/// - Le changement de la photo de profil (avatar).
/// - La gestion des préférences (langue, thème, notifications).
/// - L'accès aux sections légales et au support technique.
/// - La déconnexion.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with WidgetsBindingObserver, SecureScreenMixin<ProfilePage> {
  // Clés utilisées pour le tutoriel interactif guidant l'utilisateur sur son profil.
  final GlobalKey _resetTutorialsKey = GlobalKey();
  final ImagePicker _picker = ImagePicker();
  final GlobalKey _profileHeaderKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();
  final GlobalKey _premiumKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    getIt<LogService>().info(
      'Affichage de la page de profil.',
      component: 'ProfilePage',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Relance le tutoriel si le service de tutoriel est réinitialisé
    // (ex : bouton "Réinitialiser les tutoriels" plus bas sur cette page).
    context.watch<TutorialService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  /// Démarre le tutoriel si l'utilisateur ne l'a pas encore vu sur cet écran.
  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (tutorialService.hasSeenTutorial('profile')) return;
    try {
      final shell = StatefulNavigationShell.of(context);
      if (shell.currentIndex != 4) return;
    } catch (_) {
      if (ModalRoute.of(context)?.isCurrent != true) return;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final showPremiumStep = context
          .read<SystemBloc>()
          .state
          .featureFlags
          .featSubscriptions
          .isEnabled;
      final l10n = AppLocalizations.of(context)!;
      tutorialService.startTutorial(context, 'profile', [
        TutorialStep(
          targetKey: _profileHeaderKey,
          title: l10n.tutorialProfileTitle,
          description: l10n.tutorialProfileDesc,
        ),
        TutorialStep(
          targetKey: _settingsKey,
          title: l10n.tutorialSettingsSectionTitle,
          description: l10n.tutorialSettingsSectionDesc,
        ),
        if (showPremiumStep)
          TutorialStep(
            targetKey: _premiumKey,
            title: l10n.tutorialSubscriptionTitle,
            description: l10n.tutorialSubscriptionDesc,
          ),
        TutorialStep(
          targetKey: _resetTutorialsKey,
          title: l10n.resetTutorials,
          description: l10n.resetTutorialsDesc,
        ),
      ]);
    });
  }

  @override
  void dispose() {
    getIt<TutorialService>().cancelActiveTutorial(context);
    super.dispose();
  }

  /// Ouvre la galerie pour sélectionner et télécharger un nouvel avatar.
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 500,
    );

    if (image != null) {
      getIt<LogService>().info(
        'Action: Tentative de changement d\'avatar',
        component: 'ProfilePage',
      );
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
            getIt<LogService>().warning(
              'Echec: Mise à jour avatar échouée. Erreur: ${failure.message}',
              component: 'ProfilePage',
            );
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
            getIt<LogService>().info(
              'Succès: Avatar mis à jour',
              component: 'ProfilePage',
            );
            if (mounted) {
              // Rafraîchit les données utilisateur pour afficher le nouvel avatar
              context.read<AuthBloc>().add(AuthRefreshUserRequested());
            }
          },
        );
      }
    }
  }

  /// Affiche une boîte de dialogue pour modifier les informations de base du profil.
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
                  suffixText:
                      context
                          .read<AuthBloc>()
                          .state
                          .authResponse
                          ?.user
                          .currency ??
                      'XAF',
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
                getIt<LogService>().info(
                  'Action: Mise à jour du profil demandée',
                  component: 'ProfilePage',
                );
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
          // Bouton d'édition rapide du profil
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditProfileDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // Gestion des erreurs d'authentification ou des notifications de changement de pays
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
                  getIt<LogService>().info(
                    'Rafraîchissement manuel du profil',
                    component: 'ProfilePage',
                  );
                  context.read<AuthBloc>().add(AuthRefreshUserRequested());
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Section En-tête (Avatar + Nom)
                      KeyedSubtree(
                        key: _profileHeaderKey,
                        child: _buildProfileHeader(
                          context,
                          name,
                          user?.email ?? '',
                          user?.avatar,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Liste des badges de gamification obtenus
                      if (user != null && user.badges.isNotEmpty) ...[
                        BadgesList(badges: user.badges),
                        const SizedBox(height: 24),
                      ],
                      // Section Premium / Bannière d'abonnement
                      BlocBuilder<SystemBloc, SystemState>(
                        builder: (context, systemState) {
                          if (!systemState
                              .featureFlags
                              .featSubscriptions
                              .isEnabled) {
                            return const SizedBox.shrink();
                          }
                          if (user != null && !user.isPremium) {
                            return Column(
                              children: [
                                KeyedSubtree(
                                  key: _premiumKey,
                                  child: _buildPremiumBanner(context),
                                ),
                                const SizedBox(height: 24),
                              ],
                            );
                          } else if (user != null && user.isPremium) {
                            return Column(
                              children: [
                                KeyedSubtree(
                                  key: _premiumKey,
                                  child: _buildPremiumStatusCard(context, user),
                                ),
                                const SizedBox(height: 24),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      // Section des paramètres (Réglages) — la cible du
                      // tutoriel est portée par le premier groupe interne,
                      // pas par toute la section (voir _buildSettingsSection).
                      _buildSettingsSection(context),
                      const SizedBox(height: 32),
                      // Bouton de déconnexion
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
                                        '${EnvConfig.apiBaseUrl.replaceAll('/api/v1', '')}$avatarUrl',
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
    return Column(
      children: [
        // Cible du tutoriel volontairement limitée au premier groupe
        // ("Compte") plutôt qu'à toute la section réglages : cette dernière
        // empile plusieurs groupes (Apparence, Aide, Informations…) et
        // dépasse largement la hauteur de l'écran, ce qui rendait la carte
        // d'explication — et ses boutons Passer/Suivant — inatteignable.
        KeyedSubtree(
          key: _settingsKey,
          child: _buildSettingsGroup(
            context,
            title: AppLocalizations.of(context)!.sectionAccount,
            children: [
              BlocBuilder<SystemBloc, SystemState>(
                builder: (context, systemState) {
                  if (!systemState.featureFlags.featNotifications.isEnabled) {
                    return const SizedBox.shrink();
                  }
                  return BlocBuilder<NotificationsBloc, NotificationsState>(
                    builder: (context, state) {
                      return _buildSettingsTile(
                        Icons.notifications_outlined,
                        AppLocalizations.of(context)!.notifications,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (state.unreadCount > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  state.unreadCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.chevron_right,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                        onTap: () => context.push(RouteConstants.notifications),
                      );
                    },
                  );
                },
              ),

              BlocBuilder<SystemBloc, SystemState>(
                builder: (context, systemState) {
                  if (!systemState.featureFlags.featNotifications.isEnabled) {
                    return const SizedBox.shrink();
                  }
                  return BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final currentFrequency =
                          state
                              .authResponse
                              ?.user
                              .preferences
                              ?.notificationFrequency ??
                          'medium';

                      return _buildSettingsTile(
                        Icons.notification_important_outlined,
                        AppLocalizations.of(context)!.notificationFrequency,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getNotificationFrequencyName(
                                context,
                                currentFrequency,
                              ),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.chevron_right,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                        onTap: () => _showNotificationFrequencySelectionDialog(
                          context,
                          currentFrequency,
                        ),
                      );
                    },
                  );
                },
              ),

              _buildSettingsTile(
                Icons.security_outlined,
                AppLocalizations.of(context)!.security,
                onTap: () => context.push(RouteConstants.security),
              ),

              BlocBuilder<SystemBloc, SystemState>(
                builder: (context, systemState) {
                  if (!systemState.featureFlags.authPhone.isEnabled) {
                    return const SizedBox.shrink();
                  }
                  return _buildSettingsTile(
                    Icons.phone_android_outlined,
                    AppLocalizations.of(context)!.phoneNumber,
                    trailing: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final phone = state.authResponse?.user.phone;
                        return Text(
                          phone ?? '',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      getIt<LogService>().info(
                        'Navigation vers la connexion par téléphone',
                        component: 'ProfilePage',
                      );
                      context.push(RouteConstants.phoneLogin, extra: true);
                    },
                  );
                },
              ),

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

              _buildSettingsTile(
                Icons.verified_user_outlined,
                AppLocalizations.of(context)!.kycTitle,
                trailing: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final l10n = AppLocalizations.of(context)!;
                    final kycLevel =
                        state.authResponse?.user.kycLevel ?? 'none';
                    Color statusColor = Colors.orange;
                    String statusText = l10n.kycNotSubmitted;

                    if (kycLevel == 'verified') {
                      statusColor = Colors.green;
                      statusText = l10n.kycVerified;
                    } else if (kycLevel == 'pending') {
                      statusColor = Colors.blue;
                      statusText = l10n.kycPending;
                    } else if (kycLevel == 'rejected') {
                      statusColor = Colors.red;
                      statusText = l10n.kycRejected;
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                onTap: () {
                  final kycLevel =
                      context
                          .read<AuthBloc>()
                          .state
                          .authResponse
                          ?.user
                          .kycLevel ??
                      'none';
                  if (kycLevel == 'pending' || kycLevel == 'verified') {
                    _showKycStatusDialog(context, kycLevel);
                  } else {
                    context.push(RouteConstants.kycSubmission);
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildSettingsGroup(
          context,
          title: AppLocalizations.of(context)!.sectionAppearance,
          children: [
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

            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                final isPremium =
                    authState.authResponse?.user.isPremium ?? false;
                return BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                    return _buildSettingsTile(
                      Icons.brightness_6_outlined,
                      AppLocalizations.of(context)!.theme,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _getThemeName(context, state.themeType),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (!isPremium && state.themeType.isPremiumOnly) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.lock_outline,
                              size: 14,
                              color: Colors.orange,
                            ),
                          ],
                        ],
                      ),
                      onTap: () =>
                          _showThemeSelectionDialog(context, state.themeType),
                    );
                  },
                );
              },
            ),

            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                final isPremium =
                    authState.authResponse?.user.isPremium ?? false;
                final currentTone =
                    authState.authResponse?.user.preferences?.coachTone ??
                    'balanced';

                return _buildSettingsTile(
                  Icons.record_voice_over_outlined,
                  AppLocalizations.of(context)!.coachTone,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getCoachToneName(context, currentTone),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (!isPremium) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.lock_outline,
                          size: 14,
                          color: Colors.orange,
                        ),
                      ],
                    ],
                  ),
                  onTap: () {
                    if (isPremium) {
                      _showCoachToneSelectionDialog(context, currentTone);
                    } else {
                      context.push(RouteConstants.subscription);
                    }
                  },
                );
              },
            ),

            // BlocBuilder<AuthBloc, AuthState>(
            //   builder: (context, authState) {
            //     if (authState.authResponse?.user.isPremium ?? false) {
            //       return Column(
            //         children: [
            //           _buildSettingsTile(
            //             Icons.category_outlined,
            //             "Icône de l'application",
            //             trailing: const Icon(Icons.chevron_right),
            //             onTap: () => _showAppIconSelectionDialog(context),
            //           ),
            //         ],
            //       );
            //     }
            //     return const SizedBox();
            //   },
            // ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSettingsGroup(
          context,
          title: AppLocalizations.of(context)!.sectionLegal,
          children: [
            _buildSettingsTile(
              Icons.help_outline,
              AppLocalizations.of(context)!.helpSupport,
              onTap: () => context.push(RouteConstants.supportTickets),
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

                    _buildSettingsTile(
                      Icons.help_center_outlined,
                      AppLocalizations.of(context)!.howKauriWorks,
                      onTap: () async {
                        await launchUrl(
                          Uri.parse('https://kauri-app.com/about.html'),
                        );
                      },
                    ),

                    _buildSettingsTile(
                      Icons.account_balance_outlined,
                      Localizations.localeOf(context).languageCode == 'fr'
                          ? 'Kauri & l\'Argent Réel'
                          : 'Kauri & Real Money',
                      onTap: () => context.push(RouteConstants.realMoneyInfo),
                    ),

                    _buildSettingsTile(
                      Icons.info_outline,
                      AppLocalizations.of(context)!.aboutApp,
                      onTap: () => _showAboutDialog(context),
                    ),
                  ],
                );
              },
            ),

            KeyedSubtree(
              key: _resetTutorialsKey,
              child: _buildSettingsTile(
                Icons.restart_alt_outlined,
                AppLocalizations.of(context)!.resetTutorials,
                onTap: () => _resetTutorials(context),
              ),
            ),
            _buildSettingsTile(
              Icons.movie_creation_outlined,
              AppLocalizations.of(context)!.replayOnboarding,
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (_) => const OnboardingPage(isReplay: true),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSettingsGroup(
          context,
          title: AppLocalizations.of(context)!.sectionDanger,
          titleColor: Theme.of(context).colorScheme.error,
          children: [
            _buildLogoutButton(context),
            // Future: Add Delete Account here
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsGroup(
    BuildContext context, {
    required String title,
    required List<Widget> children,
    Color? titleColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: AppTextStyles.bodySmall.copyWith(
              color:
                  titleColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: Column(children: children),
          ),
        ),
      ],
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
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.logout,
          color: Theme.of(context).colorScheme.error,
          size: 20,
        ),
      ),
      title: Text(
        AppLocalizations.of(context)!.logout,
        style: AppTextStyles.bodyMedium.copyWith(
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
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
                  getIt<LogService>().info(
                    'Action: Déconnexion utilisateur',
                    component: 'ProfilePage',
                  );
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

  String _getThemeName(BuildContext context, AppThemeType mode) {
    return mode.getLabel(AppLocalizations.of(context)!);
  }

  void _showThemeSelectionDialog(
    BuildContext context,
    AppThemeType currentMode,
  ) {
    final user = context.read<AuthBloc>().state.authResponse?.user;
    final isPremium = user?.isPremium ?? false;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(
              context,
              AppThemeType.light,
              currentMode,
              AppThemeType.light.getLabel(AppLocalizations.of(context)!),
              (value) {
                context.read<SettingsBloc>().add(ThemeChanged(value!));
                Navigator.pop(dialogContext);
              },
            ),
            _buildThemeOption(
              context,
              AppThemeType.dark,
              currentMode,
              AppThemeType.dark.getLabel(AppLocalizations.of(context)!),
              (value) {
                context.read<SettingsBloc>().add(ThemeChanged(value!));
                Navigator.pop(dialogContext);
              },
            ),
            _buildThemeOption(
              context,
              AppThemeType.system,
              currentMode,
              AppThemeType.system.getLabel(AppLocalizations.of(context)!),
              (value) {
                context.read<SettingsBloc>().add(ThemeChanged(value!));
                Navigator.pop(dialogContext);
              },
            ),
            const Divider(),
            _buildThemeOption(
              context,
              AppThemeType.obsidianGold,
              currentMode,
              AppThemeType.obsidianGold.getLabel(AppLocalizations.of(context)!),
              (value) {
                if (isPremium) {
                  context.read<SettingsBloc>().add(ThemeChanged(value!));
                  Navigator.pop(dialogContext);
                } else {
                  Navigator.pop(dialogContext);
                  context.push(RouteConstants.subscription);
                }
              },
              isPremiumOnly: true,
              isPremium: isPremium,
            ),
            _buildThemeOption(
              context,
              AppThemeType.polarNight,
              currentMode,
              AppThemeType.polarNight.getLabel(AppLocalizations.of(context)!),
              (value) {
                if (isPremium) {
                  context.read<SettingsBloc>().add(ThemeChanged(value!));
                  Navigator.pop(dialogContext);
                } else {
                  Navigator.pop(dialogContext);
                  context.push(RouteConstants.subscription);
                }
              },
              isPremiumOnly: true,
              isPremium: isPremium,
            ),
            _buildThemeOption(
              context,
              AppThemeType.sunsetGlow,
              currentMode,
              AppThemeType.sunsetGlow.getLabel(AppLocalizations.of(context)!),
              (value) {
                if (isPremium) {
                  context.read<SettingsBloc>().add(ThemeChanged(value!));
                  Navigator.pop(dialogContext);
                } else {
                  Navigator.pop(dialogContext);
                  context.push(RouteConstants.subscription);
                }
              },
              isPremiumOnly: true,
              isPremium: isPremium,
            ),
            _buildThemeOption(
              context,
              AppThemeType.emeraldForest,
              currentMode,
              AppThemeType.emeraldForest.getLabel(
                AppLocalizations.of(context)!,
              ),
              (value) {
                if (isPremium) {
                  context.read<SettingsBloc>().add(ThemeChanged(value!));
                  Navigator.pop(dialogContext);
                } else {
                  Navigator.pop(dialogContext);
                  context.push(RouteConstants.subscription);
                }
              },
              isPremiumOnly: true,
              isPremium: isPremium,
            ),
            _buildThemeOption(
              context,
              AppThemeType.midnightRoyal,
              currentMode,
              AppThemeType.midnightRoyal.getLabel(
                AppLocalizations.of(context)!,
              ),
              (value) {
                if (isPremium) {
                  context.read<SettingsBloc>().add(ThemeChanged(value!));
                  Navigator.pop(dialogContext);
                } else {
                  Navigator.pop(dialogContext);
                  context.push(RouteConstants.subscription);
                }
              },
              isPremiumOnly: true,
              isPremium: isPremium,
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
                    const Text(
                      'Forfaits Kauri & Revendeur Hub',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Passez à Premium (2 000 FCFA) ou lancez votre activité Revendeur (5 000 FCFA) avec outils et marges dédiés.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
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
              child: const Text(
                'Découvrir les Forfaits & Tarifs',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
    AppThemeType mode,
    AppThemeType groupValue,
    String label,
    ValueChanged<AppThemeType?> onChanged, {
    bool isPremiumOnly = false,
    bool isPremium = false,
  }) {
    final isSelected = mode == groupValue;
    return ListTile(
      title: Text(label),
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      trailing: isPremiumOnly && !isPremium
          ? const Icon(Icons.lock_outline, size: 18, color: Colors.orange)
          : null,
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
  /*
  void _showAppIconSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choisir l'icône"),
        content: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            final currentIcon = state.appIcon;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIconTile(
                  context,
                  title: "Par défaut (Vert)",
                  assetPath: "assets/images/logo.png",
                  value: null,
                  groupValue: currentIcon,
                ),
                _buildIconTile(
                  context,
                  title: "Premium Gold",
                  assetPath: "assets/images/icons/logo_gold.png",
                  value: "gold",
                  groupValue: currentIcon,
                ),
                _buildIconTile(
                  context,
                  title: "Obsidian Dark",
                  assetPath: "assets/images/icons/logo_dark.png",
                  value: "dark",
                  groupValue: currentIcon,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildIconTile(
    BuildContext context, {
    required String title,
    required String assetPath,
    required String? value,
    required String? groupValue,
  }) {
    final isSelected = value == groupValue;

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(assetPath, width: 40, height: 40, fit: BoxFit.cover),
      ),
      title: Text(title),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
          : null,
      onTap: () {
        context.read<SettingsBloc>().add(AppIconChanged(value));
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Icône changée en $title. Redémarrage possible requis.",
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }
  */

  String _getCoachToneName(BuildContext context, String? tone) {
    switch (tone) {
      case 'encouraging':
        return AppLocalizations.of(context)!.toneEncouraging;
      case 'firm':
        return AppLocalizations.of(context)!.toneFirm;
      case 'billionaire_mentor':
        return AppLocalizations.of(context)!.toneBillionaire;
      case 'strict_accountant':
        return AppLocalizations.of(context)!.toneAccountant;
      case 'kind_auntie':
        return AppLocalizations.of(context)!.toneAuntie;
      case 'balanced':
      default:
        return AppLocalizations.of(context)!.toneBalanced;
    }
  }

  void _showCoachToneSelectionDialog(BuildContext context, String currentTone) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.coachTone),
          content: SingleChildScrollView(
            child: RadioGroup<String>(
              groupValue: currentTone,
              onChanged: (value) {
                if (value != null) {
                  context.read<AuthBloc>().add(
                    AuthUpdateProfileRequested(
                      preferences: UserPreferences(coachTone: value),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    [
                      'balanced',
                      'encouraging',
                      'firm',
                      'billionaire_mentor',
                      'strict_accountant',
                      'kind_auntie',
                    ].map((tone) {
                      return RadioListTile<String>(
                        title: Text(_getCoachToneName(context, tone)),
                        value: tone,
                      );
                    }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        );
      },
    );
  }

  String _getNotificationFrequencyName(
    BuildContext context,
    String? frequency,
  ) {
    switch (frequency) {
      case 'high':
        return AppLocalizations.of(context)!.freqHigh;
      case 'low':
        return AppLocalizations.of(context)!.freqLow;
      case 'medium':
      default:
        return AppLocalizations.of(context)!.freqMedium;
    }
  }

  void _showNotificationFrequencySelectionDialog(
    BuildContext context,
    String currentFrequency,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.notificationFrequency),
          content: SingleChildScrollView(
            child: RadioGroup<String>(
              groupValue: currentFrequency,
              onChanged: (value) {
                if (value != null) {
                  context.read<AuthBloc>().add(
                    AuthUpdateProfileRequested(
                      preferences: UserPreferences(
                        notificationFrequency: value,
                      ),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: ['high', 'medium', 'low'].map((freq) {
                  return RadioListTile<String>(
                    title: Text(_getNotificationFrequencyName(context, freq)),
                    value: freq,
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        );
      },
    );
  }

  void _showKycStatusDialog(BuildContext context, String kycLevel) {
    final l10n = AppLocalizations.of(context)!;
    final isPending = kycLevel == 'pending';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isPending
                    ? Colors.blue.withValues(alpha: 0.1)
                    : Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPending
                    ? Icons.hourglass_top_rounded
                    : Icons.verified_rounded,
                color: isPending ? Colors.blue : Colors.green,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isPending
                    ? l10n.kycPendingDialogTitle
                    : l10n.kycVerifiedDialogTitle,
                style: AppTextStyles.h3,
              ),
            ),
          ],
        ),
        content: Text(
          isPending
              ? l10n.kycPendingDialogMessage
              : l10n.kycVerifiedDialogMessage,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}
