import 'package:flutter/material.dart';
import 'package:kauri/core/constants/route_constants.dart';
import 'package:kauri/core/navigation/safe_pop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/tontine_bloc.dart';
import '../bloc/tontine_event.dart';
import '../bloc/tontine_state.dart';
import '../../domain/entities/tontine_entities.dart';
import '../../../../di/injection.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';
import '../../../../core/services/telemetry_service.dart';
import 'package:kauri/core/services/log_service.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/widgets/tutorial/tutorial_step.dart';

class CreateTontinePage extends StatefulWidget {
  final Tontine? tontine;
  const CreateTontinePage({super.key, this.tontine});

  @override
  State<CreateTontinePage> createState() => _CreateTontinePageState();
}

class _CreateTontinePageState extends State<CreateTontinePage> {
  final DateTime _enteredAt = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  /// Vrai entre l'envoi du formulaire et la réponse : le TontineBloc est
  /// partagé, un rafraîchissement de liste (success) ne doit pas fermer l'écran.
  bool _awaitingSave = false;

  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _partsController = TextEditingController(text: '12');
  final _socialFundAmountController = TextEditingController(text: '0');
  bool _isSocialFundEnabled = false;

  final _lateFeeController = TextEditingController(text: '0');
  final _gracePeriodController = TextEditingController(text: '24');
  final _absenceFeeController = TextEditingController(text: '0');

  String _frequency = 'monthly';
  String _currency = 'XAF';
  String _rotationMode = 'fixed';
  final GlobalKey _rulesKey = GlobalKey();

  bool get _isEditing => widget.tontine != null;

  @override
  void initState() {
    super.initState();
    final userCurrency = context
        .read<AuthBloc>()
        .state
        .authResponse
        ?.user
        .currency;
    getIt<LogService>().info(
      'Affichage page création/édition tontine',
      component: 'CreateTontinePage',
      metadata: {'isEditing': _isEditing},
    );
    if (userCurrency != null) {
      _currency = userCurrency;
    }

    if (_isEditing) {
      final tontine = widget.tontine!;
      _nameController.text = tontine.name;
      _amountController.text = tontine.contributionAmount.toString();
      _partsController.text = tontine.totalParts.toString();
      _socialFundAmountController.text = (tontine.socialFund['amount'] ?? 0)
          .toString();
      _isSocialFundEnabled = tontine.socialFund['enabled'] ?? false;
      _lateFeeController.text = (tontine.sanctions['lateFee'] ?? 0).toString();
      _gracePeriodController.text =
          (tontine.sanctions['gracePeriodHours'] ?? 24).toString();
      _absenceFeeController.text = (tontine.sanctions['absenceFee'] ?? 0)
          .toString();
      _frequency = tontine.frequency;
      _rotationMode = tontine.rotationMode;
      _startDate = tontine.startDate ?? _startDate;
    }
  }

  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (tutorialService.hasSeenTutorial('create_tontine')) return;
    if (ModalRoute.of(context)?.isCurrent != true) return;
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      tutorialService.startTutorial(context, 'create_tontine', [
        TutorialStep(
          targetKey: _rulesKey,
          title: l10n.tutorialCreateTontineRulesTitle,
          description: l10n.tutorialCreateTontineRulesDesc,
        ),
      ]);
    });
  }

  @override
  void dispose() {
    getIt<TutorialService>().cancelActiveTutorial(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, systemState) {
        final featureStatus = context.read<SystemBloc>().getFeatureStatus(
          systemState.featureFlags.featTontines,
        );

        if (featureStatus == FeatureStatus.disabled) {
          return FeatureDisabledWidget(
            title: _isEditing ? l10n.edit : l10n.createTontine,
          );
        }

        if (featureStatus == FeatureStatus.updateRequired) {
          return FeatureDisabledWidget(
            title: _isEditing ? l10n.edit : l10n.createTontine,
            isUpdateRequired: true,
          );
        }

        return BlocListener<TontineBloc, TontineState>(
          listener: (context, state) {
            if (!_awaitingSave) return;
            if (state.status == TontineStatus.success && _currentStep == 2) {
              _awaitingSave = false;
              getIt<AnalyticsManager>().trackEvent(
                feature: 'Tontine',
                action: 'create',
                details: {
                  'name': _nameController.text,
                  'amount': double.tryParse(_amountController.text),
                  'frequency': _frequency,
                },
              );
              // Confirmation visible (il n'y en avait aucune : l'écran se fermait).
              final messenger = ScaffoldMessenger.of(context);
              final done = _isEditing
                  ? l10n.tontineUpdatedSuccess
                  : l10n.tontineCreatedSuccess;
              context.popOrGo(RouteConstants.tontines);
              messenger.showSnackBar(SnackBar(content: Text(done)));
            } else if (state.status == TontineStatus.error) {
              _awaitingSave = false;
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
                  appBar: AppBar(
                    title: Text(_isEditing ? l10n.edit : l10n.createTontine),
                  ),
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
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.surface,
                appBar: AppBar(
                  title: Text(_isEditing ? l10n.edit : l10n.createTontine),
                ),
                body: Form(
                  key: _formKey,
                  child: Stepper(
                    type: StepperType.vertical,
                    currentStep: _currentStep,
                    onStepContinue: () {
                      if (_currentStep < 2) {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _currentStep++);
                          if (_currentStep == 1) _startTutorial();
                        }
                      } else {
                        _submit();
                      }
                    },
                    onStepCancel: () {
                      if (_currentStep > 0) {
                        setState(() => _currentStep--);
                      } else {
                        context.popOrGo(RouteConstants.tontines);
                      }
                    },
                    steps: [
                      Step(
                        title: Text(l10n.basicInfo),
                        isActive: _currentStep >= 0,
                        content: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: l10n.tontineName,
                              ),
                              validator: (v) =>
                                  v!.isEmpty ? l10n.requiredField : null,
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              title: Text(l10n.startDate),
                              subtitle: Text(
                                "${_startDate.day}/${_startDate.month}/${_startDate.year}",
                              ),
                              trailing: const Icon(Icons.calendar_today),
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: _startDate,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                );
                                if (picked != null) {
                                  setState(() => _startDate = picked);
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            Column(
                              children: [
                                SizedBox(
                                  child: TextFormField(
                                    controller: _amountController,
                                    decoration: InputDecoration(
                                      labelText: l10n.contributionAmount,
                                      suffixText: _currency,
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (v) =>
                                        v!.isEmpty ? l10n.requiredField : null,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _frequency,
                                    decoration: InputDecoration(
                                      labelText: l10n.frequency,
                                    ),
                                    items: [
                                      DropdownMenuItem(
                                        value: 'daily',
                                        child: Text(l10n.daily),
                                      ),
                                      DropdownMenuItem(
                                        value: 'weekly',
                                        child: Text(l10n.weekly),
                                      ),
                                      DropdownMenuItem(
                                        value: 'bi_weekly',
                                        child: Text(l10n.biWeekly),
                                      ),
                                      DropdownMenuItem(
                                        value: 'monthly',
                                        child: Text(l10n.monthly),
                                      ),
                                    ],
                                    onChanged: (v) =>
                                        setState(() => _frequency = v!),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Step(
                        title: Text(l10n.rules),
                        isActive: _currentStep >= 1,
                        content: Column(
                          children: [
                            // Marge haute : sans elle le libellé flottant du
                            // premier champ était coupé par le Stepper.
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _partsController,
                              decoration: InputDecoration(
                                labelText: l10n.totalParts,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return l10n.requiredField;
                                }
                                final parts = int.tryParse(v);
                                if (parts == null || parts <= 0) {
                                  return l10n.invalidAmountError;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            KeyedSubtree(
                              key: _rulesKey,
                              child: DropdownButtonFormField<String>(
                                initialValue: _rotationMode,
                                decoration: InputDecoration(
                                  labelText: l10n.rotationMode,
                                  helperText: _isEditing
                                      ? l10n.rotationModeLockedHint
                                      : null,
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: 'fixed',
                                    child: Text(l10n.manualRotation),
                                  ),
                                  DropdownMenuItem(
                                    value: 'random',
                                    child: Text(l10n.randomRotation),
                                  ),
                                ],
                                onChanged: _isEditing
                                    ? null
                                    : (v) => setState(() => _rotationMode = v!),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              l10n.socialFund,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SwitchListTile(
                              title: Text(l10n.enableSocialFund),
                              value: _isSocialFundEnabled,
                              onChanged: (v) =>
                                  setState(() => _isSocialFundEnabled = v),
                            ),
                            if (_isSocialFundEnabled)
                              TextFormField(
                                controller: _socialFundAmountController,
                                decoration: InputDecoration(
                                  labelText: l10n.amount,
                                  suffixText: _currency,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            const SizedBox(height: 24),
                            Text(
                              l10n.sanctions,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Espace sous le titre : il chevauchait les libellés
                            // « Frais de retard / d'absence » (constaté en capture).
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _lateFeeController,
                                    decoration: InputDecoration(
                                      labelText: l10n.lateFee,
                                      suffixText: _currency,
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _absenceFeeController,
                                    decoration: InputDecoration(
                                      labelText: l10n.absenceFee,
                                      suffixText: _currency,
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _gracePeriodController,
                              decoration: InputDecoration(
                                labelText: l10n.gracePeriod,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      Step(
                        title: Text(l10n.summary),
                        isActive: _currentStep >= 2,
                        content: BlocBuilder<TontineBloc, TontineState>(
                          builder: (context, state) {
                            if (state.status == TontineStatus.loading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSummaryItem(
                                  l10n.tontineName,
                                  _nameController.text,
                                ),
                                _buildSummaryItem(
                                  l10n.startDate,
                                  "${_startDate.day}/${_startDate.month}/${_startDate.year}",
                                ),
                                _buildSummaryItem(
                                  l10n.amount,
                                  '${_amountController.text} $_currency',
                                ),
                                _buildSummaryItem(l10n.frequency, _frequency),
                                _buildSummaryItem(
                                  l10n.rotationMode,
                                  _rotationMode,
                                ),
                              ],
                            );
                          },
                        ),
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

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  void _submit() {
    final params = {
      'name': _nameController.text,
      'frequency': _frequency,
      'contributionAmount': double.parse(_amountController.text),
      'totalParts': int.parse(_partsController.text),
      'currency': _currency,
      // rotationMode is immutable server-side once a tontine is created — the
      // backend rejects the whole update request (400) if this key is even
      // present, so it must only ever be sent on creation.
      if (!_isEditing) 'rotationMode': _rotationMode,
      'startDate': _startDate.toIso8601String(),
      'socialFund': {
        'enabled': _isSocialFundEnabled,
        'amount': _isSocialFundEnabled
            ? double.parse(_socialFundAmountController.text)
            : 0,
      },
      'sanctions': {
        'lateFee': double.parse(_lateFeeController.text),
        'gracePeriodHours': int.parse(_gracePeriodController.text),
        'absenceFee': double.parse(_absenceFeeController.text),
      },
    };

    final frictionDuration = DateTime.now().difference(_enteredAt).inSeconds;
    getIt<TelemetryService>().recordEvent('ux.form.friction', {
      'form_name': 'create_tontine',
      'duration_seconds': frictionDuration,
      'is_editing': _isEditing,
    });

    _awaitingSave = true;
    if (_isEditing) {
      context.read<TontineBloc>().add(
        UpdateTontineRequested(widget.tontine!.id, params),
      );
    } else {
      context.read<TontineBloc>().add(CreateTontineRequested(params));
    }

    getIt<LogService>().info(
      _isEditing
          ? 'Tentative de mise à jour de tontine'
          : 'Tentative de création de tontine',
      component: 'CreateTontinePage',
      page: 'CreateTontine',
      metadata: {
        'name': params['name'],
        'frequency': params['frequency'],
        'amount': params['contributionAmount'],
        'parts': params['totalParts'],
        'is_editing': _isEditing,
      },
    );
  }
}
