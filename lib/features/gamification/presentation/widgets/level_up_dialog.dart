import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_assets.dart'; // Ensure this exists or use strings

class LevelUpDialog extends StatelessWidget {
  final int newLevel;
  final VoidCallback onContinue;

  const LevelUpDialog({
    super.key,
    required this.newLevel,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40), // Space for animation
                Text(
                  'Félicitations !',
                  style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Vous avez atteint le',
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Niveau $newLevel',
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.accent,
                    fontSize: 48,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  'Continuez comme ça pour débloquer de nouveaux badges et fonctionnalités !',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continuer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Celebration Animation (Top)
          Positioned(
            top: -50,
            child: Lottie.asset(
              'assets/images/animations/success.json', // Adjust path
              width: 150,
              height: 150,
              repeat: false,
            ),
          ),
        ],
      ),
    );
  }
}
