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
import '../../../budgets/presentation/bloc/budgets_bloc.dart';
import '../../../budgets/presentation/bloc/budgets_state.dart';
import '../../../../core/constants/app_categories.dart';
import '../../../goals/presentation/bloc/goals_bloc.dart';
import '../../../goals/presentation/bloc/goals_state.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../core/services/tutorial_service.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';

/// Page de création d'une nouvelle transaction (Dépense ou Revenu).
///
/// Permet de saisir manuellement les détails d'une transaction ou d'utiliser
/// la reconnaissance optique de caractères (OCR) pour scanner un reçu.
class AddTransactionPage extends StatefulWidget {
  /// Identifiant d'un objectif d'épargne optionnel auquel lier la transaction.
  final String? initialGoalId;
  const AddTransactionPage({super.key, this.initialGoalId});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  /// Clé globale pour la validation du formulaire.
  final _formKey = GlobalKey<FormState>();

  /// Contrôleurs pour les différents champs de saisie.
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _subcategoryController = TextEditingController();
  final _merchantController = TextEditingController();
  final _locationController = TextEditingController();

  /// Catégorie sélectionnée.
  String? _selectedCategory;

  /// Type de transaction : 'expense' (dépense) ou 'income' (revenu).
  String _type = 'expense';

  /// Identifiant de l'objectif lié.
  String? _selectedGoalId;

  /// État du processus de scan par OCR.
  bool _isScanning = false;

  // Clés utilisées pour le tutoriel interactif.
  final GlobalKey _scanKey = GlobalKey();
  final GlobalKey _amountKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _selectedGoalId = widget.initialGoalId;
    if (_selectedGoalId != null) {
      _type = 'expense';
    }
    context.read<TransactionsBloc>().add(ResetTransactionsStatus());
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

  /// Démarre le tutoriel pour la création de transactions.
  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (!tutorialService.hasSeenTutorial('add_transaction')) {
      if (ModalRoute.of(context)?.isCurrent != true) return;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        ShowCaseWidget.of(context).startShowCase([_scanKey, _amountKey]);
        tutorialService.markTutorialAsSeen('add_transaction');
      });
    }
  }

  @override
  void dispose() {
    try {
      ShowCaseWidget.of(context).dismiss();
    } catch (_) {}
    _amountController.dispose();
    _descriptionController.dispose();
    _subcategoryController.dispose();
    _merchantController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  /// Lance le processus de scan de reçu par OCR (Premium uniquement).
  ///
  /// Demande à l'utilisateur de prendre une photo ou d'en choisir une,
  /// puis extrait le montant, la description et la catégorie.
  Future<void> _onScanReceipt() async {
    final authState = context.read<AuthBloc>().state;
    final isPremium = authState.authResponse?.user.isPremium ?? false;

    // Vérification du statut Premium
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

    // Sélection de la source de l'image
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
      getIt<AnalyticsManager>().trackEvent(
        feature: 'OCR',
        action: 'scan_attempt',
        details: {'source': source.toString()},
      );
      final result = await ocrService.scanReceipt(image);

      getIt<AnalyticsManager>().trackEvent(
        feature: 'OCR',
        action: 'scan_success',
        details: {
          'has_amount': result.amount != null,
          'has_description': result.description != null,
          'category': result.category,
        },
      );

      setState(() {
        if (result.amount != null) {
          _amountController.text = result.amount!.toStringAsFixed(0);
        }
        if (result.description != null) {
          _descriptionController.text = result.description!;
        }
        if (result.category != null) {
          // Tentative de correspondance avec les catégories prédéfinies
          final matchedCategory = AppCategories.categories.firstWhere(
            (c) => c.toLowerCase() == result.category!.toLowerCase(),
            orElse: () => AppCategories.categories.last,
          );
          _selectedCategory = matchedCategory;
        }
        _isScanning = false;
      });

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;

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

  /// Sauvegarde la transaction en validant le formulaire et en appelant le Bloc.
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
        currency: authState.authResponse?.user.currency ?? 'XAF',
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
          getIt<AnalyticsManager>().trackEvent(
            feature: 'Transactions',
            action: 'add_success',
            details: {
              'amount': state.transactions.first.amount,
              'category': state.transactions.first.category,
              'type': state.transactions.first.type,
            },
          );
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
        backgroundColor: Theme.of(context).colorScheme.surface,
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
              Showcase(
                key: _scanKey,
                title: AppLocalizations.of(context)!.tutorialOCRTitle,
                description: AppLocalizations.of(context)!.tutorialOCRDesc,
                child: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: _onScanReceipt,
                  tooltip: AppLocalizations.of(context)!.scanReceiptTooltip,
                ),
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

                // Sélecteur de type : Dépense ou Revenu
                Row(
                  children: [
                    _TypeButton(
                      label: AppLocalizations.of(context)!.expense,
                      isSelected: _type == 'expense',
                      onTap: _selectedGoalId != null
                          ? () {} // Disabled
                          : () => setState(() => _type = 'expense'),
                      color: AppColors.error,
                      enabled: _selectedGoalId == null || _type == 'expense',
                    ),
                    const SizedBox(width: 12),
                    _TypeButton(
                      label: AppLocalizations.of(context)!.income,
                      isSelected: _type == 'income',
                      onTap: _selectedGoalId != null
                          ? () {} // Disabled
                          : () => setState(() => _type = 'income'),
                      color: AppColors.success,
                      enabled: _selectedGoalId == null,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Champ Montant
                Showcase(
                  key: _amountKey,
                  title: AppLocalizations.of(
                    context,
                  )!.tutorialAddTransactionTitle,
                  description: AppLocalizations.of(
                    context,
                  )!.tutorialAddTransactionDesc,
                  child: AppTextField(
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
                    suffix: Text(
                      context
                              .read<AuthBloc>()
                              .state
                              .authResponse
                              ?.user
                              .currency ??
                          'XAF',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sélecteur de catégorie
                BlocBuilder<BudgetsBloc, BudgetsState>(
                  builder: (context, budgetState) {
                    // Union des catégories standards et des catégories existantes dans les budgets
                    final budgetCategoryNames = budgetState.budgets
                        .expand((b) => b.categories)
                        .map((c) => c.name)
                        .toSet();

                    final allCategories = {
                      ...AppCategories.categories,
                      ...budgetCategoryNames,
                    }.toList()..sort();

                    // S'assurer que la catégorie sélectionnée est dans la liste
                    if (_selectedCategory != null &&
                        !allCategories.contains(_selectedCategory)) {
                      allCategories.add(_selectedCategory!);
                      allCategories.sort();
                    }

                    return DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.categoryLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      hint: Text(AppLocalizations.of(context)!.categoryHint),
                      items: allCategories.map((String category) {
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
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Champs optionnels supplémentaires
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

                // Liaison optionnelle avec un objectif d'épargne
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
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                            ),
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
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
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
                              onChanged: (value) {
                                setState(() {
                                  _selectedGoalId = value;
                                  if (_selectedGoalId != null) {
                                    _type = 'expense';
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        if (_selectedGoalId != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.goalForcedExpenseHint,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),

                // Champ Description
                AppTextField(
                  controller: _descriptionController,
                  label: AppLocalizations.of(context)!.descriptionLabel,
                  hint: AppLocalizations.of(context)!.descriptionHint,
                  validator: (value) => (value == null || value.isEmpty)
                      ? AppLocalizations.of(context)!.requiredField
                      : null,
                ),
                const SizedBox(height: 40),

                // Bouton de sauvegarde final
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

/// Bouton personnalisé pour sélectionner le type de transaction (Dépense/Revenu).
class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;
  final bool enabled;

  const _TypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isSelected ? color : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? color
                    : Theme.of(context).colorScheme.outline,
              ),
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
      ),
    );
  }
}
