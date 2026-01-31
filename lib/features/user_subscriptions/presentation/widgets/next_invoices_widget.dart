import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_helper.dart';
import '../../../../l10n/app_localizations.dart';

import '../bloc/subscription_bloc.dart';

class NextInvoicesWidget extends StatefulWidget {
  const NextInvoicesWidget({super.key});

  @override
  State<NextInvoicesWidget> createState() => _NextInvoicesWidgetState();
}

class _NextInvoicesWidgetState extends State<NextInvoicesWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionBloc>().add(GetSubscriptionsRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const NextInvoicesView();
  }
}

class NextInvoicesView extends StatelessWidget {
  const NextInvoicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        if (state.status == SubscriptionStatus.loading &&
            state.subscriptions.isEmpty) {
          return const SizedBox.shrink();
        }

        if (state.subscriptions.isEmpty) {
          return const SizedBox.shrink();
        }

        // Sort by next billing date and take first 2
        final nextInvoices = List.from(state.subscriptions)
          ..sort((a, b) => a.nextBillingDate.compareTo(b.nextBillingDate));
        final displayedInvoices = nextInvoices.take(2).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.nextInvoices,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.push(RouteConstants.userSubscriptions),
                    child: Text(l10n.seeAll),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: displayedInvoices.length,
                itemBuilder: (context, index) {
                  final sub = displayedInvoices[index];
                  final daysLeft = sub.nextBillingDate
                      .difference(DateTime.now())
                      .inDays;
                  final currency = sub.currency;

                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                sub.name,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              CurrencyHelper.formatAmount(
                                sub.amount,
                                currencyCode: currency,
                              ),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          daysLeft <= 0 ? l10n.today : l10n.inDays(daysLeft),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: daysLeft <= 2
                                ? AppColors.error
                                : AppColors.textSecondary,
                            fontWeight: daysLeft <= 2
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        Text(
                          DateFormat.yMMMd(
                            Localizations.localeOf(context).toString(),
                          ).format(sub.nextBillingDate),
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
