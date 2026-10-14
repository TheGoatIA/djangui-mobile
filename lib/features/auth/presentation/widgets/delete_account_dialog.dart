import 'package:flutter/material.dart';
import 'package:kauri/l10n/app_localizations.dart';

/// Boîte de dialogue de suppression de compte.
///
/// Redemande le mot de passe (ré-authentification : l'API refuse la suppression d'un compte à
/// mot de passe sans lui — un jeton volé ne suffit pas). Retourne le mot de passe saisi via
/// `Navigator.pop`, ou `null` si l'utilisateur annule.
class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(l10n.deleteAccount, style: TextStyle(color: scheme.error)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.deleteAccountDescription),
          const SizedBox(height: 16),
          TextField(
            key: const Key('delete_account_password'),
            controller: _password,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: l10n.password,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          key: const Key('delete_account_cancel'),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          key: const Key('delete_account_confirm'),
          onPressed: () => Navigator.of(context).pop(_password.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: scheme.error,
            foregroundColor: scheme.onError,
          ),
          child: Text(l10n.delete),
        ),
      ],
    );
  }
}
