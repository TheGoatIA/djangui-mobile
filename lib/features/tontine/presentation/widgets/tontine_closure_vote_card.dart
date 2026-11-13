import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kauri/l10n/app_localizations.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../di/injection.dart';
import '../../data/models/tontine_vote_model.dart';
import '../../domain/repositories/tontine_repository.dart';

/// Carte « Clôture de la tontine » (onglet Tableau de bord d'une tontine ACTIVE).
///
/// Une tontine en cours ne peut plus être arrêtée par son seul créateur
/// (arnaque classique : toucher sa cagnotte puis tout stopper). N'importe quel
/// membre propose la clôture, tous les membres votent, la majorité absolue
/// décide ; l'API clôture la tontine dès que l'issue est certaine.
class TontineClosureVoteCard extends StatefulWidget {
  final String tontineId;

  /// Appelé quand le vote vient d'aboutir à la clôture (pour recharger la tontine).
  final VoidCallback? onTontineClosed;

  /// Injectable pour les tests ; par défaut le repository de l'application.
  final TontineRepository? repository;

  const TontineClosureVoteCard({
    super.key,
    required this.tontineId,
    this.onTontineClosed,
    this.repository,
  });

  @override
  State<TontineClosureVoteCard> createState() => _TontineClosureVoteCardState();
}

class _TontineClosureVoteCardState extends State<TontineClosureVoteCard> {
  late final TontineRepository _repo =
      widget.repository ?? getIt<TontineRepository>();

  bool _loading = true;
  bool _busy = false;
  String? _error;
  TontineVoteModel? _vote; // vote de clôture le plus récent

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await _repo.getVotes(widget.tontineId);
    if (!mounted) return;
    result.match(
      (f) => setState(() {
        _loading = false;
        _error = f.message;
      }),
      (votes) => setState(() {
        _loading = false;
        _vote = votes.cast<TontineVoteModel?>().firstWhere(
          (v) => v!.isClosure,
          orElse: () => null,
        );
      }),
    );
  }

  void _toast(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : null,
      ),
    );
  }

  Future<bool> _confirm(String title, String body, String action) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            key: const Key('closureVoteConfirm'),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(action),
          ),
        ],
      ),
    );
    return ok == true;
  }

  Future<void> _propose() async {
    final l10n = AppLocalizations.of(context)!;
    if (!await _confirm(
      l10n.proposeClosure,
      l10n.confirmProposeClosure,
      l10n.proposeClosure,
    )) {
      return;
    }
    setState(() => _busy = true);
    final result = await _repo.proposeClosure(widget.tontineId);
    if (!mounted) return;
    setState(() => _busy = false);
    result.match(
      (f) => _toast(f.message, error: true),
      (vote) => setState(() => _vote = vote),
    );
  }

  Future<void> _cast(int optionIndex) async {
    final l10n = AppLocalizations.of(context)!;
    final vote = _vote;
    if (vote == null) return;
    final choice = optionIndex == 0 ? l10n.voteYesClose : l10n.voteNoContinue;
    if (!await _confirm(
      l10n.closureVoteTitle,
      l10n.confirmVote(choice),
      choice,
    )) {
      return;
    }
    setState(() => _busy = true);
    final result = await _repo.castVote(widget.tontineId, vote.id, optionIndex);
    if (!mounted) return;
    setState(() => _busy = false);
    result.match(
      (f) {
        _toast(f.message, error: true);
        _load(); // état serveur (déjà voté, vote clos…) fait foi
      },
      (updated) {
        setState(() => _vote = updated);
        _toast(l10n.voteRecorded);
        if (updated.outcome == 'approved') widget.onTontineClosed?.call();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    Widget body;
    if (_loading) {
      body = const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (_error != null) {
      body = Row(
        children: [
          Expanded(child: Text(_error!, style: AppTextStyles.bodySmall)),
          IconButton(
            key: const Key('closureVoteRetry'),
            icon: const Icon(Icons.refresh),
            onPressed: _load,
          ),
        ],
      );
    } else {
      body = _buildContent(context, l10n);
    }

    return Card(
      key: const Key('tontineClosureVoteCard'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.how_to_vote_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(l10n.closureVoteTitle, style: AppTextStyles.h3),
                ),
              ],
            ),
            const SizedBox(height: 12),
            body,
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    final vote = _vote;
    final children = <Widget>[];

    if (vote != null && vote.isOpen) {
      children.addAll([
        Text(
          l10n.closureVoteOpen,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        if (vote.question.isNotEmpty)
          Text(vote.question, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 8),
        if (vote.majority > 0)
          Text(
            l10n.closureVoteProgress(vote.votersCount, vote.majority),
            style: AppTextStyles.bodySmall,
          ),
        if (vote.expiresAt != null)
          Text(
            l10n.closureVoteEndsAt(
              DateFormat.yMMMd('fr').add_Hm().format(vote.expiresAt!.toLocal()),
            ),
            style: AppTextStyles.bodySmall,
          ),
        const SizedBox(height: 12),
      ]);
      if (vote.hasVoted) {
        children.add(
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(l10n.youHaveVoted, style: AppTextStyles.bodySmall),
              ),
            ],
          ),
        );
      } else {
        children.add(
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  key: const Key('voteNoContinue'),
                  onPressed: _busy ? null : () => _cast(1),
                  child: Text(l10n.voteNoContinue),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  key: const Key('voteYesClose'),
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _busy ? null : () => _cast(0),
                  child: Text(l10n.voteYesClose),
                ),
              ),
            ],
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    }

    // Pas de vote ouvert : résultat du dernier vote éventuel + proposition.
    if (vote != null) {
      final String last;
      if (vote.outcome == 'approved') {
        last = l10n.closureVoteApproved;
      } else if (vote.outcome == 'rejected') {
        last = l10n.closureVoteRejected;
      } else {
        last = l10n.closureVoteExpired;
      }
      children.addAll([
        Text(
          last,
          key: const Key('closureVoteLastOutcome'),
          style: AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 8),
      ]);
    }
    if (vote?.outcome != 'approved') {
      children.addAll([
        Text(l10n.closureVoteExplainer, style: AppTextStyles.bodySmall),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          key: const Key('proposeClosureButton'),
          onPressed: _busy ? null : _propose,
          icon: const Icon(Icons.how_to_vote_outlined),
          label: Text(l10n.proposeClosure),
        ),
      ]);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
