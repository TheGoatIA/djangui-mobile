import 'package:flutter/material.dart';
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

class JoinTontinePage extends StatefulWidget {
  const JoinTontinePage({super.key});

  @override
  State<JoinTontinePage> createState() => _JoinTontinePageState();
}

class _JoinTontinePageState extends State<JoinTontinePage> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _partsController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    // Pre-fill code if coming from deep link
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final code = GoRouterState.of(context).uri.queryParameters['code'];
      if (code != null) {
        _codeController.text = code;
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
            if (state.status == TontineStatus.success) {
              getIt<AnalyticsManager>().trackEvent(
                feature: 'Tontine',
                action: 'join_success',
              );
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.successJoinTontine)));
              context.pop();
            } else if (state.status == TontineStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? l10n.genericError),
                ),
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(title: Text(l10n.joinTontine)),
            body: Padding(
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
                      hintText: 'e.g. ABC-123',
                      prefixIcon: const Icon(Icons.qr_code),
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n
                          .displayName, // Need to make sure this exists or use a string
                      hintText: l10n.firstNameHint,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _partsController,
                    decoration: InputDecoration(
                      labelText: l10n
                          .numberOfParts, // Need to make sure this exists or use 'Parts'
                      hintText: '1',
                      prefixIcon: const Icon(Icons.pie_chart_outline),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const Spacer(),
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
                                  context.read<TontineBloc>().add(
                                    JoinTontineRequested(
                                      inviteCode: code,
                                      displayName: name,
                                      parts: parts,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.requiredField)),
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
          ),
        );
      },
    );
  }
}
