import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppIconService {
  Future<bool> isSupported() async {
    try {
      // iOS supports it, Android depends on manifest configuration
      if (Platform.isIOS) {
        return await FlutterDynamicIconPlus.supportsAlternateIcons;
      }
      return true; // Assume supported on Android if aliases are configured
    } on PlatformException {
      return false;
    }
  }

  Future<void> changeIcon(String? iconName) async {
    try {
      if (await isSupported()) {
        String? targetIcon = iconName;

        // Android requires the full class name of the activity-alias
        if (Platform.isAndroid && iconName != null) {
          final suffix = iconName[0].toUpperCase() + iconName.substring(1);
          targetIcon = "cm.tbg.kauri.MainActivity$suffix";
        }

        debugPrint("Changing icon to: $targetIcon");
        await FlutterDynamicIconPlus.setAlternateIconName(iconName: targetIcon);
        debugPrint("Icon change requested successfully");
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to change app icon: ${e.message}");
      rethrow;
    }
  }

  Future<String?> getCurrentIcon() async {
    try {
      final icon = await FlutterDynamicIconPlus.alternateIconName;
      debugPrint("🔍 DEBUG: Raw icon from system = '$icon'");

      if (Platform.isAndroid && icon != null) {
        if (icon.endsWith('MainActivityGold')) return 'gold';
        if (icon.endsWith('MainActivityDark')) return 'dark';
      }

      return icon;
    } on PlatformException catch (e) {
      debugPrint("❌ DEBUG: Error getting icon: $e");
      return null;
    }
  }
}
