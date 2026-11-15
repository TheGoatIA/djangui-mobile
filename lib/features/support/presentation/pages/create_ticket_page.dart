import 'package:flutter/material.dart';
import 'package:kauri/core/constants/route_constants.dart';
import 'package:kauri/core/navigation/safe_pop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/support_bloc.dart';
import '../bloc/support_event.dart';
import '../bloc/support_state.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import '../../../../di/injection.dart';
import '../../../../core/services/log_service.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  /// Vrai entre l'envoi et la réponse : le bloc est partagé par toute l'app,
  /// un simple rafraîchissement (status success) faisait afficher un FAUX
  /// succès et fermer l'écran avant même que l'utilisateur n'ait rien envoyé.
  bool _awaitingSubmit = false;

  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getIt<LogService>().info(
      'Affichage de la page de création de ticket.',
      component: 'CreateTicketPage',
    );
  }

  String _selectedCategory = 'other';

  final List<String> _categories = ['bug', 'payment', 'account', 'other'];

  String _getCategoryName(String category, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case 'bug':
        return l10n.categoryBug;
      case 'payment':
        return l10n.categoryPayment;
      case 'account':
        return l10n.categoryAccount;
      case 'other':
      default:
        return l10n.categoryOther;
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.createTicket)),
      body: BlocConsumer<SupportBloc, SupportState>(
        listener: (context, state) {
          if (!_awaitingSubmit) return;
          if (state.status != SupportStatus.loading) _awaitingSubmit = false;
          if (state.status == SupportStatus.success) {
            getIt<AnalyticsManager>().trackEvent(
              feature: 'Support',
              action: 'create_success',
              details: {'category': _selectedCategory},
            );
            getIt<LogService>().info(
              'Succès: Ticket créé avec succès',
              component: 'CreateTicketPage',
              metadata: {'category': _selectedCategory},
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.ticketCreatedSuccess,
                ),
              ),
            );
            context.popOrGo(RouteConstants.supportTickets);
          } else if (state.status == SupportStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      AppLocalizations.of(context)!.genericError,
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.ticketCategory,
                    prefixIcon: const Icon(Icons.category_outlined),
                  ),
                  items: _categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(_getCategoryName(cat, context)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedCategory = value);
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.ticketSubject,
                    prefixIcon: const Icon(Icons.subject),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.requiredField;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.ticketMessage,
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: const Icon(Icons.message_outlined),
                    ),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.requiredField;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: state.status == SupportStatus.loading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            getIt<LogService>().info(
                              'Action: Soumission nouveau ticket',
                              component: 'CreateTicketPage',
                              metadata: {'category': _selectedCategory},
                            );
                            _awaitingSubmit = true;
                            context.read<SupportBloc>().add(
                              CreateTicketRequested(
                                subject: _subjectController.text,
                                message: _messageController.text,
                                category: _selectedCategory,
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: state.status == SupportStatus.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          AppLocalizations.of(context)!.sendTicket,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
