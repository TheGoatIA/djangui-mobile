import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/notifications_bloc.dart';
import '../../data/models/notification_model.dart';
import '../widgets/notification_item.dart';

import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('fr', FrMessages());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsBloc>().add(
        const FetchNotificationsRequested(refresh: true),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: Colors.transparent),
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
                    _showNotificationDetail(context, notification);
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
    );
  }

  void _showNotificationDetail(
    BuildContext context,
    NotificationModel notification,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                timeago.format(
                  notification.createdAt,
                  locale: Localizations.localeOf(context).languageCode,
                ),
                style: AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Text(notification.body, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class FrMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => 'il y a';
  @override
  String prefixFromNow() => "dans";
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => "moins d'une minute";
  @override
  String aboutAMinute(int minutes) => "environ une minute";
  @override
  String minutes(int minutes) => "environ $minutes minutes";
  @override
  String aboutAnHour(int minutes) => "environ une heure";
  @override
  String hours(int hours) => "environ $hours heures";
  @override
  String aDay(int hours) => "environ un jour";
  @override
  String days(int days) => "environ $days jours";
  @override
  String aboutAMonth(int days) => "environ un mois";
  @override
  String months(int months) => "environ $months mois";
  @override
  String aboutAYear(int year) => "environ un an";
  @override
  String years(int years) => "environ $years ans";
  @override
  String wordSeparator() => " ";
}
