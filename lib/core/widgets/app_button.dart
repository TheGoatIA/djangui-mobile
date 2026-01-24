import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// Bouton principal personnalisé utilisé dans toute l'application.
///
/// Ce bouton intègre un état de chargement ([isLoading]), une option de largeur
/// complète ([isFullWidth]) et une animation d'échelle au toucher.
class AppButton extends StatelessWidget {
  /// Texte à afficher dans le bouton.
  final String text;

  /// Action à exécuter lors du clic.
  final VoidCallback onPressed;

  /// Si vrai, affiche un indicateur de progression à la place du texte.
  final bool isLoading;

  /// Si vrai (par défaut), le bouton prend toute la largeur disponible.
  final bool isFullWidth;

  /// Couleur de fond optionnelle (utilise la couleur primaire du thème par défaut).
  final Color? color;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Calcul des couleurs en fonction du thème ou de la propriété [color]
    final primaryColor = color ?? Theme.of(context).colorScheme.primary;
    final onPrimaryColor = color != null
        ? Colors.white
        : Theme.of(context).colorScheme.onPrimary;

    return _ScaleButton(
      onPressed: isLoading ? null : onPressed,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        height: 56,
        decoration: BoxDecoration(
          color: isLoading ? primaryColor.withValues(alpha: 0.7) : primaryColor,
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
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(onPrimaryColor),
                ),
              )
            : Text(
                text,
                style: AppTextStyles.labelLarge.copyWith(
                  color: onPrimaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}

/// Widget enveloppant le bouton pour lui ajouter une animation de rétrécissement (scale) au toucher.
class _ScaleButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const _ScaleButton({required this.child, this.onPressed});

  @override
  State<_ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<_ScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null) _controller.reverse();
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    if (widget.onPressed != null) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
