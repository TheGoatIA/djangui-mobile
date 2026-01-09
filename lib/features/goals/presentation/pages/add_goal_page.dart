import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../bloc/goals_bloc.dart';
import '../bloc/goals_event.dart';
import '../bloc/goals_state.dart';
import '../../data/models/goal_model.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../di/injection.dart';

class AddGoalPage extends StatefulWidget {
  const AddGoalPage({super.key});

  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _emojiController = TextEditingController();
  final _percentageController = TextEditingController(text: '0');

  final GlobalKey _nameKey = GlobalKey();
  final GlobalKey _amountKey = GlobalKey();

  String _selectedType = 'savings';
  String _selectedPriority = 'medium';
  String _selectedStrategy = 'custom';
  DateTime? _selectedDate;
  bool _enableSurplus = false;
  bool _enableRoundup = false;
  bool _showAdvanced = false;

  @override
  void initState() {
    super.initState();
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
    if (!tutorialService.hasSeenTutorial('add_goal')) {
      if (ModalRoute.of(context)?.isCurrent != true) return;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        ShowCaseWidget.of(context).startShowCase([_nameKey, _amountKey]);
        tutorialService.markTutorialAsSeen('add_goal');
      });
    }
  }

  @override
  void dispose() {
    try {
      ShowCaseWidget.of(context).dismiss();
    } catch (_) {}
    _nameController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _emojiController.dispose();
    _percentageController.dispose();
    super.dispose();
  }

  void _onStrategyChanged(String strategy) {
    setState(() {
      _selectedStrategy = strategy;
      // Auto-configure rules based on strategy
      if (strategy == 'roundup') {
        _enableRoundup = true;
        _showAdvanced = true;
      } else if (strategy == '50-30-20') {
        _percentageController.text = '20';
        _showAdvanced = true;
      } else if (strategy == 'pay-yourself-first') {
        _showAdvanced = true;
      }
    });
  }

  void _onSave(BuildContext context) {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final goal = GoalModel(
        id: const Uuid().v4(),
        name: _nameController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        emoji: _emojiController.text.isEmpty ? "" : _emojiController.text,
        type: _selectedType == 'savings'
            ? 'regular'
            : _selectedType == 'investment'
            ? 'project'
            : _selectedType, // 'emergency' matches
        priority: _selectedPriority,
        targetAmount: double.parse(_amountController.text),
        currentAmount: 0,
        deadline: _selectedDate!,
        autoSaveRules: AutoSaveRulesModel(
          enableSurplus: _enableSurplus,
          enableRoundup: _enableRoundup,
          percentageIncome: double.tryParse(_percentageController.text) ?? 0,
        ),
        strategy: GoalStrategyModel(type: _selectedStrategy),
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
    return BlocListener<GoalsBloc, GoalsState>(
      listener: (context, state) {
        if (state.status == GoalsStatus.success) {
          context.pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.successGoal)),
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
      child: ShowCaseWidget(
        builder: (context) => Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
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
                  Showcase(
                    key: _nameKey,
                    title: AppLocalizations.of(context)!.goalNameLabel,
                    description: AppLocalizations.of(context)!.goalNameHint,
                    child: AppTextField(
                      controller: _nameController,
                      label: AppLocalizations.of(context)!.goalNameLabel,
                      hint: AppLocalizations.of(context)!.goalNameHint,
                      validator: (value) => (value == null || value.isEmpty)
                          ? AppLocalizations.of(context)!.requiredField
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _descriptionController,
                    label: AppLocalizations.of(context)!.goalDescriptionLabel,
                    hint: AppLocalizations.of(context)!.goalDescriptionHint,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildDropdown<String>(
                          context,
                          label: AppLocalizations.of(context)!.goalTypeLabel,
                          value: _selectedType,
                          items: [
                            DropdownMenuItem(
                              value: 'emergency',
                              child: Text(
                                AppLocalizations.of(context)!.emergencyType,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'savings',
                              child: Text(
                                AppLocalizations.of(context)!.savingsType,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'investment',
                              child: Text(
                                AppLocalizations.of(context)!.investmentType,
                              ),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => _selectedType = value!),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppTextField(
                          controller: _emojiController,
                          label: AppLocalizations.of(context)!.goalEmojiLabel,
                          hint: '🎯',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildDropdown<String>(
                    context,
                    label: AppLocalizations.of(context)!.goalPriorityLabel,
                    value: _selectedPriority,
                    items: [
                      DropdownMenuItem(
                        value: 'high',
                        child: Text(AppLocalizations.of(context)!.highPriority),
                      ),
                      DropdownMenuItem(
                        value: 'medium',
                        child: Text(
                          AppLocalizations.of(context)!.mediumPriority,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'low',
                        child: Text(AppLocalizations.of(context)!.lowPriority),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => _selectedPriority = value!),
                  ),
                  const SizedBox(height: 20),
                  _buildStrategyDropdown(),
                  const SizedBox(height: 20),
                  Showcase(
                    key: _amountKey,
                    title: AppLocalizations.of(context)!.targetAmountLabel,
                    description: AppLocalizations.of(context)!.amountHint,
                    child: AppTextField(
                      controller: _amountController,
                      label: AppLocalizations.of(context)!.targetAmountLabel,
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
                    ),
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
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
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
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () => setState(() => _showAdvanced = !_showAdvanced),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.autoSaveRulesTitle,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            _showAdvanced
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_showAdvanced) ...[
                    const SizedBox(height: 16),
                    _buildSwitchTile(
                      context,
                      label: AppLocalizations.of(context)!.enableSurplusLabel,
                      value: _enableSurplus,
                      onChanged: (value) =>
                          setState(() => _enableSurplus = value),
                    ),
                    _buildSwitchTile(
                      context,
                      label: AppLocalizations.of(context)!.enableRoundupLabel,
                      value: _enableRoundup,
                      onChanged: (value) =>
                          setState(() => _enableRoundup = value),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _percentageController,
                      label: AppLocalizations.of(
                        context,
                      )!.percentageIncomeLabel,
                      hint: '0',
                      keyboardType: TextInputType.number,
                      suffix: const Text('%'),
                    ),
                  ],
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

  Widget _buildDropdown<T>(
    BuildContext context, {
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(label, style: AppTextStyles.bodyMedium),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      activeThumbColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildStrategyDropdown() {
    final l10n = AppLocalizations.of(context)!;
    final strategies = [
      ('50-30-20', l10n.strategy_50_30_20, l10n.strategy_50_30_20_desc),
      (
        'progressive',
        l10n.strategy_progressive,
        l10n.strategy_progressive_desc,
      ),
      ('roundup', l10n.strategy_roundup, l10n.strategy_roundup_desc),
      (
        'pay-yourself-first',
        l10n.strategy_pay_yourself_first,
        l10n.strategy_pay_yourself_first_desc,
      ),
      ('envelope', l10n.strategy_envelope, l10n.strategy_envelope_desc),
      ('custom', l10n.strategy_custom, l10n.strategy_custom_desc),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.strategyLabel,
          style: AppTextStyles.labelSmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedStrategy,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: strategies.map((strategy) {
                return DropdownMenuItem<String>(
                  value: strategy.$1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(strategy.$2, style: AppTextStyles.bodyMedium),
                      Text(
                        strategy.$3,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) _onStrategyChanged(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
