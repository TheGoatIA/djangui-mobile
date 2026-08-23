import 'package:flutter/material.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class AddMasterAccountPage extends StatefulWidget {
  const AddMasterAccountPage({super.key});

  @override
  State<AddMasterAccountPage> createState() => _AddMasterAccountPageState();
}

class _AddMasterAccountPageState extends State<AddMasterAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _serviceNameController = TextEditingController();
  final _billingCostController = TextEditingController();
  final _maxSlotsController = TextEditingController(text: '4');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pinController = TextEditingController();

  String _selectedCurrency = 'XAF';
  DateTime _nextRenewalDate = DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    _serviceNameController.dispose();
    _billingCostController.dispose();
    _maxSlotsController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final double cost = double.tryParse(_billingCostController.text.trim()) ?? 0.0;
      final int maxSlots = int.tryParse(_maxSlotsController.text.trim()) ?? 4;
      final serviceName = _serviceNameController.text.trim();

      // Choisir une couleur selon le service
      String brandColor = '#059669';
      if (serviceName.toLowerCase().contains('netflix')) brandColor = '#E50914';
      if (serviceName.toLowerCase().contains('spotify')) brandColor = '#1DB954';
      if (serviceName.toLowerCase().contains('prime') || serviceName.toLowerCase().contains('amazon')) brandColor = '#00A8E1';
      if (serviceName.toLowerCase().contains('canva')) brandColor = '#00C4CC';
      if (serviceName.toLowerCase().contains('disney')) brandColor = '#113CCF';
      if (serviceName.toLowerCase().contains('youtube')) brandColor = '#FF0000';

      final accountData = {
        'serviceName': serviceName,
        'category': 'video',
        'brandColor': brandColor,
        'billingCost': cost,
        'billingCurrency': _selectedCurrency,
        'billingFrequency': 'monthly',
        'nextRenewalDate': _nextRenewalDate.toIso8601String(),
        'maxSlots': maxSlots,
        if (_emailController.text.trim().isNotEmpty) 'email': _emailController.text.trim(),
        if (_passwordController.text.trim().isNotEmpty) 'password': _passwordController.text.trim(),
        if (_pinController.text.trim().isNotEmpty) 'pin': _pinController.text.trim(),
      };

      Navigator.pop(context, accountData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Compte Maître'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informations du Service',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _serviceNameController,
                label: 'Nom du Service (ex: Netflix 4K, Spotify...)',
                validator: (v) => v?.isEmpty ?? true ? 'Ce champ est requis' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AppTextField(
                      controller: _billingCostController,
                      label: 'Coût payé par vous',
                      keyboardType: TextInputType.number,
                      validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCurrency,
                      decoration: const InputDecoration(
                        labelText: 'Devise',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'XAF', child: Text('XAF')),
                        DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                        DropdownMenuItem(value: 'USD', child: Text('USD')),
                      ],
                      onChanged: (v) => setState(() => _selectedCurrency = v ?? 'XAF'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _maxSlotsController,
                label: 'Nombre d\'écrans / slots maximum',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _nextRenewalDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() => _nextRenewalDate = picked);
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
                            'Date de votre prochain paiement fournisseur',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_nextRenewalDate.day.toString().padLeft(2, '0')}/${_nextRenewalDate.month.toString().padLeft(2, '0')}/${_nextRenewalDate.year}',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ],
                      ),
                      const Icon(Icons.calendar_today_rounded, size: 20, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Coffre-fort Sécurisé (Chiffré AES-256)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Vos accès sont stockés de manière chiffrée et restent privés.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _emailController,
                label: 'Email / Identifiant du compte',
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _passwordController,
                label: 'Mot de passe maître',
                isPassword: true,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _pinController,
                label: 'Code PIN principal (optionnel)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),

              AppButton(
                text: 'Enregistrer le compte',
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}