import 'package:flutter/material.dart';
import '../config/env_config.dart';

/// Wraps [child] with a corner ribbon identifying the build's environment:
/// red "DEV" in development, orange "STAGING" in staging, nothing in
/// production. Lets anyone glance at a device and immediately tell it apart
/// from a real customer's production install — important once real-money
/// mode can be live, to avoid ever confusing a test/demo device with one
/// actually moving real funds.
class EnvironmentBanner extends StatelessWidget {
  final Widget child;

  const EnvironmentBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final (String label, Color color)? env = switch (EnvConfig.env) {
      'staging' => ('STAGING', Colors.orange),
      'production' => null,
      // Anything else (development, or an unrecognized/unset ENV) is treated
      // as dev — fail loud rather than silently looking like production.
      _ => ('DEV', Colors.red),
    };

    if (env == null) return child;

    return Banner(
      message: env.$1,
      location: BannerLocation.topEnd,
      color: env.$2,
      child: child,
    );
  }
}
