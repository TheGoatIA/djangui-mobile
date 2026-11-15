import 'package:flutter/material.dart';
import 'package:kauri/l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_text_styles.dart';

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
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.2),
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
                  AppLocalizations.of(context)!.congratulations,
                  style: AppTextStyles.h2.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.levelUpReached,
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  AppLocalizations.of(context)!.levelNumber(newLevel),
                  style: AppTextStyles.h1.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 48,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.levelUpKeepGoing,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onContinue,
                    child: Text(
                      AppLocalizations.of(context)!.continueAction,
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
