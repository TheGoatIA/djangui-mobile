import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/transactions_bloc.dart';
import '../../data/models/transaction_model.dart';
import '../../../../core/services/ocr_service.dart';
import '../../../../core/constants/app_categories.dart';
import '../../../goals/presentation/bloc/goals_bloc.dart';
import '../../../goals/presentation/bloc/goals_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddTransactionPage extends StatefulWidget {
  final String? initialGoalId;
  const AddTransactionPage({super.key, this.initialGoalId});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  final _subcategoryController = TextEditingController();
  final _merchantController = TextEditingController();
  final _locationController = TextEditingController();
  String _type = 'expense';
  String? _selectedGoalId;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _selectedGoalId = widget.initialGoalId;
    if (_selectedGoalId != null) {
      _type = 'income';
    }
    // Reset status to prevent immediate pop if previous state was success
    context.read<TransactionsBloc>().add(ResetTransactionsStatus());
  }

  Future<void> _onScanReceipt() async {
    final authState = context.read<AuthBloc>().state;
    final isPremium = authState.authResponse?.user.isPremium ?? false;

    if (!isPremium) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.ocrPremiumRestriction),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.seeOffers,
            onPressed: () => context.push(RouteConstants.subscription),
          ),
        ),
      );
      return;
    }

    final ocrService = getIt<OCRService>();

    // Show picker source selection
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(AppLocalizations.of(context)!.takePhoto),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(AppLocalizations.of(context)!.chooseFromGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final image = await ocrService.pickImage(source);
    if (image == null) return;

    setState(() => _isScanning = true);

    try {
      final result = await ocrService.scanReceipt(image);

      setState(() {
        if (result.amount != null) {
          _amountController.text = result.amount!.toStringAsFixed(0);
        }
        if (result.description != null) {
          _descriptionController.text = result.description!;
        }
        if (result.category != null) {
          // Try to match scanned category with predefined list
          final matchedCategory = AppCategories.categories.firstWhere(
            (c) => c.toLowerCase() == result.category!.toLowerCase(),
            orElse: () => AppCategories.categories.last, // 'Autres'
          );
          _selectedCategory = matchedCategory;
        }
        _isScanning = false;
      });

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;

        // Only show success if we actually found something useful
        if (result.amount != null || result.description != null) {
          String details = '';
          if (result.amount != null && result.description != null) {
            details =
                ': ${result.amount!.toStringAsFixed(0)} XAF (${result.description})';
          } else if (result.amount != null) {
            details = ': ${result.amount!.toStringAsFixed(0)} XAF';
          } else if (result.description != null) {
            details = ': ${result.description}';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.receiptScannedSuccess}$details'),
              backgroundColor: AppColors.success,
            ),
          );
        } else {
          // If no amount or description was found, it's probably not a receipt
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.receiptScannedError),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isScanning = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.receiptScannedError),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _subcategoryController.dispose();
    _merchantController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      final userId = authState.authResponse?.user.id;

      final transaction = TransactionModel(
        id: const Uuid().v4(),
        userId: userId,
        amount: double.parse(_amountController.text),
        type: _type,
        category: _selectedCategory ?? AppCategories.categories.last,
        subcategory: _subcategoryController.text.isNotEmpty
            ? _subcategoryController.text
            : null,
        description: _descriptionController.text,
        merchant: _merchantController.text.isNotEmpty
            ? _merchantController.text
            : null,
        location: _locationController.text.isNotEmpty
            ? _locationController.text
            : null,
        date: DateTime.now(),
        linkedGoalId: _selectedGoalId,
      );
      context.read<TransactionsBloc>().add(
        AddTransactionRequested(transaction),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionsBloc, TransactionsState>(
      listenWhen: (previous, current) =>
          previous.status == TransactionsStatus.loading &&
          current.status == TransactionsStatus.success,
      listener: (context, state) {
        if (state.status == TransactionsStatus.success) {
          context.pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.successTransaction),
            ),
          );
        } else if (state.status == TransactionsStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ??
                    AppLocalizations.of(context)!.errorTransaction,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.addTransactionTitle),
          actions: [
            if (_isScanning)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else
              IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: _onScanReceipt,
                tooltip: AppLocalizations.of(context)!.scanReceiptTooltip,
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.transactionType,
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _TypeButton(
                      label: AppLocalizations.of(context)!.expense,
                      isSelected: _type == 'expense',
                      onTap: () => setState(() => _type = 'expense'),
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 12),
                    _TypeButton(
                      label: AppLocalizations.of(context)!.income,
                      isSelected: _type == 'income',
                      onTap: () => setState(() => _type = 'income'),
                      color: AppColors.success,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AppTextField(
                  controller: _amountController,
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
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.categoryLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  hint: Text(AppLocalizations.of(context)!.categoryHint),
                  items: AppCategories.categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  validator: (value) => (value == null || value.isEmpty)
                      ? AppLocalizations.of(context)!.requiredField
                      : null,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _subcategoryController,
                  label: AppLocalizations.of(context)!.subcategoryLabel,
                  hint: AppLocalizations.of(context)!.subcategoryHint,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _merchantController,
                  label: AppLocalizations.of(context)!.merchantLabel,
                  hint: AppLocalizations.of(context)!.merchantHint,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _locationController,
                  label: AppLocalizations.of(context)!.locationLabel,
                  hint: AppLocalizations.of(context)!.locationHint,
                ),
                const SizedBox(height: 20),
                BlocBuilder<GoalsBloc, GoalsState>(
                  builder: (context, state) {
                    if (state.goals.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.linkToGoalLabel,
                          style: AppTextStyles.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.outline),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedGoalId,
                              isExpanded: true,
                              hint: Text(
                                AppLocalizations.of(context)!.selectGoalHint,
                              ),
                              items: [
                                DropdownMenuItem<String>(
                                  value: null,
                                  child: Text(
                                    AppLocalizations.of(context)!.none,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                                ...state.goals.map((goal) {
                                  return DropdownMenuItem(
                                    value: goal.id,
                                    child: Text(
                                      "${goal.emoji ?? '🎯'} ${goal.name}",
                                    ),
                                  );
                                }),
                              ],
                              onChanged: (value) =>
                                  setState(() => _selectedGoalId = value),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
                AppTextField(
                  controller: _descriptionController,
                  label: AppLocalizations.of(context)!.descriptionLabel,
                  hint: AppLocalizations.of(context)!.descriptionHint,
                  validator: (value) => (value == null || value.isEmpty)
                      ? AppLocalizations.of(context)!.requiredField
                      : null,
                ),
                const SizedBox(height: 40),
                BlocBuilder<TransactionsBloc, TransactionsState>(
                  builder: (context, state) {
                    return AppButton(
                      text: AppLocalizations.of(context)!.saveAction,
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
            color: isSelected ? color : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? color : AppColors.outline),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
