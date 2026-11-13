import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../../../../di/injection.dart';
import '../../../../core/services/log_service.dart';
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
    getIt<LogService>().info(
      'Affichage de la page des sessions.',
      component: 'SessionsPage',
    );
    context.read<AuthBloc>().add(AuthGetSessionsRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.sessionRevoked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.sessionRevoked),
              backgroundColor: AppColors.success,
            ),
          );
        } else if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? l10n.genericError),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(l10n.activeSessions),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                getIt<LogService>().info(
                  'Rafraîchissement manuel des sessions',
                  component: 'SessionsPage',
                );
                context.read<AuthBloc>().add(AuthGetSessionsRequested());
              },
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
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.noSessionsFound, style: AppTextStyles.bodyLarge),
                  ],
                ),
              );
            }

            final currentSession = state.sessions.firstWhere(
              (s) => s.isCurrent ?? false,
              orElse: () => state.sessions.first,
            );
            final otherSessions = state.sessions
                .where((s) => !(s.isCurrent ?? false))
                .toList();

            return RefreshIndicator(
              onRefresh: () async {
                context.read<AuthBloc>().add(AuthGetSessionsRequested());
              },
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  if (otherSessions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _confirmRevokeAll(context),
                          icon: Icon(
                            Icons.delete_sweep,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          label: Text(
                            l10n.revokeAllSessions,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                  Text(
                    l10n.currentSession,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSessionCard(currentSession, l10n, isCurrent: true),
                  if (otherSessions.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      l10n.activeSessions,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...otherSessions.map(
                      (session) =>
                          _buildSessionCard(session, l10n, isCurrent: false),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSessionCard(
    SessionModel session,
    AppLocalizations l10n, {
    required bool isCurrent,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCurrent
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 1)
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
                        ? AppColors.info.withValues(alpha: 0.1)
                        : AppColors.success.withValues(alpha: 0.1),
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
                        ? AppColors.info
                        : AppColors.success,
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
                        '${session.os ?? AppLocalizations.of(context)!.unknownDevice} • ${session.browser ?? session.ipAddress ?? ''}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isCurrent)
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error,
                      size: 20,
                    ),
                    onPressed: () => _confirmRevokeSession(context, session),
                    tooltip: l10n.revokeSession,
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
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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

  void _confirmRevokeSession(BuildContext context, SessionModel session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.revokeSession),
        content: Text(AppLocalizations.of(context)!.confirmRevokeSession),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              if (session.id != null) {
                getIt<LogService>().info(
                  'Action: Révocation de la session ${session.id}',
                  component: 'SessionsPage',
                );
                context.read<AuthBloc>().add(
                  AuthRevokeSessionRequested(session.id!),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );
  }

  void _confirmRevokeAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.revokeAllSessions),
        content: Text(AppLocalizations.of(context)!.confirmRevokeAllSessions),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              getIt<LogService>().info(
                'Action: Révocation de toutes les sessions',
                component: 'SessionsPage',
              );
              context.read<AuthBloc>().add(AuthRevokeAllSessionsRequested());
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );
  }
}
