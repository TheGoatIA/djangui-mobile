import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SuccessAnimationService {
  late ConfettiController _confettiController;

  SuccessAnimationService() {
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  ConfettiController get confettiController => _confettiController;

  void showSuccess() {
    _confettiController.play();
  }

  void dispose() {
    _confettiController.dispose();
  }

  Widget buildConfettiWidget() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple,
          Color(0xFFD4AF37), // Gold
        ],
      ),
    );
  }
}
