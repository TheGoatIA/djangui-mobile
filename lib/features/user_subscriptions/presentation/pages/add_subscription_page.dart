import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/subscription_model.dart';
import '../bloc/subscription_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../l10n/app_localizations.dart';

class AddSubscriptionPage extends StatefulWidget {
  final SubscriptionModel? subscription;
  const AddSubscriptionPage({super.key, this.subscription});

  @override
  State<AddSubscriptionPage> createState() => _AddSubscriptionPageState();
}

class _AddSubscriptionPageState extends State<AddSubscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _providerController;
  late TextEditingController _amountController;
  late TextEditingController _categoryController;
  late String _frequency;
  late String _status;
  late DateTime _nextBillingDate;
  DateTime? _trialEndDate;
  bool _remindMe = true;

  @override
  void initState() {
    super.initState();
    final sub = widget.subscription;
    _nameController = TextEditingController(text: sub?.name ?? '');
    _providerController = TextEditingController(text: sub?.provider ?? '');
    _amountController = TextEditingController(
      text: sub?.amount.toString() ?? '',
    );
    _categoryController = TextEditingController(text: sub?.category ?? '');
    _frequency = sub?.frequency ?? 'monthly';
    _status = sub?.status ?? 'active';
    _nextBillingDate =
        sub?.nextBillingDate ?? DateTime.now().add(const Duration(days: 30));
    _trialEndDate = sub?.trialEndDate;
    _remindMe = sub?.remindMe ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _providerController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _nextBillingDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null && picked != _nextBillingDate) {
      setState(() {
        _nextBillingDate = picked;
      });
    }
  }

  Future<void> _selectTrialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _trialEndDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _trialEndDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subscription == null
              ? l10n.addSubscription
              : l10n.editSubscription,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.subscriptionNameLabel,
                  hintText: l10n.subscriptionNameHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.label_outline),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? l10n.requiredField : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _providerController,
                decoration: InputDecoration(
                  labelText: l10n.providerLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.business),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: l10n.amountLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.attach_money),
                  suffixText:
                      context
                          .read<AuthBloc>()
                          .state
                          .authResponse
                          ?.user
                          .currency ??
                      'XAF',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return l10n.requiredField;
                  if (double.tryParse(val) == null) return l10n.invalidAmount;
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _frequency,
                decoration: InputDecoration(
                  labelText: l10n.frequency,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.repeat),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'weekly',
                    child: Text(l10n.frequencyWeekly),
                  ),
                  DropdownMenuItem(
                    value: 'monthly',
                    child: Text(l10n.frequencyMonthly),
                  ),
                  DropdownMenuItem(
                    value: 'yearly',
                    child: Text(l10n.frequencyYearly),
                  ),
                ],
                onChanged: (val) => setState(() => _frequency = val!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: InputDecoration(
                  labelText: l10n.status,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.info_outline),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'active',
                    child: Text(l10n.statusActive),
                  ),
                  DropdownMenuItem(
                    value: 'paused',
                    child: Text(l10n.statusPaused),
                  ),
                  DropdownMenuItem(
                    value: 'cancelled',
                    child: Text(l10n.statusCancelled),
                  ),
                  DropdownMenuItem(
                    value: 'expired',
                    child: Text(l10n.statusExpired),
                  ),
                ],
                onChanged: (val) => setState(() => _status = val!),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(l10n.nextBillingDateLabel),
                subtitle: Text(
                  DateFormat.yMMMd(locale).format(_nextBillingDate),
                ),
                trailing: const Icon(Icons.calendar_today),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: l10n.categoryLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.category_outlined),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(l10n.trialEndDateLabel),
                subtitle: Text(
                  _trialEndDate == null
                      ? l10n.none
                      : DateFormat.yMMMd(locale).format(_trialEndDate!),
                ),
                trailing: const Icon(Icons.event),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                onTap: () => _selectTrialDate(context),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text(l10n.remindMeLabel),
                subtitle: Text(l10n.remindMeSubtitle),
                value: _remindMe,
                onChanged: (val) => setState(() => _remindMe = val),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final sub = SubscriptionModel(
                        id: widget.subscription?.id,
                        userId: widget.subscription?.userId,
                        name: _nameController.text,
                        amount: double.parse(_amountController.text),
                        currency:
                            context
                                .read<AuthBloc>()
                                .state
                                .authResponse
                                ?.user
                                .currency ??
                            'XAF',
                        frequency: _frequency,
                        nextBillingDate: _nextBillingDate,
                        trialEndDate: _trialEndDate,
                        category: _categoryController.text,
                        remindMe: _remindMe,
                        status: _status,
                        provider: _providerController.text,
                        createdAt: widget.subscription?.createdAt,
                        updatedAt: widget.subscription?.updatedAt,
                      );

                      if (widget.subscription == null) {
                        context.read<SubscriptionBloc>().add(
                          AddSubscriptionRequested(sub),
                        );
                      } else {
                        context.read<SubscriptionBloc>().add(
                          UpdateSubscriptionRequested(sub.id!, sub),
                        );
                      }
                      context.pop();
                    }
                  },
                  child: Text(
                    widget.subscription == null ? l10n.add : l10n.save,
                  ),
                ),
              ),
              if (widget.subscription != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    onPressed: () {
                      context.read<SubscriptionBloc>().add(
                        DeleteSubscriptionRequested(widget.subscription!.id!),
                      );
                      context.pop();
                    },
                    child: Text(l10n.delete),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
