import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../di/injection.dart';
import '../bloc/goals_bloc.dart';
import '../bloc/goals_event.dart';
import '../bloc/goals_state.dart';
import '../../data/models/goal_model.dart';

class AddGoalPage extends StatefulWidget {
  const AddGoalPage({super.key});

  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final goal = GoalModel(
        id: const Uuid().v4(),
        name: _nameController.text,
        targetAmount: double.parse(_amountController.text).toDouble(),
        currentAmount: 0,
        deadline: _selectedDate!,
        createdAt: DateTime.now(),
      );
      context.read<GoalsBloc>().add(AddGoalRequested(goal));
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.selectDateError)),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GoalsBloc>(),
      child: BlocListener<GoalsBloc, GoalsState>(
        listener: (context, state) {
          if (state.status == GoalsStatus.success) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.successGoal),
              ),
            );
          } else if (state.status == GoalsStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? AppLocalizations.of(context)!.errorGoal,
                ),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.addGoalTitle),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    controller: _nameController,
                    label: AppLocalizations.of(context)!.goalNameLabel,
                    hint: AppLocalizations.of(context)!.goalNameHint,
                    validator: (value) => (value == null || value.isEmpty)
                        ? AppLocalizations.of(context)!.requiredField
                        : null,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _amountController,
                    label: AppLocalizations.of(context)!.targetAmountLabel,
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
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDate == null
                                ? AppLocalizations.of(context)!.deadlineLabel
                                : DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(_selectedDate!),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: _selectedDate == null
                                  ? Colors.grey
                                  : AppColors.onBackground,
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  BlocBuilder<GoalsBloc, GoalsState>(
                    builder: (context, state) {
                      return AppButton(
                        text: AppLocalizations.of(context)!.saveGoalAction,
                        isLoading: state.status == GoalsStatus.loading,
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
