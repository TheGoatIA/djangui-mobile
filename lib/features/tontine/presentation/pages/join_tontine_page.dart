import 'package:flutter/material.dart';
import 'package:kauri/core/constants/route_constants.dart';
import 'package:kauri/core/navigation/safe_pop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/tontine_bloc.dart';
import '../bloc/tontine_event.dart';
import '../bloc/tontine_state.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import '../../../../di/injection.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';
import '../../../../core/services/log_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class JoinTontinePage extends StatefulWidget {
  const JoinTontinePage({super.key});

  @override
  State<JoinTontinePage> createState() => _JoinTontinePageState();
}

class _JoinTontinePageState extends State<JoinTontinePage> {
  /// Vrai entre l'envoi et la réponse : le bloc est partagé par toute l'app,
  /// un simple rafraîchissement (status success) faisait afficher un FAUX
  /// succès et fermer l'écran avant même que l'utilisateur n'ait rien envoyé.
  bool _awaitingSubmit = false;

  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _partsController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<LogService>().info(
        'Affichage page rejoindre tontine',
        component: 'JoinTontinePage',
      );
      final code = GoRouterState.of(context).uri.queryParameters['code'];
      if (code != null) {
        _codeController.text = code;
        getIt<LogService>().info(
          'Code tontine pré-rempli: $code',
          component: 'JoinTontinePage',
        );
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _partsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, systemState) {
        final featureStatus = context.read<SystemBloc>().getFeatureStatus(
          systemState.featureFlags.featTontines,
        );

        if (featureStatus == FeatureStatus.disabled) {
          return FeatureDisabledWidget(title: l10n.joinTontine);
        }

        if (featureStatus == FeatureStatus.updateRequired) {
          return FeatureDisabledWidget(
            title: l10n.joinTontine,
            isUpdateRequired: true,
          );
        }

        return BlocListener<TontineBloc, TontineState>(
          listener: (context, state) {
            if (!_awaitingSubmit) return;
            if (state.status != TontineStatus.loading) _awaitingSubmit = false;
            if (state.status == TontineStatus.success) {
              getIt<AnalyticsManager>().trackEvent(
                feature: 'Tontine',
                action: 'join_success',
              );
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.successJoinTontine)));
              context.popOrGo(RouteConstants.tontines);
            } else if (state.status == TontineStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? l10n.genericError),
                ),
              );
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              final userCountry = authState.authResponse?.user.country;
              final isCameroon = userCountry == 'CM';

              if (!isCameroon) {
                return Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  appBar: AppBar(title: Text(l10n.joinTontine)),
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.public_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.tontineRestrictionCM,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.surface,
                appBar: AppBar(title: Text(l10n.joinTontine)),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l10n.enterInviteCode, style: AppTextStyles.h2),
                      const SizedBox(height: 8),
                      Text(
                        l10n.enterInviteCodeDescription,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          labelText: l10n.inviteCode,
                          hintText: AppLocalizations.of(
                            context,
                          )!.inviteCodeExample,
                          prefixIcon: const Icon(Icons.qr_code),
                        ),
                        textCapitalization: TextCapitalization.characters,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: l10n.displayName,
                          hintText: l10n.firstNameHint,
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _partsController,
                        decoration: InputDecoration(
                          labelText: l10n.numberOfParts,
                          hintText: '1',
                          prefixIcon: const Icon(Icons.pie_chart_outline),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<TontineBloc, TontineState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state.status == TontineStatus.loading
                                ? null
                                : () {
                                    final code = _codeController.text.trim();
                                    final name = _nameController.text.trim();
                                    final parts =
                                        int.tryParse(
                                          _partsController.text.trim(),
                                        ) ??
                                        1;

                                    if (code.isNotEmpty && name.isNotEmpty) {
                                      getIt<LogService>().info(
                                        'Action: Tentative de rejoindre tontine $code',
                                        component: 'JoinTontinePage',
                                      );
                                      _awaitingSubmit = true;
                                      context.read<TontineBloc>().add(
                                        JoinTontineRequested(
                                          inviteCode: code,
                                          displayName: name,
                                          parts: parts,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(l10n.requiredField),
                                        ),
                                      );
                                    }
                                  },
                            child: state.status == TontineStatus.loading
                                ? const CircularProgressIndicator()
                                : Text(l10n.joinNow),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
