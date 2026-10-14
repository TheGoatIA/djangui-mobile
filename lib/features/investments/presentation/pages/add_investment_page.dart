import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../di/injection.dart';
import '../../data/models/investment_model.dart';
import '../bloc/investments_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';
import '../../../../core/services/log_service.dart';

class AddInvestmentPage extends StatefulWidget {
  const AddInvestmentPage({super.key});

  @override
  @override
  State<AddInvestmentPage> createState() => _AddInvestmentPageState();
}

class _AddInvestmentPageState extends State<AddInvestmentPage> {
  @override
  void initState() {
    super.initState();
    getIt<LogService>().info(
      'Affichage de la page d\'ajout d\'investissement.',
      component: 'AddInvestmentPage',
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _roiController = TextEditingController();
  String _selectedType = 'crypto';

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _roiController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      final roi = double.tryParse(_roiController.text) ?? 0.0;
      // Calculate current amount based on ROI for simulation
      final currentAmount = amount * (1 + (roi / 100));

      final investment = InvestmentModel(
        id: const Uuid().v4(),
        name: _nameController.text,
        type: _selectedType,
        initialAmount: amount,
        currentAmount: currentAmount,
        currency:
            context.read<AuthBloc>().state.authResponse?.user.currency ?? 'XAF',
        status: 'active',
        history: [], // Initialize with empty history
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Cette page est poussée hors du scope du BlocProvider local
      // d'InvestmentsPage : on récupère donc l'instance via getIt, qui
      // renvoie désormais le même singleton (voir @lazySingleton sur
      // InvestmentsBloc) plutôt qu'une instance jetable déconnectée.
      getIt<LogService>().info(
        'Action: Création d\'investissement',
        component: 'AddInvestmentPage',
        metadata: {'type': _selectedType, 'amount': amount},
      );
      getIt<InvestmentsBloc>().add(AddInvestment(investment));
      if (context.canPop()) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, systemState) {
        final featureStatus = context.read<SystemBloc>().getFeatureStatus(
          systemState.featureFlags.featInvestments,
        );

        if (featureStatus == FeatureStatus.disabled) {
          return FeatureDisabledWidget(
            title: AppLocalizations.of(context)!.newInvestment,
          );
        }

        if (featureStatus == FeatureStatus.updateRequired) {
          return FeatureDisabledWidget(
            title: AppLocalizations.of(context)!.newInvestment,
            isUpdateRequired: true,
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.newInvestment),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.investmentDetails,
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration(
                      context,
                      AppLocalizations.of(context)!.assetNameHint,
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? AppLocalizations.of(context)!.fieldRequired
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    decoration: _inputDecoration(
                      context,
                      AppLocalizations.of(context)!.assetType,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'crypto',
                        child: Text(
                          AppLocalizations.of(context)!.cryptoCurrency,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'stock',
                        child: Text(AppLocalizations.of(context)!.stockMarket),
                      ),
                      DropdownMenuItem(
                        value: 'real_estate',
                        child: Text(AppLocalizations.of(context)!.realEstate),
                      ),
                      DropdownMenuItem(
                        value: 'other',
                        child: Text(AppLocalizations.of(context)!.other),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedType = value!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      context,
                      AppLocalizations.of(context)!.investedAmount,
                      suffix:
                          context
                              .read<AuthBloc>()
                              .state
                              .authResponse
                              ?.user
                              .currency ??
                          'XAF',
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => value == null || value.isEmpty
                        ? AppLocalizations.of(context)!.fieldRequired
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _roiController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: _inputDecoration(
                      context,
                      AppLocalizations.of(context)!.estimatedROI,
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? AppLocalizations.of(context)!.fieldRequired
                        : null,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(AppLocalizations.of(context)!.addInvestment),
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

  InputDecoration _inputDecoration(
    BuildContext context,
    String label, {
    String? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      contentPadding: const EdgeInsets.all(16),
      suffixText: suffix,
      suffixStyle: AppTextStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
