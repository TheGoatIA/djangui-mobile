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
import '../../../../l10n/app_localizations.dart';

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
              SnackBar(
                content: Text(AppLocalizations.of(context)!.successBudget),
              ),
            );
          } else if (state.status == BudgetsStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      AppLocalizations.of(context)!.errorBudget,
                ),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.addBudgetTitle),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    controller: _categoryController,
                    label: AppLocalizations.of(context)!.categoryLabel,
                    hint: AppLocalizations.of(context)!.categoryHint,
                    validator: (value) => (value == null || value.isEmpty)
                        ? AppLocalizations.of(context)!.requiredField
                        : null,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _limitController,
                    label: AppLocalizations.of(context)!.monthlyLimitLabel,
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return AppLocalizations.of(context)!.requiredField;
                      if (double.tryParse(value) == null)
                        return AppLocalizations.of(context)!.invalidNumber;
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  BlocBuilder<BudgetsBloc, BudgetsState>(
                    builder: (context, state) {
                      return AppButton(
                        text: AppLocalizations.of(context)!.createBudgetAction,
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
