import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_text_styles.dart';

/// Bouton avec protection contre le double-tap et les soumissions multiples.
///
/// Obligatoire sur TOUS les boutons de soumission de transaction :
///   - Envoi d'argent
///   - Confirmation de paiement
///   - Retrait / Dépôt
///   - Validation de formulaire financier
///
/// **Comportement** :
///   - Désactive le bouton immédiatement après le premier tap
///   - Attend la fin de [onPressed] (Future) avant de le réactiver
///   - Feedback haptique léger à la pression (bon signe pour l'UX financière)
///   - Affiche un [CircularProgressIndicator] pendant le traitement
///
/// **Usage** :
/// ```dart
/// DebouncedButton(
///   text: 'Confirmer le transfert',
///   onPressed: () async {
///     context.read<PaymentBloc>().add(ConfirmTransfer(...));
///     // attendre la completion si nécessaire
///   },
/// )
/// ```
class DebouncedButton extends StatefulWidget {
  /// Texte du bouton.
  final String text;

  /// Action asynchrone à exécuter. Le bouton reste désactivé jusqu'à la fin.
  final Future<void> Function() onPressed;

  /// Durée minimale entre deux appuis (protection supplémentaire).
  final Duration debounce;

  /// Couleur de fond optionnelle (utilise la couleur primaire du thème).
  final Color? color;

  /// Si vrai (défaut), le bouton prend toute la largeur disponible.
  final bool isFullWidth;

  const DebouncedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.debounce = const Duration(milliseconds: 800),
    this.color,
    this.isFullWidth = true,
  });

  @override
  State<DebouncedButton> createState() => _DebouncedButtonState();
}

class _DebouncedButtonState extends State<DebouncedButton>
    with SingleTickerProviderStateMixin {
  bool _isProcessing = false;
  DateTime? _lastPressTime;

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _handlePress() async {
    // Protection 1 : en cours de traitement
    if (_isProcessing) return;

    // Protection 2 : debounce temporel
    final now = DateTime.now();
    if (_lastPressTime != null &&
        now.difference(_lastPressTime!) < widget.debounce) {
      return;
    }
    _lastPressTime = now;

    // Feedback haptique — signal fort pour une action financière critique
    HapticFeedback.mediumImpact();

    if (!mounted) return;
    setState(() => _isProcessing = true);

    try {
      await widget.onPressed();
    } finally {
      // Toujours réactiver le bouton, même en cas d'erreur
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _onTapDown(TapDownDetails _) {
    if (!_isProcessing) _scaleController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _scaleController.reverse();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.color ?? Theme.of(context).colorScheme.primary;
    final onPrimaryColor = widget.color != null
        ? Colors.white
        : Theme.of(context).colorScheme.onPrimary;

    return GestureDetector(
      onTapDown: _isProcessing ? null : _onTapDown,
      onTapUp: _isProcessing ? null : _onTapUp,
      onTapCancel: _isProcessing ? null : _onTapCancel,
      onTap: _isProcessing ? null : _handlePress,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.isFullWidth ? double.infinity : null,
          height: 56,
          decoration: BoxDecoration(
            color: _isProcessing
                ? primaryColor.withValues(alpha: 0.7)
                : primaryColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: _isProcessing
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(onPrimaryColor),
                  ),
                )
              : Text(
                  widget.text,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: onPrimaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Variante : bouton avec icône et feedback haptique fort (erreur / succès)
// ─────────────────────────────────────────────────────────────────────────────

/// Feedback haptique sur les résultats d'actions financières.
///
/// À appeler dans le BLoC listener après la réponse de l'API.
/// ```dart
/// BlocListener<PaymentBloc, PaymentState>(
///   listener: (context, state) {
///     if (state is PaymentSuccess) {
///       FinancialHaptics.success();
///     } else if (state is PaymentError) {
///       FinancialHaptics.error();
///     }
///   },
/// )
/// ```
abstract final class FinancialHaptics {
  /// Vibration légère : confirmation positive (paiement réussi).
  static void success() => HapticFeedback.lightImpact();

  /// Double vibration : erreur ou action bloquée.
  static Future<void> error() async {
    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  /// Vibration de sélection : confirmation intermédiaire (étape validée).
  static void selection() => HapticFeedback.selectionClick();
}
