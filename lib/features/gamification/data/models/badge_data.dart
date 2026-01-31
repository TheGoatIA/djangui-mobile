import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class BadgeData {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const BadgeData({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class BadgesData {
  static const Map<String, BadgeData> all = {
    'early_adopter': BadgeData(
      id: 'early_adopter',
      name: 'Pionnier',
      description: 'Membre fondateur de Kauri',
      icon: Icons.flag,
      color: AppColors.accent,
    ),
    'saver_lvl_1': BadgeData(
      id: 'saver_lvl_1',
      name: 'Économe Débutant',
      description: 'A épargné 10 000',
      icon: Icons.savings,
      color: AppColors.primary,
    ),
    'saver_lvl_2': BadgeData(
      id: 'saver_lvl_2',
      name: 'Économe Confirmé',
      description: 'A épargné 100 000',
      icon: Icons.account_balance_wallet,
      color: AppColors.primaryDark,
    ),
    'investor_lvl_1': BadgeData(
      id: 'investor_lvl_1',
      name: 'Investisseur Curieux',
      description: 'Premier investissement réalisé',
      icon: Icons.trending_up,
      color: AppColors.secondary,
    ),
    'social_butterfly': BadgeData(
      id: 'social_butterfly',
      name: 'Social',
      description: 'A invité 5 amis',
      icon: Icons.people,
      color: AppColors.info,
    ),
  };

  static BadgeData? get(String id) => all[id];
}
