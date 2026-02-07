import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:kauri/l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/tontine_bloc.dart';
import '../bloc/tontine_event.dart';
import '../bloc/tontine_state.dart';
import '../widgets/contribution_dialog.dart';
import '../widgets/tontine_chat_tab.dart';
import '../../domain/entities/tontine_entities.dart';
import './create_tontine_page.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../di/injection.dart';
import '../../../../core/services/share_service.dart';
import 'package:kauri/features/analytics/presentation/manager/analytics_manager.dart';
import '../../../system/presentation/bloc/system_bloc.dart';
import '../../../../core/widgets/feature_disabled_widget.dart';

class TontineDetailsPage extends StatefulWidget {
  final String tontineId;
  const TontineDetailsPage({super.key, required this.tontineId});

  @override
  State<TontineDetailsPage> createState() => _TontineDetailsPageState();
}

class _TontineDetailsPageState extends State<TontineDetailsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  int _currentIndex = 0;
  bool _isLoadingDialogShowing = false;
  String _validationFilter = 'pending';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);

    context.read<TontineBloc>().add(
      TontineDetailsLoadRequested(widget.tontineId),
    );
    context.read<TontineBloc>().add(
      TontineContributionsLoadRequested(widget.tontineId),
    );
    getIt<AnalyticsManager>().trackEvent(
      feature: 'Tontine',
      action: 'view_details',
      details: {'tontine_id': widget.tontineId},
    );
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging ||
        _tabController.index != _currentIndex) {
      setState(() {
        _currentIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<SystemBloc, SystemState>(
      builder: (context, systemState) {
        final featureStatus = context.read<SystemBloc>().getFeatureStatus(
          systemState.featureFlags.featTontines,
        );

        if (featureStatus == FeatureStatus.disabled) {
          return Scaffold(body: FeatureDisabledWidget(title: l10n.tontine));
        }

        if (featureStatus == FeatureStatus.updateRequired) {
          return Scaffold(
            body: FeatureDisabledWidget(
              title: l10n.tontine,
              isUpdateRequired: true,
            ),
          );
        }

        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            final currentUserId = authState.authResponse?.user.id;

            return BlocConsumer<TontineBloc, TontineState>(
              listener: (context, state) {
                if (state.status == TontineStatus.loading &&
                    state.selectedTontine != null) {
                  if (!_isLoadingDialogShowing) {
                    _isLoadingDialogShowing = true;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    ).then((_) => _isLoadingDialogShowing = false);
                  }
                } else if (_isLoadingDialogShowing) {
                  Navigator.of(context).pop();
                  _isLoadingDialogShowing = false;

                  if (state.status == TontineStatus.success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.operationSuccess),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // Reload contributions to update UI
                    if (state.selectedTontine != null) {
                      context.read<TontineBloc>().add(
                        TontineContributionsLoadRequested(
                          state.selectedTontine!.id,
                        ),
                      );
                    }
                  }
                }

                if (state.status == TontineStatus.error) {
                  String message = state.errorMessage ?? l10n.genericError;
                  if (message.contains('E11000') ||
                      message.contains('duplicate key')) {
                    message = l10n.alreadyContributed;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.status == TontineStatus.loading &&
                    state.selectedTontine == null) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                final tontine = state.selectedTontine;
                if (tontine == null) {
                  return Scaffold(
                    appBar: AppBar(),
                    body: Center(child: Text(l10n.genericError)),
                  );
                }

                final isCreator = tontine.creatorId == currentUserId;
                final tabCount = isCreator ? 4 : 3;

                if (_tabController.length != tabCount) {
                  _tabController.removeListener(_handleTabSelection);
                  _tabController.dispose();
                  _tabController = TabController(length: tabCount, vsync: this);
                  _tabController.addListener(_handleTabSelection);
                }

                return Scaffold(
                  appBar: AppBar(
                    title: Text(tontine.name),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.share_outlined),
                        onPressed: () => _shareInvite(tontine.inviteCode),
                      ),
                      if (isCreator &&
                          tontine.status.toLowerCase() == 'pending')
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CreateTontinePage(tontine: tontine),
                            ),
                          ),
                        ),
                      if (isCreator &&
                          tontine.status.toLowerCase() != 'completed')
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () =>
                              _confirmDeleteTontine(context, tontine),
                        ),
                    ],
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(60),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          tabAlignment: TabAlignment.center,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Theme.of(context).colorScheme.primary,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          overlayColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                          tabs: [
                            Tab(text: l10n.dashboard),
                            Tab(text: l10n.members),
                            Tab(text: l10n.chat),
                            if (isCreator) Tab(text: l10n.validation),
                          ],
                        ),
                      ),
                    ),
                  ),
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOverviewTab(
                        context,
                        tontine,
                        state.selectedTontineContributions
                            .where((c) => c.tontineId == widget.tontineId)
                            .toList(),
                        state.selectedTontineMembers,
                      ),
                      _buildMembersTab(
                        context,
                        state.selectedTontineMembers,
                        isCreator,
                        tontine.status.toLowerCase() != 'completed',
                        tontine.id,
                      ),
                      _buildChatTab(context, tontine.id),
                      if (isCreator)
                        _buildValidationTab(
                          context,
                          state.selectedTontineContributions
                              .where((c) => c.tontineId == widget.tontineId)
                              .toList(),
                          state.selectedTontineMembers,
                        ),
                    ],
                  ),
                  floatingActionButton:
                      _currentIndex == 2 ||
                          tontine.status.toLowerCase() == 'completed' ||
                          tontine.status.toLowerCase().contains('suspended')
                      ? null
                      : FloatingActionButton.extended(
                          onPressed: () =>
                              _showContributionDialog(context, tontine.id),
                          label: Text(l10n.contribute),
                          icon: const Icon(Icons.add_a_photo_outlined),
                        ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildOverviewTab(
    BuildContext context,
    dynamic tontine,
    List<dynamic> contributions,
    List<TontineMember> members,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final isCreator =
        tontine.creatorId ==
        context.read<AuthBloc>().state.authResponse?.user.id;
    final isPending = tontine.status.toLowerCase() == 'pending';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isCreator && isPending) ...[
            ElevatedButton.icon(
              onPressed: () => _confirmStartTontine(context, tontine.id),
              icon: const Icon(Icons.play_arrow),
              label: Text(l10n.startTontine),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),
          ],
          _buildStatsCard(
            context,
            tontine,
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 24),
          Text(l10n.recentActivity, style: AppTextStyles.h3)
              .animate()
              .fadeIn(duration: 400.ms, delay: 200.ms)
              .slideX(begin: 0.2, end: 0),
          const SizedBox(height: 12),
          if (contributions.isEmpty)
            Card(
                  child: ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(l10n.noRecentActivity),
                  ),
                )
                .animate()
                .fadeIn(duration: 400.ms, delay: 400.ms)
                .slideY(begin: 0.2, end: 0)
          else
            ...contributions.take(5).map((contribution) {
              final member = members.cast<TontineMember?>().firstWhere(
                (m) => m?.id == contribution.memberId,
                orElse: () => null,
              );
              final memberName = member?.displayName ?? 'Membre';
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.attach_money,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    '$memberName ${l10n.turn} ${contribution.turnIndex}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat.yMMMMd(
                      'fr',
                    ).add_jm().format(contribution.createdAt),
                    style: AppTextStyles.bodySmall,
                  ),
                  trailing: _buildStatusChip(
                    context,
                    contribution.validationStatus,
                  ),
                ),
              ).animate().fadeIn().slideX();
            }),
        ],
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, dynamic tontine) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final collected = tontine.turnSummary?.collectedAmount ?? 0;
    final expected = tontine.turnSummary?.expectedAmount ?? 0;
    final progress = expected > 0
        ? (collected / expected).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.primaryContainer],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.collectedAmount,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$collected ${tontine.currency}',
                      style: AppTextStyles.h1.copyWith(
                        color: colorScheme.onPrimary,
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.savings_outlined,
                    color: colorScheme.onPrimary,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.progress,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: colorScheme.onPrimary.withValues(
                      alpha: 0.2,
                    ),
                    valueColor: AlwaysStoppedAnimation(colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  context,
                  Icons.groups_outlined,
                  '${tontine.turnSummary?.contributorsCount ?? 0}/${tontine.turnSummary?.totalMembers ?? 0}',
                  l10n.contributors,
                  colorScheme.onPrimary,
                ),
                Container(
                  height: 30,
                  width: 1,
                  color: colorScheme.onPrimary.withValues(alpha: 0.2),
                ),
                _buildStatItem(
                  context,
                  Icons.attach_money,
                  '$expected ${tontine.currency}',
                  l10n.expectedAmount,
                  colorScheme.onPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color.withValues(alpha: 0.8), size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: color.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMembersTab(
    BuildContext context,
    List<dynamic> members,
    bool isCreator,
    bool canRemove,
    String tontineId,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (members.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(l10n.noMembersFound, style: AppTextStyles.bodyLarge),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: members.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final member = members[index];
        final isHighTrust = member.trustScore >= 90;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                member.displayName.isNotEmpty
                    ? member.displayName[0].toUpperCase()
                    : '?',
                style: AppTextStyles.h3.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            title: Text(
              member.displayName,
              style: AppTextStyles.h3.copyWith(fontSize: 16),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.pie_chart_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${member.parts} ${member.parts > 1 ? "parts" : "part"}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isHighTrust
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isHighTrust ? Colors.green : Colors.orange,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isHighTrust ? Icons.verified : Icons.gpp_good_outlined,
                        size: 16,
                        color: isHighTrust ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${member.trustScore.toStringAsFixed(0)}%',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isHighTrust ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCreator &&
                    canRemove &&
                    member.userId !=
                        context.read<AuthBloc>().state.authResponse?.user.id)
                  IconButton(
                    icon: const Icon(
                      Icons.person_remove_outlined,
                      color: Colors.red,
                    ),
                    onPressed: () => _confirmRemoveMember(
                      context,
                      tontineId,
                      member.id,
                      member.displayName,
                    ),
                  ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (index * 50).ms).slideX();
      },
    );
  }

  void _confirmRemoveMember(
    BuildContext context,
    String tontineId,
    String memberId,
    String memberName,
  ) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.removeMember),
        content: Text(l10n.removeMemberConfirmation(memberName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              getIt<AnalyticsManager>().trackEvent(
                feature: 'Tontine',
                action: 'remove_member',
                details: {'tontine_id': tontineId, 'member_id': memberId},
              );
              context.read<TontineBloc>().add(
                TontineRemoveMemberRequested(
                  tontineId: tontineId,
                  memberId: memberId,
                ),
              );
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.remove),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab(BuildContext context, String tontineId) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: TontineChatTab(tontineId: tontineId),
    );
  }

  Widget _buildValidationTab(
    BuildContext context,
    List<dynamic> contributions,
    List<TontineMember> members,
  ) {
    final l10n = AppLocalizations.of(context)!;

    // Sort contributions: Pending first, then by date
    final sortedContributions = List.from(contributions);
    sortedContributions.sort((a, b) {
      if (a.validationStatus == 'pending' && b.validationStatus != 'pending') {
        return -1;
      }
      if (a.validationStatus != 'pending' && b.validationStatus == 'pending') {
        return 1;
      }
      return b.createdAt.compareTo(a.createdAt);
    });

    final filteredContributions = _validationFilter == 'pending'
        ? sortedContributions
              .where((c) => c.validationStatus == 'pending')
              .toList()
        : sortedContributions;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              FilterChip(
                label: Text(l10n.pending),
                selected: _validationFilter == 'pending',
                onSelected: (bool selected) {
                  setState(() {
                    _validationFilter = 'pending';
                  });
                },
              ),
              const SizedBox(width: 12),
              FilterChip(
                label: Text(l10n.history),
                selected: _validationFilter == 'all',
                onSelected: (bool selected) {
                  setState(() {
                    _validationFilter = 'all';
                  });
                },
              ),
            ],
          ),
        ),
        if (filteredContributions.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 64,
                    color: Colors.green.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _validationFilter == 'pending'
                        ? l10n.noPendingContributions
                        : l10n.noContributions,
                    style: AppTextStyles.bodyLarge,
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
              itemCount: filteredContributions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final contribution = filteredContributions[index];

                final member = members.cast<TontineMember?>().firstWhere(
                  (m) => m?.id == contribution.memberId,
                  orElse: () => null,
                );
                final memberName = member?.displayName ?? 'Membre';

                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.money,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        title: Text(
                          '$memberName ${l10n.turn} ${contribution.turnIndex}',
                          style: AppTextStyles.h3.copyWith(fontSize: 18),
                        ),
                        subtitle: Text(
                          DateFormat.yMMMMd(
                            'fr',
                          ).add_jm().format(contribution.createdAt),
                          style: AppTextStyles.bodySmall,
                        ),
                        trailing: _buildStatusChip(
                          context,
                          contribution.validationStatus,
                        ),
                      ),
                      if (contribution.proofImage.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: InteractiveViewer(
                                  child: Image.network(
                                    _getValidImageUrl(contribution.proofImage),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 200,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: NetworkImage(
                                  _getValidImageUrl(contribution.proofImage),
                                ),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (contribution.validationStatus == 'pending' &&
                          context
                                  .read<TontineBloc>()
                                  .state
                                  .selectedTontine
                                  ?.status
                                  .toLowerCase() !=
                              'completed')
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _validateContribution(
                                    context,
                                    contribution.id,
                                    false,
                                  ),
                                  icon: const Icon(Icons.close),
                                  label: Text(l10n.reject),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _validateContribution(
                                    context,
                                    contribution.id,
                                    true,
                                  ),
                                  icon: const Icon(Icons.check),
                                  label: Text(l10n.approve),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.2, end: 0);
              },
            ),
          ),
      ],
    );
  }

  void _validateContribution(BuildContext context, String id, bool approve) {
    getIt<AnalyticsManager>().trackEvent(
      feature: 'Tontine',
      action: 'validate_contribution',
      details: {
        'contribution_id': id,
        'status': approve ? 'creator_validated' : 'rejected',
      },
    );
    context.read<TontineBloc>().add(
      ValidateTontineContributionRequested(
        contributionId: id,
        status: approve ? 'creator_validated' : 'rejected',
      ),
    );
  }

  void _shareInvite(String code) {
    getIt<AnalyticsManager>().trackEvent(
      feature: 'Tontine',
      action: 'share_invite',
      details: {'code': code},
    );
    getIt<ShareService>().shareTontineInvite(code);
  }

  void _showContributionDialog(BuildContext context, String tontineId) {
    showDialog(
      context: context,
      builder: (context) => ContributionDialog(
        onUpload: (File image) {
          getIt<AnalyticsManager>().trackEvent(
            feature: 'Tontine',
            action: 'contribute_attempt',
            details: {'tontine_id': tontineId},
          );
          context.read<TontineBloc>().add(
            ContributeToTontineRequested(
              tontineId: tontineId,
              proofImage: image,
            ),
          );
        },
      ),
    );
  }

  void _confirmStartTontine(BuildContext context, String tontineId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.startTontine),
        content: Text(l10n.confirmStartTontine),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              getIt<AnalyticsManager>().trackEvent(
                feature: 'Tontine',
                action: 'start_attempt',
                details: {'tontine_id': tontineId},
              );
              Navigator.pop(context);
              context.read<TontineBloc>().add(StartTontineRequested(tontineId));
            },
            child: Text(l10n.start),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTontine(BuildContext context, Tontine tontine) {
    final l10n = AppLocalizations.of(context)!;
    final isPending = tontine.status.toLowerCase() == 'pending';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isPending ? l10n.delete : l10n.stopTontine),
        content: Text(
          isPending ? l10n.confirmDeleteTontine : l10n.confirmStopTontine,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              getIt<AnalyticsManager>().trackEvent(
                feature: 'Tontine',
                action: isPending ? 'delete_attempt' : 'stop_attempt',
                details: {'tontine_id': tontine.id},
              );
              Navigator.pop(context); // Close dialog
              context.read<TontineBloc>().add(
                DeleteTontineRequested(tontine.id),
              );
              Navigator.pop(context); // Go back to list
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(isPending ? l10n.delete : l10n.stop),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color color;
    String label;
    switch (status) {
      case 'validated':
      case 'creator_validated':
      case 'ai_validated':
        color = Colors.green;
        label = 'Validé';
        break;
      case 'rejected':
        color = Colors.red;
        label = 'Rejeté';
        break;
      case 'pending':
      default:
        color = Colors.orange;
        label = 'En attente';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getValidImageUrl(String path) {
    if (path.startsWith('http')) return path;

    // Replace backslashes with forward slashes
    final normalizedPath = path.replaceAll('\\', '/');

    // Get base URL
    String baseUrl =
        dotenv.env['API_BASE_URL'] ?? 'http://192.168.1.182:3000/api/v1';

    // Strip /api/v1 suffix if present to get root
    if (baseUrl.endsWith('/api/v1')) {
      baseUrl = baseUrl.replaceAll('/api/v1', '');
    }
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }

    if (!normalizedPath.startsWith('/')) {
      return '$baseUrl/$normalizedPath';
    }
    return '$baseUrl$normalizedPath';
  }
}
