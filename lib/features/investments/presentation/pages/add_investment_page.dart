import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection.dart';
import '../../data/models/investment_model.dart';
import '../bloc/investments_bloc.dart';

class AddInvestmentPage extends StatefulWidget {
  const AddInvestmentPage({super.key});

  @override
  State<AddInvestmentPage> createState() => _AddInvestmentPageState();
}

class _AddInvestmentPageState extends State<AddInvestmentPage> {
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
        currency: 'XAF',
        status: 'active',
        history: [], // Initialize with empty history
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Using getIt to access bloc since we might be outside the provider scope if navigated deeply
      // Better approach: wrap Route in BlocProvider or use event bus, but for now assuming BlocProvider at Page level is sufficient if active.
      // Wait... AddInvestmentPage is pushed onto stack. We need to pass the bloc or re-retrieve it.
      // Since InvestmentsPage creates the bloc, we might need a Global/Feature scope bloc.
      // For now, let's use getIt<InvestmentsBloc>() directly.
      getIt<InvestmentsBloc>().add(AddInvestment(investment));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Nouvel Investissement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Détails de l\'investissement', style: AppTextStyles.h3),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration(
                  'Nom de l\'actif (ex: Bitcoin, Tesla)',
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: _inputDecoration('Type d\'actif'),
                items: const [
                  DropdownMenuItem(
                    value: 'crypto',
                    child: Text('Crypto-monnaie'),
                  ),
                  DropdownMenuItem(
                    value: 'stock',
                    child: Text('Action / Bourse'),
                  ),
                  DropdownMenuItem(
                    value: 'real_estate',
                    child: Text('Immobilier'),
                  ),
                  DropdownMenuItem(value: 'other', child: Text('Autre')),
                ],
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Montant investi (FCFA)'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) =>
                    value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roiController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: _inputDecoration('ROI estimé (%)'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Ajouter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
    );
  }
}
