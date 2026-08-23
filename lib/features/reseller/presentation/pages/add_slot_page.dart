import 'package:flutter/material.dart';
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
      final double price = double.tryParse(_priceController.text.trim()) ?? 3000.0;
      
      // Calculer l'échéance selon le cycle et la date de départ choisie
      final currentPeriodStart = _startDate;
      final currentPeriodEnd = DateTime(
        _startDate.year,
        _selectedCycle == 'yearly'
            ? _startDate.month + 12
            : (_selectedCycle == 'quarterly' ? _startDate.month + 3 : _startDate.month + 1),
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
      appBar: AppBar(
        title: Text('Nouveau Slot (${widget.serviceName})'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Attribution du Profil',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _profileNameController,
                label: 'Nom du Profil / Écran (ex: Profil 2 - Marie)',
                validator: (v) => v?.isEmpty ?? true ? 'Ce champ est requis' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _clientNameController,
                label: 'Nom complet du client',
                validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _clientPhoneController,
                label: 'Numéro de téléphone / WhatsApp (+237...)',
                keyboardType: TextInputType.phone,
                validator: (v) => v?.isEmpty ?? true ? 'Requis pour les rappels' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _priceController,
                      label: 'Prix de vente (ex: 3 000 FCFA)',
                      keyboardType: TextInputType.number,
                      validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCycle,
                      decoration: const InputDecoration(
                        labelText: 'Cycle',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'monthly', child: Text('Mensuel')),
                        DropdownMenuItem(value: 'quarterly', child: Text('Trimestriel')),
                        DropdownMenuItem(value: 'yearly', child: Text('Annuel')),
                      ],
                      onChanged: (v) => setState(() => _selectedCycle = v ?? 'monthly'),
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
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() => _startDate = picked);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                          const Text(
                            'Date du premier paiement / début d\'accès',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_startDate.day.toString().padLeft(2, '0')}/${_startDate.month.toString().padLeft(2, '0')}/${_startDate.year}',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ],
                      ),
                      const Icon(Icons.event_available_rounded, size: 20, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Canal de Rappel Automatique',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('WhatsApp (Recommandé)'),
                    selected: _selectedChannel == 'whatsapp',
                    onSelected: (val) => setState(() => _selectedChannel = 'whatsapp'),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Push Kauri'),
                    selected: _selectedChannel == 'push',
                    onSelected: (val) => setState(() => _selectedChannel = 'push'),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              AppButton(
                text: 'Attribuer le profil & Enregistrer',
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}