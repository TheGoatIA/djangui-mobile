import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../../data/models/session_model.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthGetSessionsRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.activeSessions),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<AuthBloc>().add(AuthGetSessionsRequested()),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.loading && state.sessions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.sessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.devices_outlined,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.noSessionsFound, style: AppTextStyles.bodyLarge),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<AuthBloc>().add(AuthGetSessionsRequested());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.sessions.length,
              itemBuilder: (context, index) {
                final session = state.sessions[index];
                return _buildSessionCard(session, l10n);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSessionCard(SessionModel session, AppLocalizations l10n) {
    final bool isCurrent = session.isCurrent ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCurrent
            ? const BorderSide(color: AppColors.primary, width: 1)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        ((session.os?.toLowerCase().contains('ios') ?? false) ||
                            (session.deviceName?.toLowerCase().contains(
                                  'iphone',
                                ) ??
                                false))
                        ? Colors.blue.withValues(alpha: 0.1)
                        : Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getDeviceIcon(session),
                    color:
                        ((session.os?.toLowerCase().contains('ios') ?? false) ||
                            (session.deviceName?.toLowerCase().contains(
                                  'iphone',
                                ) ??
                                false))
                        ? Colors.blue
                        : Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.deviceName ?? 'Unknown Device',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${session.os ?? 'Unknown OS'} • ${session.browser ?? session.ipAddress ?? ''}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      l10n.currentSession,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.lastActive,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      session.lastActive != null
                          ? DateFormat.yMMMd().add_jm().format(
                              session.lastActive!,
                            )
                          : 'Unknown',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
                if (session.location != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        l10n.location,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(session.location!, style: AppTextStyles.bodyMedium),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getDeviceIcon(SessionModel session) {
    final os = session.os?.toLowerCase() ?? '';
    final name = session.deviceName?.toLowerCase() ?? '';

    if (os.contains('ios') ||
        name.contains('iphone') ||
        name.contains('ipad')) {
      return Icons.phone_iphone;
    } else if (os.contains('android')) {
      return Icons.phone_android;
    } else if (os.contains('windows') ||
        os.contains('mac') ||
        os.contains('linux')) {
      return Icons.laptop;
    }
    return Icons.devices;
  }
}
