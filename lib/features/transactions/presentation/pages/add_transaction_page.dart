import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../di/injection.dart';
import '../bloc/transactions_bloc.dart';
import '../../data/models/transaction_model.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  String _type = 'expense';

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final transaction = TransactionModel(
        id: const Uuid().v4(),
        amount: double.parse(_amountController.text),
        type: _type,
        category: _categoryController.text,
        description: _descriptionController.text,
        date: DateTime.now(),
      );
      context.read<TransactionsBloc>().add(
        AddTransactionRequested(transaction),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TransactionsBloc>(),
      child: BlocListener<TransactionsBloc, TransactionsState>(
        listener: (context, state) {
          if (state.status == TransactionsStatus.success) {
            context.pop(true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Transaction ajoutée avec succès')),
            );
          } else if (state.status == TransactionsStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Erreur lors de l\'ajout'),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: const Text('Ajouter une transaction')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Type de transaction', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _TypeButton(
                        label: 'Dépense',
                        isSelected: _type == 'expense',
                        onTap: () => setState(() => _type = 'expense'),
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 12),
                      _TypeButton(
                        label: 'Revenu',
                        isSelected: _type == 'income',
                        onTap: () => setState(() => _type = 'income'),
                        color: AppColors.success,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    controller: _amountController,
                    label: 'Montant',
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Champs requis';
                      if (double.tryParse(value) == null)
                        return 'Nombre invalide';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _categoryController,
                    label: 'Catégorie',
                    hint: 'ex: Alimentation, Salaire...',
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Champs requis'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    hint: 'ex: Courses du mois',
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Champs requis'
                        : null,
                  ),
                  const SizedBox(height: 40),
                  BlocBuilder<TransactionsBloc, TransactionsState>(
                    builder: (context, state) {
                      return AppButton(
                        text: 'Enregistrer',
                        isLoading: state.status == TransactionsStatus.loading,
                        onPressed: () => _onSave(context),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _TypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? color : Colors.grey[300]!),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
