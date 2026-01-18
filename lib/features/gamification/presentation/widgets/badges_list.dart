import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/data/models/badge_model.dart';
import '../../data/models/badge_data.dart';

class BadgesList extends StatelessWidget {
  final List<BadgeModel> badges;

  const BadgesList({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            'Badges (${badges.length})',
            style: AppTextStyles.h3.copyWith(fontSize: 18),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: badges.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final badgeModel = badges[index];
              // Try to find in catalog by icon/id or by name
              final badgeData =
                  BadgesData.get(badgeModel.icon) ??
                  BadgesData.get(badgeModel.name);

              final String name = badgeData?.name ?? badgeModel.name;
              final String description =
                  badgeData?.description ?? badgeModel.name;
              final IconData icon = badgeData?.icon ?? Icons.stars;
              final Color color = badgeData?.color ?? AppColors.primary;
              final themedColor = _getThemedColor(context, color);

              return Tooltip(
                message: description,
                triggerMode: TooltipTriggerMode.tap,
                child: Container(
                  width: 80,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).shadowColor.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: themedColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: themedColor, size: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getThemedColor(BuildContext context, Color color) {
    final colorScheme = Theme.of(context).colorScheme;
    if (color == AppColors.primary) return colorScheme.primary;
    if (color == AppColors.secondary) return colorScheme.secondary;
    if (color == AppColors.accent) return colorScheme.tertiary;
    return color;
  }
}
