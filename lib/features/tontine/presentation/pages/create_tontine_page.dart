import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/tontine_bloc.dart';
import '../bloc/tontine_event.dart';
import '../bloc/tontine_state.dart';
import '../../domain/entities/tontine_entities.dart';
import '../../../../di/injection.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';
import '../../../../core/services/telemetry_service.dart';

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

  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _partsController = TextEditingController(text: '12');
  final _socialFundAmountController = TextEditingController(text: '0');
  bool _isSocialFundEnabled = false;

  final _lateFeeController = TextEditingController(text: '0');
  final _gracePeriodController = TextEditingController(text: '24');
  final _absenceFeeController = TextEditingController(text: '0');

  final List<Map<String, String>> _escrowAccounts = [];

  String _frequency = 'monthly';
  String _currency = 'XAF'; // Ddéfaut
  String _rotationMode = 'fixed';
  String _validationMode = 'ia_only';

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
      _validationMode = tontine.validationMode;
      _startDate = tontine.startDate ?? _startDate;
      // La devise est déjà dans la tontine si on édite, mais ici on prend celle de l'utilisateur par défaut pour la création
      // Si on voulait supporter le changement de devise pour une tontine existante, il faudrait le gérer ici
      if (tontine.escrowDetails != null) {
        for (var account in tontine.escrowDetails!) {
          _escrowAccounts.add({
            'type': account['type']?.toString() ?? '',
            'provider': account['provider']?.toString() ?? '',
            'accountNumber': account['accountNumber']?.toString() ?? '',
            'accountName': account['accountName']?.toString() ?? '',
          });
        }
      }
    }
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
            if (state.status == TontineStatus.success && _currentStep == 3) {
              getIt<AnalyticsManager>().trackEvent(
                feature: 'Tontine',
                action: 'create',
                details: {
                  'name': _nameController.text,
                  'amount': double.tryParse(_amountController.text),
                  'frequency': _frequency,
                },
              );
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
            appBar: AppBar(
              title: Text(_isEditing ? l10n.edit : l10n.createTontine),
            ),
            body: Form(
              key: _formKey,
              child: Stepper(
                type: StepperType.vertical,
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep < 3) {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _currentStep++);
                    }
                  } else {
                    _submit();
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() => _currentStep--);
                  } else {
                    context.pop();
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
                        Row(
                          children: [
                            Expanded(
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
                            const SizedBox(width: 16),
                            Expanded(
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
                        DropdownButtonFormField<String>(
                          initialValue: _rotationMode,
                          decoration: InputDecoration(
                            labelText: l10n.rotationMode,
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
                            DropdownMenuItem(
                              value: 'auction',
                              child: Text(l10n.trustScoreRotation),
                            ),
                          ],
                          onChanged: (v) => setState(() => _rotationMode = v!),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _validationMode,
                          decoration: InputDecoration(
                            labelText: l10n.validationMode,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'ia_only',
                              child: Text(l10n.aiOnlyValidation),
                            ),
                            DropdownMenuItem(
                              value: 'ia_plus_manual',
                              child: Text(l10n.creatorOnlyValidation),
                            ),
                          ],
                          onChanged: (v) =>
                              setState(() => _validationMode = v!),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.socialFund,
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
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
                    title: Text(l10n.paymentAccounts),
                    isActive: _currentStep >= 2,
                    content: Column(
                      children: [
                        if (_escrowAccounts.isEmpty)
                          Text(l10n.noAccountsAdded)
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _escrowAccounts.length,
                            itemBuilder: (context, index) {
                              final account = _escrowAccounts[index];
                              return ListTile(
                                leading: Icon(
                                  account['type'] == 'mobile_money'
                                      ? Icons.phone_android
                                      : Icons.account_balance,
                                ),
                                title: Text(account['provider']!),
                                subtitle: Text(
                                  "${account['accountNumber']} - ${account['accountName']}",
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => setState(
                                    () => _escrowAccounts.removeAt(index),
                                  ),
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _showAddAccountDialog,
                          icon: const Icon(Icons.add),
                          label: Text(l10n.addAccount),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: Text(l10n.summary),
                    isActive: _currentStep >= 3,
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
                            _buildSummaryItem(l10n.rotationMode, _rotationMode),
                            _buildSummaryItem(
                              l10n.validationMode,
                              _validationMode,
                            ),
                            _buildSummaryItem(
                              l10n.paymentAccounts,
                              '${_escrowAccounts.length}',
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
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

  void _showAddAccountDialog() {
    String type = 'mobile_money';
    final providerController = TextEditingController();
    final numberController = TextEditingController();
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.addAccount),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: type,
                    items: [
                      DropdownMenuItem(
                        value: 'mobile_money',
                        child: Text(l10n.mobileMoney),
                      ),
                      DropdownMenuItem(
                        value: 'bank',
                        child: Text(l10n.bankCard),
                      ),
                    ],
                    onChanged: (v) => setState(() => type = v!),
                    decoration: InputDecoration(labelText: l10n.accountType),
                  ),
                  TextField(
                    controller: providerController,
                    decoration: InputDecoration(labelText: l10n.provider),
                  ),
                  TextField(
                    controller: numberController,
                    decoration: InputDecoration(labelText: l10n.accountNumber),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: l10n.accountName),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (providerController.text.isNotEmpty &&
                        numberController.text.isNotEmpty) {
                      this.setState(() {
                        _escrowAccounts.add({
                          'type': type,
                          'provider': providerController.text,
                          'accountNumber': numberController.text,
                          'accountName': nameController.text,
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text(l10n.add),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _submit() {
    final params = {
      'name': _nameController.text,
      'frequency': _frequency,
      'contributionAmount': double.parse(_amountController.text),
      'totalParts': int.parse(_partsController.text),
      'currency': _currency,
      'rotationMode': _rotationMode,
      'validationMode': _validationMode,
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
      'escrowDetails': _escrowAccounts,
    };

    // Telemetry: Form Friction
    final frictionDuration = DateTime.now().difference(_enteredAt).inSeconds;
    getIt<TelemetryService>().recordEvent('ux.form.friction', {
      'form_name': 'create_tontine',
      'duration_seconds': frictionDuration,
      'is_editing': _isEditing,
    });

    if (_isEditing) {
      context.read<TontineBloc>().add(
        UpdateTontineRequested(widget.tontine!.id, params),
      );
    } else {
      context.read<TontineBloc>().add(CreateTontineRequested(params));
    }
  }
}
