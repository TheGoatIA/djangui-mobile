import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../l10n/app_localizations.dart';
import '../app_button.dart';
import '../glass_card.dart';
import 'tutorial_step.dart';

/// Insère/retire l'overlay de tutoriel dans l'`Overlay` racine de l'app.
///
/// Remplace `ShowCaseWidget` : aucun widget wrapper n'est nécessaire dans
/// `main.dart`, l'overlay est monté/démonté à la demande via [show]/[hide].
class TutorialOverlayController {
  static OverlayEntry? _entry;

  static bool get isShowing => _entry != null;

  static void show(
    BuildContext context, {
    required List<TutorialStep> steps,
    required VoidCallback onFinish,
    required VoidCallback onSkip,
  }) {
    hide();
    if (steps.isEmpty) return;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _TutorialOverlayView(
        steps: steps,
        onFinish: () {
          hide();
          onFinish();
        },
        onSkip: () {
          hide();
          onSkip();
        },
      ),
    );
    _entry = entry;
    Overlay.of(context, rootOverlay: true).insert(entry);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

class _TutorialOverlayView extends StatefulWidget {
  final List<TutorialStep> steps;
  final VoidCallback onFinish;
  final VoidCallback onSkip;

  const _TutorialOverlayView({
    required this.steps,
    required this.onFinish,
    required this.onSkip,
  });

  @override
  State<_TutorialOverlayView> createState() => _TutorialOverlayViewState();
}

class _TutorialOverlayViewState extends State<_TutorialOverlayView> {
  int _index = 0;
  Rect? _rect;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  Future<void> _measure() async {
    final step = widget.steps[_index];
    final ctx = step.targetKey.currentContext;
    if (ctx == null) {
      // La cible n'est pas (ou plus) montée : on ne peut pas bloquer le
      // tutoriel indéfiniment sur une étape impossible à afficher.
      _advance();
      return;
    }

    try {
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        alignment: 0.5,
      );
    } catch (_) {
      // Pas de Scrollable ancêtre — rien à faire, la cible est déjà visible.
    }
    if (!mounted || !ctx.mounted) return;

    final renderBox = ctx.findRenderObject();
    if (renderBox is! RenderBox || !renderBox.attached) {
      _advance();
      return;
    }
    final topLeft = renderBox.localToGlobal(Offset.zero);
    final raw = topLeft & renderBox.size;
    final padding = step.targetPadding;
    final padded = Rect.fromLTRB(
      raw.left - padding.left,
      raw.top - padding.top,
      raw.right + padding.right,
      raw.bottom + padding.bottom,
    );

    setState(() => _rect = padded);
  }

  void _advance() {
    if (_index >= widget.steps.length - 1) {
      widget.onFinish();
      return;
    }
    setState(() => _index++);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_index];
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final screen = MediaQuery.sizeOf(context);
    final rect = _rect;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Voile + découpe animée — absorbe les taps pour forcer l'usage
          // des contrôles Passer/Suivant plutôt qu'une interaction directe
          // avec l'écran pendant le tutoriel.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              // TweenAnimationBuilder rejette un Tween dont `end` est null —
              // tant que la toute première mesure n'est pas encore
              // disponible, on affiche un simple voile plein, sans découpe.
              child: rect == null
                  ? Container(color: Colors.black.withValues(alpha: 0.75))
                  : TweenAnimationBuilder<Rect?>(
                      tween: RectTween(begin: rect, end: rect),
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeOutCubic,
                      builder: (context, animatedRect, _) {
                        return CustomPaint(
                          size: screen,
                          painter: _SpotlightPainter(
                            rect: animatedRect ?? rect,
                            shape: step.shape,
                            glowColor: accent,
                          ),
                        );
                      },
                    ),
            ),
          ),
          // Halo pulsant sur le contour de la cible.
          if (rect != null)
            TweenAnimationBuilder<Rect?>(
              tween: RectTween(begin: rect, end: rect),
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutCubic,
              builder: (context, animatedRect, _) {
                final r = animatedRect ?? rect;
                return Positioned(
                  left: r.left,
                  top: r.top,
                  width: r.width,
                  height: r.height,
                  child: IgnorePointer(
                    child:
                        DecoratedBox(
                              decoration: ShapeDecoration(
                                shape: step.shape is CircleBorder
                                    ? CircleBorder(
                                        side: BorderSide(
                                          color: accent,
                                          width: 2,
                                        ),
                                      )
                                    : RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                        side: BorderSide(
                                          color: accent,
                                          width: 2,
                                        ),
                                      ),
                              ),
                            )
                            .animate(
                              key: ValueKey('glow_$_index'),
                              onPlay: (c) => c.repeat(reverse: true),
                            )
                            .scaleXY(
                              begin: 1,
                              end: 1.04,
                              duration: 1200.ms,
                              curve: Curves.easeInOut,
                            )
                            .fadeIn(duration: 300.ms),
                  ),
                );
              },
            ),
          // Carte d'explication.
          if (rect != null)
            _TutorialTooltip(
              key: ValueKey('tooltip_$_index'),
              targetRect: rect,
              screenSize: screen,
              step: step,
              stepIndex: _index,
              stepCount: widget.steps.length,
              onNext: _advance,
              onSkip: widget.onSkip,
            ),
        ],
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Rect rect;
  final ShapeBorder shape;
  final Color glowColor;

  _SpotlightPainter({
    required this.rect,
    required this.shape,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final full = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final hole = shape.getOuterPath(rect);
    final barrier = Path.combine(PathOperation.difference, full, hole);

    canvas.drawPath(
      barrier,
      Paint()..color = Colors.black.withValues(alpha: 0.75),
    );

    // Halo doux vers l'extérieur de la découpe, dans la couleur d'accent du thème.
    final glowPaint = Paint()
      ..color = glowColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10);
    canvas.drawPath(hole, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) =>
      oldDelegate.rect != rect || oldDelegate.glowColor != glowColor;
}

class _TutorialTooltip extends StatelessWidget {
  final Rect targetRect;
  final Size screenSize;
  final TutorialStep step;
  final int stepIndex;
  final int stepCount;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _TutorialTooltip({
    super.key,
    required this.targetRect,
    required this.screenSize,
    required this.step,
    required this.stepIndex,
    required this.stepCount,
    required this.onNext,
    required this.onSkip,
  });

  static const double _cardWidth = 300;
  static const double _margin = 20;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;
    final isLast = stepIndex == stepCount - 1;

    // Une cible peut dépasser largement l'écran (ex: toute une section de
    // réglages plus haute que le viewport) — on raisonne sur ses bords
    // rognés à l'écran plutôt que sur le rect brut, sinon le calcul
    // "au-dessus/en-dessous" peut produire une position hors-écran et
    // rendre les boutons Passer/Suivant inatteignables (bug constaté sur
    // la section Réglages de la page Profil).
    final clampedTargetTop = targetRect.top.clamp(0.0, screenSize.height);
    final clampedTargetBottom = targetRect.bottom.clamp(0.0, screenSize.height);
    final spaceBelow = screenSize.height - clampedTargetBottom;
    final spaceAbove = clampedTargetTop;
    final placeBelow = spaceBelow >= 220 || spaceBelow >= spaceAbove;

    final left = (targetRect.center.dx - _cardWidth / 2).clamp(
      _margin,
      screenSize.width - _cardWidth - _margin,
    );

    final card = GlassCard(
      borderRadius: 22,
      opacity: theme.brightness == Brightness.dark ? 0.14 : 0.85,
      color: theme.brightness == Brightness.dark
          ? theme.colorScheme.surface
          : Colors.white,
      border: Border.all(color: accent.withValues(alpha: 0.35), width: 1),
      padding: EdgeInsets.zero,
      child: Container(
        width: _cardWidth,
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [accent.withValues(alpha: 0.16), Colors.transparent],
            stops: const [0, 0.35],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 14),
            // Bandeau dégradé signature Kauri en tête de carte.
            Container(
              height: 3,
              width: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent, theme.colorScheme.secondary],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              step.title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              step.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: List.generate(stepCount, (i) {
                final active = i == stepIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.only(right: 6),
                  height: 6,
                  width: active ? 20 : 6,
                  decoration: BoxDecoration(
                    color: active ? accent : accent.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: onSkip,
                  child: Text(
                    l10n.skip,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AppButton(
                  text: isLast ? l10n.tutorialFinish : l10n.next,
                  isFullWidth: false,
                  onPressed: onNext,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // Toujours positionné via `top`, borné dans une zone où la carte tient
    // entièrement à l'écran — plutôt que de deviner "au-dessus" via `bottom`
    // (ce qui laissait le titre grandir vers le haut sans limite et pouvait
    // pousser les boutons hors-écran quand la cible était très grande).
    final mq = MediaQuery.of(context);
    const marginV = 24.0;
    const estimatedCardHeight = 340.0;
    final safeTop = mq.padding.top + marginV;
    final safeBottom = screenSize.height - mq.padding.bottom - marginV;
    final maxTop = (safeBottom - estimatedCardHeight).clamp(
      safeTop,
      safeBottom,
    );

    final desiredTop = placeBelow
        ? clampedTargetBottom + 16
        : clampedTargetTop - 16 - estimatedCardHeight;
    final top = desiredTop.clamp(safeTop, maxTop);

    return AnimatedPositioned(
      key: key,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      left: left,
      top: top,
      child: ConstrainedBox(
        // Filet de sécurité si l'estimation ci-dessus s'avérait trop
        // optimiste (texte localisé exceptionnellement long) : la carte
        // défile plutôt que de déborder de l'écran.
        constraints: BoxConstraints(maxHeight: safeBottom - safeTop),
        child: SingleChildScrollView(
          child: card
              .animate(key: ValueKey('tooltip_anim_$stepIndex'))
              .fadeIn(duration: 320.ms, curve: Curves.easeOut)
              .scaleXY(
                begin: 0.94,
                end: 1,
                duration: 380.ms,
                curve: Curves.easeOutBack,
              ),
        ),
      ),
    );
  }
}
