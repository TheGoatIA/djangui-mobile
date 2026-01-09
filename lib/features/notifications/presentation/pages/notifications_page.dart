import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/notifications_bloc.dart';
import '../widgets/notification_item.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    // Initialize timeago locales if needed, focusing on French for now as example
    // In a real app with multiple languages, you might want to load this dynamically based on current locale
    // However, timeago includes 'fr' messages by default but not loaded, or we use setLocaleMessages
    // The standard timeago package includes 'en' and 'en_short'. To use others:
    // timeago.setLocaleMessages('fr', timeago.FrMessages());
    // Since we don't know if 'timeago' package exports FrMessages directly without importing specific file,
    // we'll try basic setup. If imports are needed, we assume build_runner would have failed or analysis would show.
    // Actually, usually: import 'package:timeago/timeago.dart' as timeago;
    // timeago.setLocaleMessages('fr', timeago.FrMessages());  <-- FrMessages needs import 'package:timeago/src/messages/fr_messages.dart' (if visible)
    // or typically the package exports them. Let's assume standard usage.
    // Wait, standard usage often requires importing the message file.
    // ex: import 'package:timeago/src/messages/fr_messages.dart' as fr_messages;
    // then: timeago.setLocaleMessages('fr', fr_messages.FrMessages());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<NotificationsBloc>()
            ..add(const FetchNotificationsRequested(refresh: true)),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.notifications),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            BlocBuilder<NotificationsBloc, NotificationsState>(
              builder: (context, state) {
                if (state.notifications.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.done_all),
                  tooltip: AppLocalizations.of(context)!.markAllAsRead,
                  onPressed: () {
                    context.read<NotificationsBloc>().add(
                      MarkAllNotificationsAsReadRequested(),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state.status == NotificationsStatus.loading &&
                state.notifications.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == NotificationsStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ??
                          AppLocalizations.of(context)!.unknownError,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<NotificationsBloc>().add(
                        const FetchNotificationsRequested(refresh: true),
                      ),
                      child: Text(AppLocalizations.of(context)!.retry),
                    ),
                  ],
                ),
              );
            }

            if (state.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 64,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.noNotifications,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<NotificationsBloc>().add(
                  const FetchNotificationsRequested(refresh: true),
                );
              },
              child: ListView.separated(
                itemCount:
                    state.notifications.length + (state.hasReachedMax ? 0 : 1),
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  if (index >= state.notifications.length) {
                    context.read<NotificationsBloc>().add(
                      const FetchNotificationsRequested(),
                    );
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final notification = state.notifications[index];
                  return NotificationItem(
                    notification: notification,
                    onTap: () {
                      if (!notification.isRead) {
                        context.read<NotificationsBloc>().add(
                          MarkNotificationAsReadRequested(notification.id),
                        );
                      }
                      // Handle deep linking or navigation based on notification.data if needed
                    },
                    onDelete: () {
                      context.read<NotificationsBloc>().add(
                        DeleteNotificationRequested(notification.id),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
