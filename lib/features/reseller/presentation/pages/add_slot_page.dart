import 'package:flutter/material.dart';
import 'package:kauri/l10n/app_localizations.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class AddSlotPage extends StatefulWidget {
  final String accountId;
  final String serviceName;

  const AddSlotPage({
    super.key,
    required this.accountId,
    required this.serviceName,
  });

  @override
  State<AddSlotPage> createState() => _AddSlotPageState();
}

class _AddSlotPageState extends State<AddSlotPage> {
  final _formKey = GlobalKey<FormState>();
  final _profileNameController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  final _priceController = TextEditingController();

  String _selectedChannel = 'whatsapp';
  String _selectedCycle = 'monthly';
  DateTime _startDate = DateTime.now();

  @override
  void dispose() {
    _profileNameController.dispose();
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final double price =
          double.tryParse(_priceController.text.trim()) ?? 3000.0;

      // Calculer l'échéance selon le cycle et la date de départ choisie
      final currentPeriodStart = _startDate;
      final currentPeriodEnd = DateTime(
        _startDate.year,
        _selectedCycle == 'yearly'
            ? _startDate.month + 12
            : (_selectedCycle == 'quarterly'
                  ? _startDate.month + 3
                  : _startDate.month + 1),
        _startDate.day,
      );

      final slotData = {
        'profileName': _profileNameController.text.trim(),
        'client': {
          'fullName': _clientNameController.text.trim(),
          'phone': _clientPhoneController.text.trim(),
          'whatsappNumber': _clientPhoneController.text.trim(),
          'preferredReminderChannel': _selectedChannel,
        },
        'price': price,
        'currency': 'XAF',
        'billingCycle': _selectedCycle,
        'startDate': _startDate.toIso8601String(),
        'currentPeriodStart': currentPeriodStart.toIso8601String(),
        'currentPeriodEnd': currentPeriodEnd.toIso8601String(),
      };
      Navigator.pop(context, slotData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(
            context,
          )!.resellerNewSlot(widget.serviceName.toString()),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.resellerProfileAssignment,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _profileNameController,
                label: AppLocalizations.of(context)!.resellerProfileNameLabel,
                validator: (v) =>
                    v?.isEmpty ?? true ? 'Ce champ est requis' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _clientNameController,
                label: AppLocalizations.of(context)!.resellerClientFullName,
                validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _clientPhoneController,
                label: AppLocalizations.of(context)!.resellerClientPhone,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v?.isEmpty ?? true ? 'Requis pour les rappels' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _priceController,
                      label: AppLocalizations.of(context)!.resellerSalePrice,
                      keyboardType: TextInputType.number,
                      validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCycle,
                      decoration: InputDecoration(
                        labelText: 'Cycle',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'monthly',
                          child: Text(AppLocalizations.of(context)!.monthly),
                        ),
                        DropdownMenuItem(
                          value: 'quarterly',
                          child: Text(AppLocalizations.of(context)!.quarterly),
                        ),
                        DropdownMenuItem(
                          value: 'yearly',
                          child: Text(AppLocalizations.of(context)!.yearly),
                        ),
                      ],
                      onChanged: (v) =>
                          setState(() => _selectedCycle = v ?? 'monthly'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 365),
                    ),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() => _startDate = picked);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.resellerFirstPaymentDate,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_startDate.day.toString().padLeft(2, '0')}/${_startDate.month.toString().padLeft(2, '0')}/${_startDate.year}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.event_available_rounded,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                AppLocalizations.of(context)!.resellerReminderChannel,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ChoiceChip(
                    label: Text(
                      AppLocalizations.of(context)!.whatsappRecommended,
                    ),
                    selected: _selectedChannel == 'whatsapp',
                    onSelected: (val) =>
                        setState(() => _selectedChannel = 'whatsapp'),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Push Kauri'),
                    selected: _selectedChannel == 'push',
                    onSelected: (val) =>
                        setState(() => _selectedChannel = 'push'),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              AppButton(
                text: AppLocalizations.of(context)!.resellerAssignAndSave,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
