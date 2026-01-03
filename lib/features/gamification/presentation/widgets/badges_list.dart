import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/badge_data.dart';

class BadgesList extends StatelessWidget {
  final List<String> badgeIds;

  const BadgesList({super.key, required this.badgeIds});

  @override
  Widget build(BuildContext context) {
    if (badgeIds.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            'Badges (${badgeIds.length})',
            style: AppTextStyles.h3.copyWith(fontSize: 18),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: badgeIds.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final badgeId = badgeIds[index];
              final badge = BadgesData.get(badgeId);

              if (badge == null) return const SizedBox.shrink();

              return Tooltip(
                message: badge.description,
                triggerMode: TooltipTriggerMode.tap,
                child: Container(
                  width: 80,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
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
                          color: badge.color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(badge.icon, color: badge.color, size: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        badge.name,
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
}
