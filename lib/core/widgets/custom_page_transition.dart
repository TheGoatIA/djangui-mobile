import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Définit une transition personnalisée entre les pages combinant un fondu (Fade)
/// et un léger glissement (Slide) pour une navigation fluide.
class CustomPageTransition extends CustomTransitionPage {
  CustomPageTransition({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    super.transitionDuration = const Duration(milliseconds: 300),
    super.reverseTransitionDuration = const Duration(milliseconds: 300),
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: CurveTween(curve: Curves.easeIn).animate(animation),
             child: SlideTransition(
               position:
                   Tween<Offset>(
                     begin: const Offset(0.05, 0),
                     end: Offset.zero,
                   ).animate(
                     CurvedAnimation(
                       parent: animation,
                       curve: Curves.easeOutQuad,
                     ),
                   ),
               child: child,
             ),
           );
         },
       );
}

/// Helper pour GoRouter permettant d'appliquer la transition par défaut de Kauri à une route.
Page<dynamic> buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomPageTransition(key: state.pageKey, child: child);
}
