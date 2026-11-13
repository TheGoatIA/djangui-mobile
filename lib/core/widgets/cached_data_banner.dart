import 'package:flutter/material.dart';
import 'package:kauri/l10n/app_localizations.dart';
import '../../di/injection.dart';
import '../network/network_info.dart';

/// Small inline banner shown while the device is offline, on any screen
/// whose repository silently falls back to a locally-cached copy of the data
/// (tontines currently — see TontineRepositoryImpl.getTontines) instead of
/// surfacing an error. Without this, a stale cache reads identically to live
/// data with no way for the user to tell the two apart.
class CachedDataBanner extends StatelessWidget {
  const CachedDataBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: getIt<NetworkInfo>().onConnectivityChanged,
      builder: (context, snapshot) {
        final isOffline = snapshot.data == false;
        if (!isOffline) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.amber.shade700,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off, size: 16, color: Colors.white),
              SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.offlineCachedDataBanner,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
