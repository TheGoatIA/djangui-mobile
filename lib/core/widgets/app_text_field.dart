import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// Champ de saisie standardisé pour l'application.
///
/// Inclut un libellé au-dessus du champ ([label]), des icônes optionnelles,
/// et gère le masquage automatique pour les mots de passe.
class AppTextField extends StatelessWidget {
  /// Libellé affiché au-dessus du champ.
  final String label;

  /// Texte d'aide à l'intérieur du champ.
  final String? hint;

  /// Texte d'aide affiché sous le champ.
  final String? helperText;

  /// Contrôleur gérant la valeur textuelle.
  final TextEditingController controller;

  /// Si vrai, masque le texte (pour les mots de passe).
  final bool isPassword;

  /// Type de clavier (numérique, email, etc.).
  final TextInputType keyboardType;

  /// Icône affichée au début du champ.
  final IconData? prefixIcon;

  /// Widget optionnel affiché à la fin du champ (ex: bouton de visibilité).
  final Widget? suffix;

  /// Nombre maximum de lignes.
  final int maxLines;

  /// Alignement du texte.
  final TextAlign textAlign;

  /// Active les suggestions du clavier (désactivé par défaut pour les mots de passe)
  final bool? enableSuggestions;

  /// Active l'autocorrection (désactivé par défaut pour les mots de passe)
  final bool? autocorrect;

  /// Fonction de validation des données.
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.helperText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffix,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.enableSuggestions,
    this.autocorrect,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          enableSuggestions: enableSuggestions ?? !isPassword,
          autocorrect: autocorrect ?? !isPassword,
          maxLines: maxLines,
          textAlign: textAlign,
          validator: validator,
          decoration: InputDecoration(
            helperText: helperText,
            helperMaxLines: 2,
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
            suffixIcon: suffix != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [suffix!],
                    ),
                  )
                : null,
            filled: true,
            fillColor: Theme.of(context).inputDecorationTheme.fillColor,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
