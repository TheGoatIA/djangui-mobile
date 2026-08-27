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
import '../../../../core/widgets/tutorial/tutorial_step.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../di/injection.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../goals/presentation/bloc/goals_bloc.dart';
import '../../../goals/presentation/bloc/goals_state.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';
import '../../../../core/services/log_service.dart';
import '../../../../core/mixins/secure_screen_mixin.dart';

class AddBudgetPage extends StatefulWidget {
  final BudgetModel? budget;
  const AddBudgetPage({super.key, this.budget});

  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _CategoryRowItem {
  String? selectedCategory;
  final TextEditingController categoryController;
  final TextEditingController amountController;
  bool isCustom = false;

  _CategoryRowItem()
    : categoryController = TextEditingController(),
      amountController = TextEditingController();

  void dispose() {
    categoryController.dispose();
    amountController.dispose();
  }
}

class _AddBudgetPageState extends State<AddBudgetPage>
    with WidgetsBindingObserver, SecureScreenMixin<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  final List<_CategoryRowItem> _categoryItems = [];

  DateTime _selectedDate = DateTime.now();
  String? _selectedGoalId;
  // Le budget tel que soumis, gardé localement pour l'analytics une fois la
  // sauvegarde confirmée — plutôt que de le retrouver dans `state.budgets`
  // (voir le listener plus bas), fragile : `.last` suppose à tort que le
  // budget concerné est toujours en fin de liste (vrai à la création, faux
  // en édition) et plante si la liste est vide.
  BudgetModel? _pendingBudget;
  bool _isSavingDialogShowing = false;

  final GlobalKey _categoryKey = GlobalKey();
  final GlobalKey _amountKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.budget != null) {
      _selectedDate = DateTime(
        widget.budget!.period.year,
        widget.budget!.period.month,
      );
      _selectedGoalId = widget.budget!.linkedGoalId;
      for (final category in widget.budget!.categories) {
        final item = _CategoryRowItem();
        item.selectedCategory = category.name;
        item.categoryController.text = category.name;
        item.amountController.text = category.allocated.toStringAsFixed(0);
        _categoryItems.add(item);
      }
    } else {
      _addCategory();
    }
    context.read<BudgetsBloc>().add(ResetBudgetsStatus());
    getIt<LogService>().info(
      'Affichage de la page de création/édition de budget.',
      component: 'AddBudgetPage',
      metadata: {'is_edit': widget.budget != null},
    );
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
    if (tutorialService.hasSeenTutorial('add_budget')) return;
    if (ModalRoute.of(context)?.isCurrent != true) return;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      tutorialService.startTutorial(context, 'add_budget', [
        TutorialStep(
          targetKey: _categoryKey,
          title: l10n.tutorialBudgetCategoryFieldTitle,
          description: l10n.tutorialBudgetCategoryFieldDesc,
        ),
        TutorialStep(
          targetKey: _amountKey,
          title: l10n.tutorialBudgetAmountFieldTitle,
          description: l10n.tutorialBudgetAmountFieldDesc,
        ),
      ]);
    });
  }

  @override
  void dispose() {
    getIt<TutorialService>().cancelActiveTutorial(context);
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
    if (picked != null && picked != _selectedDate && mounted) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();

      final categories = _categoryItems.map((item) {
        final categoryName = item.isCustom
            ? item.categoryController.text
            : (item.selectedCategory ?? item.categoryController.text);

        return BudgetCategoryModel(
          name: categoryName.isEmpty
              ? AppCategories.categories.last
              : categoryName,
          allocated: double.parse(item.amountController.text),
          spent: 0,
          percentage: 0,
        );
      }).toList();

      final totalAllocated = categories.fold<double>(
        0,
        (sum, item) => sum + item.allocated,
      );

      if (widget.budget != null) {
        final budget = widget.budget!.copyWith(
          period: BudgetPeriodModel(
            month: _selectedDate.month,
            year: _selectedDate.year,
            type: 'monthly',
          ),
          categories: categories,
          totalAllocated: totalAllocated,
          updatedAt: now,
          linkedGoalId: _selectedGoalId,
        );
        _pendingBudget = budget;
        context.read<BudgetsBloc>().add(UpdateBudgetRequested(budget));
      } else {
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
          currency:
              context.read<AuthBloc>().state.authResponse?.user.currency ??
              'XAF',
          linkedGoalId: _selectedGoalId,
        );
        _pendingBudget = budget;
        context.read<BudgetsBloc>().add(AddBudgetRequested(budget));
      }
    } else {
      getIt<LogService>().warning(
        'Validation du formulaire de budget échouée',
        component: 'AddBudgetPage',
      );
    }
  }

  Widget _buildCategoryInput(_CategoryRowItem item) {
    if (item.isCustom) {
      return AppTextField(
        controller: item.categoryController,
        label: AppLocalizations.of(context)!.categoryLabel,
        hint: AppLocalizations.of(context)!.categoryHint,
        suffix: IconButton(
          icon: const Icon(Icons.list),
          onPressed: () {
            setState(() {
              item.isCustom = false;
              item.selectedCategory = null;
            });
          },
        ),
        validator: (value) => (value == null || value.isEmpty)
            ? AppLocalizations.of(context)!.requiredField
            : null,
      );
    }

    return BlocBuilder<BudgetsBloc, BudgetsState>(
      builder: (context, state) {
        final budgetCategoryNames = state.budgets
            .expand((b) => b.categories)
            .map((c) => c.name)
            .toSet();

        final allCategories = {
          ...AppCategories.categories,
          ...budgetCategoryNames,
        }.toList()..sort();

        const customOption = "___CUSTOM___";

        return DropdownButtonFormField<String>(
          initialValue: item.selectedCategory,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.categoryLabel,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          hint: Text(AppLocalizations.of(context)!.categoryHint),
          items: [
            ...allCategories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }),
            DropdownMenuItem<String>(
              value: customOption,
              child: Text(
                "+ ${AppLocalizations.of(context)!.other}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          onChanged: (String? newValue) {
            setState(() {
              if (newValue == customOption) {
                item.isCustom = true;
                item.selectedCategory = null;
              } else {
                item.selectedCategory = newValue;
                item.categoryController.text = newValue ?? '';
              }
            });
          },
          validator: (value) => (value == null || value.isEmpty)
              ? AppLocalizations.of(context)!.requiredField
              : null,
        );
      },
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
      suffix: Text(
        context.read<AuthBloc>().state.authResponse?.user.currency ?? 'XAF',
        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = widget.budget != null
        ? l10n.editBudgetTitle
        : l10n.addBudgetTitle;

    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, systemState) {
        final featureStatus = context.read<SystemBloc>().getFeatureStatus(
          systemState.featureFlags.featBudgets,
        );

        if (featureStatus == FeatureStatus.disabled) {
          return FeatureDisabledWidget(title: title);
        }

        if (featureStatus == FeatureStatus.updateRequired) {
          return FeatureDisabledWidget(title: title, isUpdateRequired: true);
        }

        return BlocListener<BudgetsBloc, BudgetsState>(
          listener: (context, state) {
            // `status` est partagé avec GetBudgetsRequested (BudgetsBloc est
            // une instance unique partagée par toute l'app) : sans la garde
            // `_pendingBudget != null`, un simple rechargement de la liste
            // qui commence/se termine PENDANT que cette page est ouverte
            // déclencherait à tort le popup de chargement ou ferait croire
            // qu'une sauvegarde vient de réussir/échouer, sans qu'aucune
            // sauvegarde n'ait eu lieu.
            if (state.status == BudgetsStatus.loading &&
                _pendingBudget != null &&
                !_isSavingDialogShowing) {
              _isSavingDialogShowing = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => PopScope(
                  canPop: false,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    content: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(l10n.budgetSavingInProgress),
                        ),
                      ],
                    ),
                  ),
                ),
              );
              return;
            }

            if (_isSavingDialogShowing &&
                (state.status == BudgetsStatus.success ||
                    state.status == BudgetsStatus.error)) {
              _isSavingDialogShowing = false;
              Navigator.of(context, rootNavigator: true).pop();
            }

            if (state.status == BudgetsStatus.success &&
                _pendingBudget != null) {
              final isEdit = widget.budget != null;
              final submitted = _pendingBudget!;
              _pendingBudget = null;
              getIt<AnalyticsManager>().trackEvent(
                feature: 'Budgets',
                action: isEdit ? 'update_success' : 'create_success',
                details: {
                  'total_allocated': submitted.totalAllocated,
                  'category_count': submitted.categories.length,
                },
              );
              if (context.canPop()) {
                context.pop(true);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isEdit ? l10n.successBudgetUpdate : l10n.successBudget,
                  ),
                ),
              );
            } else if (state.status == BudgetsStatus.error &&
                _pendingBudget != null) {
              _pendingBudget = null;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? l10n.errorBudget)),
              );
            }
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              title: Text(
                widget.budget != null
                    ? l10n.editBudgetTitle
                    : l10n.addBudgetTitle,
              ),
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
                          labelText: l10n.monthAndYear,
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
                          l10n.categories,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextButton.icon(
                          onPressed: _addCategory,
                          icon: const Icon(Icons.add),
                          label: Text(l10n.add),
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
                              color: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: index == 0
                                        ? KeyedSubtree(
                                            key: _categoryKey,
                                            child: _buildCategoryInput(item),
                                          )
                                        : _buildCategoryInput(item),
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
                                  ? KeyedSubtree(
                                      key: _amountKey,
                                      child: _buildAmountField(item),
                                    )
                                  : _buildAmountField(item),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.linkedGoalLabel,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.linkedGoalDescription,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<GoalsBloc, GoalsState>(
                      builder: (context, goalsState) {
                        return DropdownButtonFormField<String?>(
                          initialValue: _selectedGoalId,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem<String?>(
                              value: null,
                              child: Text(l10n.linkedGoalNone),
                            ),
                            ...goalsState.goals.map(
                              (g) => DropdownMenuItem<String?>(
                                value: g.id,
                                child: Text(
                                  g.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => _selectedGoalId = value),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    BlocBuilder<BudgetsBloc, BudgetsState>(
                      builder: (context, state) {
                        return AppButton(
                          text: widget.budget != null
                              ? l10n.updateBudgetAction
                              : l10n.createBudgetAction,
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
        );
      },
    );
  }
}
