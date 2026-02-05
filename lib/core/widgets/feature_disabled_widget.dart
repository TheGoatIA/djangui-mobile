import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_text_styles.dart';

class FeatureDisabledWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final bool isUpdateRequired;

  const FeatureDisabledWidget({
    super.key,
    this.title,
    this.message,
    this.isUpdateRequired = false,
  });

  Future<void> _launchStore() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final String packageName = packageInfo.packageName;

    // ID réel de l'App Store
    const String appId = "6757806640";

    final Uri playStoreUri = Uri.parse(
      'https://play.google.com/store/apps/details?id=$packageName',
    );
    final Uri appStoreUri = Uri.parse('https://apps.apple.com/app/id$appId');

    final Uri url = Platform.isAndroid ? playStoreUri : appStoreUri;

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(title ?? l10n.featureDisabledTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isUpdateRequired
                    ? Icons.system_update_outlined
                    : Icons.lock_clock_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 24),
              Text(
                title ?? l10n.featureDisabledTitle,
                style: AppTextStyles.h3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                isUpdateRequired
                    ? (message ?? l10n.featureUpdateRequiredMessage)
                    : (message ?? l10n.featureDisabledMessage),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (isUpdateRequired) {
                    _launchStore();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(isUpdateRequired ? l10n.updateNow : l10n.back),
              ),
              if (isUpdateRequired) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.back),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
