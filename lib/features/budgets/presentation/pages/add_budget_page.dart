import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/budgets_bloc.dart';
import '../bloc/budgets_event.dart';
import '../bloc/budgets_state.dart';
import '../../data/models/budget_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/app_categories.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../di/injection.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';

class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({super.key});

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _CategoryRowItem {
  String? selectedCategory;
  final TextEditingController amountController;

  _CategoryRowItem() : amountController = TextEditingController();

  void dispose() {
    amountController.dispose();
  }
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  final List<_CategoryRowItem> _categoryItems = [];

  DateTime _selectedDate = DateTime.now();

  final GlobalKey _categoryKey = GlobalKey();
  final GlobalKey _amountKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _addCategory();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.watch<TutorialService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTutorial();
    });
  }

  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (!tutorialService.hasSeenTutorial('add_budget')) {
      if (ModalRoute.of(context)?.isCurrent != true) return;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        ShowCaseWidget.of(context).startShowCase([_categoryKey, _amountKey]);
        tutorialService.markTutorialAsSeen('add_budget');
      });
    }
  }

  @override
  void dispose() {
    try {
      ShowCaseWidget.of(context).dismiss();
    } catch (_) {}
    for (final item in _categoryItems) {
      item.dispose();
    }
    super.dispose();
  }

  void _addCategory() {
    setState(() {
      _categoryItems.add(_CategoryRowItem());
    });
  }

  void _removeCategory(int index) {
    if (_categoryItems.length > 1) {
      setState(() {
        final item = _categoryItems.removeAt(index);
        item.dispose();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'SELECT MONTH AND YEAR',
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();

      final categories = _categoryItems.map((item) {
        return BudgetCategoryModel(
          name: item.selectedCategory ?? AppCategories.categories.last,
          allocated: double.parse(item.amountController.text),
          spent: 0,
          percentage: 0,
        );
      }).toList();

      final totalAllocated = categories.fold<double>(
        0,
        (sum, item) => sum + item.allocated,
      );

      final budget = BudgetModel(
        id: const Uuid().v4(),
        period: BudgetPeriodModel(
          month: _selectedDate.month,
          year: _selectedDate.year,
          type: 'monthly',
        ),
        categories: categories,
        totalAllocated: totalAllocated,
        totalSpent: 0,
        status: 'active',
        createdAt: now,
        updatedAt: now,
      );
      context.read<BudgetsBloc>().add(AddBudgetRequested(budget));
    }
  }

  Widget _buildCategoryDropdown(_CategoryRowItem item) {
    return DropdownButtonFormField<String>(
      initialValue: item.selectedCategory,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.categoryLabel,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      hint: Text(AppLocalizations.of(context)!.categoryHint),
      items: AppCategories.categories.map((String category) {
        return DropdownMenuItem<String>(value: category, child: Text(category));
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          item.selectedCategory = newValue;
        });
      },
      validator: (value) => (value == null || value.isEmpty)
          ? AppLocalizations.of(context)!.requiredField
          : null,
    );
  }

  Widget _buildAmountField(_CategoryRowItem item) {
    return AppTextField(
      controller: item.amountController,
      label: AppLocalizations.of(context)!.amountLabel,
      hint: AppLocalizations.of(context)!.amountHint,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.requiredField;
        }
        if (double.tryParse(value) == null) {
          return AppLocalizations.of(context)!.invalidNumber;
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetsBloc, BudgetsState>(
      listener: (context, state) {
        if (state.status == BudgetsStatus.success) {
          getIt<AnalyticsManager>().trackEvent(
            feature: 'Budgets',
            action: 'create_success',
            details: {
              'total_allocated': state.budgets.last.totalAllocated,
              'category_count': state.budgets.last.categories.length,
            },
          );
          if (context.canPop()) {
            context.pop(true);
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.successBudget),
            ),
          );
        } else if (state.status == BudgetsStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? AppLocalizations.of(context)!.errorBudget,
              ),
            ),
          );
        }
      },
      child: ShowCaseWidget(
        builder: (context) => Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
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
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.monthAndYear,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        '${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.categories,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextButton.icon(
                        onPressed: _addCategory,
                        icon: const Icon(Icons.add),
                        label: Text(AppLocalizations.of(context)!.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _categoryItems.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = _categoryItems[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: index == 0
                                      ? Showcase(
                                          key: _categoryKey,
                                          title: AppLocalizations.of(
                                            context,
                                          )!.categoryLabel,
                                          description: AppLocalizations.of(
                                            context,
                                          )!.categoryHint,
                                          child: _buildCategoryDropdown(item),
                                        )
                                      : _buildCategoryDropdown(item),
                                ),
                                if (_categoryItems.length > 1)
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                    onPressed: () => _removeCategory(index),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            index == 0
                                ? Showcase(
                                    key: _amountKey,
                                    title: AppLocalizations.of(
                                      context,
                                    )!.tutorialAddBudgetTitle,
                                    description: AppLocalizations.of(
                                      context,
                                    )!.tutorialAddBudgetDesc,
                                    child: _buildAmountField(item),
                                  )
                                : _buildAmountField(item),
                          ],
                        ),
                      );
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
