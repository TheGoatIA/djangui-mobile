import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Widget affichant la progression de l'utilisateur (niveau et XP).
///
/// Ce composant calcule dynamiquement le niveau actuel et l'expérience nécessaire
/// pour le prochain niveau selon une formule quadratique.
class GamificationHeader extends StatelessWidget {
  const GamificationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // N'affiche rien si l'utilisateur n'est pas authentifié
        if (state.status != AuthStatus.authenticated ||
            state.authResponse?.user == null) {
          return const SizedBox.shrink();
        }

        final user = state.authResponse!.user;
        final currentXp = user.xp;
        final currentLevel = user.level;

        // Formules utilisées :
        // Niveau = floor(sqrt(XP / 100)) + 1
        // XP pour le prochain niveau = (Niveau actu)^2 * 100
        final nextLevelXp = (currentLevel * currentLevel) * 100;
        final prevLevelXp = ((currentLevel - 1) * (currentLevel - 1)) * 100;

        // Calcul de la progression relative au sein du niveau actuel (entre 0.0 et 1.0)
        final levelProgress =
            (currentXp - prevLevelXp) / (nextLevelXp - prevLevelXp);

        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Badge circulaire affichant le numéro du niveau
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$currentLevel',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Section affichant les détails de l'XP et la barre de progression
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.levelLabel(currentLevel),
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '$currentXp / $nextLevelXp XP',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Barre de progression visuelle de l'XP
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: levelProgress.clamp(0.0, 1.0),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Indication de l'XP restante avant le prochain palier
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.xpToNextLevel(nextLevelXp - currentXp),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
