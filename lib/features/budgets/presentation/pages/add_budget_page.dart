import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../di/injection.dart';
import '../bloc/budgets_bloc.dart';
import '../bloc/budgets_event.dart';
import '../bloc/budgets_state.dart';
import '../../data/models/budget_model.dart';

class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({super.key});

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();
  final _limitController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final budget = BudgetModel(
        id: const Uuid().v4(),
        category: _categoryController.text,
        limitAmount: double.parse(_limitController.text),
        spentAmount: 0,
        startDate: DateTime(now.year, now.month, 1),
        endDate: DateTime(now.year, now.month + 1, 0),
      );
      context.read<BudgetsBloc>().add(AddBudgetRequested(budget));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BudgetsBloc>(),
      child: BlocListener<BudgetsBloc, BudgetsState>(
        listener: (context, state) {
          if (state.status == BudgetsStatus.success) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Budget créé avec succès')),
            );
          } else if (state.status == BudgetsStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Erreur lors de la création',
                ),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: const Text('Définir un budget')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    controller: _categoryController,
                    label: 'Catégorie',
                    hint: 'ex: Alimentation, Transport...',
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Champs requis'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _limitController,
                    label: 'Limite mensuelle',
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
                  const SizedBox(height: 40),
                  BlocBuilder<BudgetsBloc, BudgetsState>(
                    builder: (context, state) {
                      return AppButton(
                        text: 'Créer le budget',
                        isLoading: state.status == BudgetsStatus.loading,
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
