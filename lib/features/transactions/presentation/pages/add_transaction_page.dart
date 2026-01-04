import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/transactions_bloc.dart';
import '../../data/models/transaction_model.dart';
import '../../../../core/services/ocr_service.dart';
import 'package:image_picker/image_picker.dart';

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
  bool _isScanning = false;

  Future<void> _onScanReceipt() async {
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
          _categoryController.text = result.category!;
        }
        _isScanning = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.receiptScannedSuccess),
          ),
        );
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
