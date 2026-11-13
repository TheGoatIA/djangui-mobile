import 'package:flutter/material.dart';
import 'package:kauri/core/constants/category_labels.dart';
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
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/widgets/tutorial/tutorial_step.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import 'package:kauri/core/services/telemetry_service.dart';
import 'package:kauri/core/services/log_service.dart';

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
  final DateTime _enteredAt = DateTime.now();

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

  /// État du processus de scan par OCR.
  bool _isScanning = false;

  /// Vrai uniquement entre l'appui sur « Enregistrer » et la réponse : le bloc
  /// des transactions est partagé par toute l'app, un simple rafraîchissement
  /// de la liste (loading → success) fermait sinon ce formulaire en cours de
  /// saisie avec un faux « Transaction ajoutée » (constaté en E2E).
  bool _awaitingSave = false;

  // Clés utilisées pour le tutoriel interactif.
  final GlobalKey _scanKey = GlobalKey();
  final GlobalKey _amountKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _amountController.text = ''; // Ensure clean start
    _type = 'expense';
    context.read<TransactionsBloc>().add(ResetTransactionsStatus());
    getIt<LogService>().info(
      'Affichage de la page d\'ajout de transaction.',
      component: 'AddTransactionPage',
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

  /// Démarre le tutoriel pour la création de transactions.
  ///
  /// La cible de scan OCR n'est construite que si le feature flag est actif
  /// (voir le BlocBuilder du SystemBloc dans l'AppBar) : on ne l'inclut donc
  /// dans la séquence que dans ce cas, sinon le tutoriel resterait bloqué.
  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (tutorialService.hasSeenTutorial('add_transaction')) return;
    if (ModalRoute.of(context)?.isCurrent != true) return;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final showScanStep = context
          .read<SystemBloc>()
          .state
          .featureFlags
          .featScanUpload
          .isEnabled;
      final l10n = AppLocalizations.of(context)!;
      tutorialService.startTutorial(context, 'add_transaction', [
        if (showScanStep)
          TutorialStep(
            targetKey: _scanKey,
            title: l10n.tutorialOCRTitle,
            description: l10n.tutorialOCRDesc,
          ),
        TutorialStep(
          targetKey: _amountKey,
          title: l10n.tutorialAddTransactionTitle,
          description: l10n.tutorialAddTransactionDesc,
        ),
      ]);
    });
  }

  @override
  void dispose() {
    getIt<TutorialService>().cancelActiveTutorial(context);
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
            onPressed: () {
              if (!mounted) return;
              context.push(RouteConstants.subscription);
            },
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

    if (source == null) {
      getIt<LogService>().info(
        'Annulation de la sélection de source OCR.',
        component: 'AddTransactionPage',
      );
      return;
    }
    getIt<LogService>().info(
      'Début du scan OCR via ${source.name}',
      component: 'AddTransactionPage',
    );

    final image = await ocrService.pickImage(source);
    if (image == null) return;
    if (!mounted) return;

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

      if (!mounted) return;
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
      getIt<LogService>().info(
        'Scan OCR réussi.',
        component: 'AddTransactionPage',
        metadata: {'amount': result.amount, 'category': result.category},
      );

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
      getIt<LogService>().error(
        'Erreur technique lors du scan OCR',
        error: e,
        component: 'AddTransactionPage',
        page: 'AddTransaction',
      );
      if (mounted) {
        setState(() => _isScanning = false);
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
        source: 'manual',
        currency: authState.authResponse?.user.currency ?? 'XAF',
      );

      // Telemetry: Form Friction
      final frictionDuration = DateTime.now().difference(_enteredAt).inSeconds;
      getIt<TelemetryService>().recordEvent('ux.form.friction', {
        'form_name': 'add_transaction',
        'duration_seconds': frictionDuration,
        'is_ocr_used':
            _merchantController.text.isNotEmpty ||
            _amountController.text.isNotEmpty, // simplified check
      });

      _awaitingSave = true;
      context.read<TransactionsBloc>().add(
        AddTransactionRequested(transaction),
      );

      getIt<LogService>().info(
        'Tentative d\'ajout d\'une transaction',
        component: 'AddTransactionPage',
        page: 'AddTransaction',
        metadata: {
          'amount': transaction.amount,
          'type': transaction.type,
          'category': transaction.category,
          'is_ocr':
              _merchantController.text.isNotEmpty ||
              _amountController.text.isNotEmpty,
        },
      );
    } else {
      getIt<LogService>().warning(
        'Validation du formulaire de transaction échouée',
        component: 'AddTransactionPage',
        page: 'AddTransaction',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, systemState) {
        final featureStatus = context.read<SystemBloc>().getFeatureStatus(
          systemState.featureFlags.featManualTransactions,
        );

        if (featureStatus == FeatureStatus.disabled) {
          return FeatureDisabledWidget(title: l10n.addTransactionTitle);
        }

        if (featureStatus == FeatureStatus.updateRequired) {
          return FeatureDisabledWidget(
            title: l10n.addTransactionTitle,
            isUpdateRequired: true,
          );
        }

        return BlocListener<TransactionsBloc, TransactionsState>(
          // Succès ET échec de l'envoi : l'ancien filtre ne laissait passer que
          // le succès, la branche d'erreur ci-dessous ne s'exécutait jamais et un
          // refus serveur laissait l'utilisateur sans aucun retour.
          listenWhen: (previous, current) =>
              _awaitingSave &&
              previous.status == TransactionsStatus.loading &&
              (current.status == TransactionsStatus.success ||
                  current.status == TransactionsStatus.error),
          listener: (context, state) {
            _awaitingSave = false;
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
              final messenger = ScaffoldMessenger.of(context);
              final successText = AppLocalizations.of(
                context,
              )!.successTransaction;
              if (context.canPop()) {
                context.pop(true);
              } else {
                context.go(RouteConstants.transactions);
              }
              messenger.showSnackBar(SnackBar(content: Text(successText)));
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
                BlocBuilder<SystemBloc, SystemState>(
                  builder: (context, systemState) {
                    if (!systemState.featureFlags.featScanUpload.isEnabled) {
                      return const SizedBox.shrink();
                    }
                    if (_isScanning) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }
                    return KeyedSubtree(
                      key: _scanKey,
                      child: IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: _onScanReceipt,
                        tooltip: AppLocalizations.of(
                          context,
                        )!.scanReceiptTooltip,
                      ),
                    );
                  },
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

                    // Champ Montant
                    KeyedSubtree(
                      key: _amountKey,
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
                            labelText: AppLocalizations.of(
                              context,
                            )!.categoryLabel,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          hint: Text(
                            AppLocalizations.of(context)!.categoryHint,
                          ),
                          items: allCategories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(
                                CategoryLabels.display(context, category),
                              ),
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

                    const SizedBox(height: 20),

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
      },
    );
  }
}

/// Bouton personnalisé pour sélectionner le type de transaction (Dépense/Revenu).
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
            border: Border.all(
              color: isSelected ? color : Theme.of(context).colorScheme.outline,
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
    );
  }
}
