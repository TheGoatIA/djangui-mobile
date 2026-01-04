import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

Page<dynamic> buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomPageTransition(key: state.pageKey, child: child);
}
