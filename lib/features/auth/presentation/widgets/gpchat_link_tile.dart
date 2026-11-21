import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

/// Sécurité › Comptes connectés : lier ou délier son compte GPChat.
/// La liaison passe par la page GPChat (validation dans l'app GPChat) puis
/// revient ici ; elle n'est enregistrée qu'à la confirmation par cette app.
class GpchatLinkTile extends StatefulWidget {
  const GpchatLinkTile({super.key});

  @override
  State<GpchatLinkTile> createState() => _GpchatLinkTileState();
}

class _GpchatLinkTileState extends State<GpchatLinkTile> {
  final AuthRepository _repo = getIt<AuthRepository>();
  bool? _linked;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await _repo.getCurrentUser();
    if (!mounted) return;
    result.fold((_) {}, (UserModel u) => setState(() => _linked = u.gpchatId != null));
  }

  void _toast(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Theme.of(context).colorScheme.error : AppColors.success,
      ),
    );
  }

  Future<void> _link() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    final result = await _repo.linkGpchat();
    if (!mounted) return;
    setState(() => _busy = false);
    result.fold(
      (failure) => _toast(failure.message, error: true),
      (u) {
        setState(() => _linked = u.gpchatId != null);
        _toast(l10n.gpchatLinked);
      },
    );
  }

  Future<void> _unlink() async {
    final l10n = AppLocalizations.of(context)!;
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.gpchatUnlinkTitle),
        content: Text(l10n.gpchatUnlinkBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.gpchatUnlink)),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _busy = true);
    final result = await _repo.unlinkGpchat();
    if (!mounted) return;
    setState(() => _busy = false);
    result.fold(
      (failure) => _toast(failure.message, error: true),
      (u) {
        setState(() => _linked = u.gpchatId != null);
        _toast(l10n.gpchatUnlinked);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool linked = _linked ?? false;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Image.asset('assets/images/gpchat_logo.png', width: 32, height: 32),
      title: const Text('GPChat'),
      subtitle: Text(linked ? l10n.gpchatLinkedDesc : l10n.gpchatNotLinkedDesc),
      trailing: _linked == null || _busy
          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
          : linked
              ? OutlinedButton(onPressed: _unlink, child: Text(l10n.gpchatUnlink))
              : FilledButton(onPressed: _link, child: Text(l10n.gpchatLink)),
    );
  }
}
