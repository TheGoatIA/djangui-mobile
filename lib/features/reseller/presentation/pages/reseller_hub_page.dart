import 'package:flutter/material.dart';
import 'package:kauri/core/utils/currency_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../../../../core/mixins/secure_screen_mixin.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/widgets/tutorial/tutorial_step.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../di/injection.dart';
import '../../data/models/reseller_models.dart';
import '../../domain/repositories/reseller_repository.dart';
import '../bloc/reseller_bloc.dart';
import '../bloc/reseller_event.dart';
import '../bloc/reseller_state.dart';
import '../widgets/service_account_card.dart';
import 'add_master_account_page.dart';
import 'add_slot_page.dart';

class ResellerHubPage extends StatelessWidget {
  const ResellerHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ResellerBloc>()..add(FetchResellerDashboardRequested()),
      child: const _ResellerHubView(),
    );
  }
}

class _ResellerHubView extends StatefulWidget {
  const _ResellerHubView();

  @override
  State<_ResellerHubView> createState() => _ResellerHubViewState();
}

class _ResellerHubViewState extends State<_ResellerHubView>
    with WidgetsBindingObserver, SecureScreenMixin<_ResellerHubView> {
  final GlobalKey _addAccountKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTutorial());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.watch<TutorialService>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTutorial());
  }

  void _startTutorial() {
    final tutorialService = getIt<TutorialService>();
    if (tutorialService.hasSeenTutorial('reseller_hub')) return;
    if (ModalRoute.of(context)?.isCurrent != true) return;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      tutorialService.startTutorial(context, 'reseller_hub', [
        TutorialStep(
          targetKey: _addAccountKey,
          title: AppLocalizations.of(context)!.tutorialResellerAddAccountTitle,
          description: AppLocalizations.of(
            context,
          )!.tutorialResellerAddAccountDesc,
        ),
      ]);
    });
  }

  @override
  void dispose() {
    getIt<TutorialService>().cancelActiveTutorial(context);
    super.dispose();
  }

  void _copySensitiveData(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.copiedAutoClear(label.toString()),
        ),
      ),
    );
    // 30s plutôt que 45 : réduit la fenêtre pendant laquelle une autre
    // application peut lire cette donnée sensible depuis le presse-papiers
    // système, tout en laissant le temps de coller la valeur une fois.
    Future.delayed(const Duration(seconds: 30), () async {
      final current = await Clipboard.getData(Clipboard.kTextPlain);
      if (current?.text == text) {
        Clipboard.setData(const ClipboardData(text: ''));
      }
    });
  }

  void _openWhatsApp(
    String phone,
    String clientName,
    String serviceName,
  ) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final message =
        "Bonjour $clientName 👋, rappel de renouvellement pour votre profil sur $serviceName. Merci !";
    final uri = Uri.parse(
      "https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}",
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showVaultDialog(BuildContext context, ResellerAccountModel account) {
    bool obscure = true;
    bool obscurePin = true;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final repository = getIt<ResellerRepository>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (modalCtx) => FutureBuilder<Map<String, dynamic>>(
        future: repository.unlockVault(account.id),
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          final vault = snapshot.data ?? {};
          final email = vault['email']?.toString().isNotEmpty == true
              ? vault['email'].toString()
              : (isLoading ? 'Chargement...' : 'Non configuré');
          final password = vault['password']?.toString().isNotEmpty == true
              ? vault['password'].toString()
              : (isLoading ? '••••••••' : 'Non configuré');
          final pin = vault['pin']?.toString().isNotEmpty == true
              ? vault['pin'].toString()
              : (isLoading ? '••••' : 'Non configuré');

          return StatefulBuilder(
            builder: (context, setModalState) => Material(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.shield_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.resellerVaultOf(account.serviceName.toString()),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isLoading)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: Text(AppLocalizations.of(context)!.emailOrLogin),
                      subtitle: Text(email),
                      trailing: IconButton(
                        icon: const Icon(Icons.copy_rounded),
                        onPressed: () => _copySensitiveData(
                          context,
                          email,
                          AppLocalizations.of(context)!.email,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.key_rounded),
                      title: Text(AppLocalizations.of(context)!.password),
                      subtitle: Text(obscure ? '••••••••••••' : password),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              obscure
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                            ),
                            onPressed: () =>
                                setModalState(() => obscure = !obscure),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded),
                            onPressed: () => _copySensitiveData(
                              context,
                              password,
                              AppLocalizations.of(context)!.password,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.pin_rounded),
                      title: Text(
                        AppLocalizations.of(context)!.resellerProfilePin,
                      ),
                      subtitle: Text(obscurePin ? '••••' : pin),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              obscurePin
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                            ),
                            onPressed: () =>
                                setModalState(() => obscurePin = !obscurePin),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded),
                            onPressed: () => _copySensitiveData(
                              context,
                              pin,
                              AppLocalizations.of(context)!.pinCode,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSlotActions(
    BuildContext context,
    ResellerAccountModel account,
    ResellerSlotModel slot,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Material(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${slot.profileName} (${slot.clientName})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.resellerPricePerMonth(
                  (slot.price.toStringAsFixed(0)).toString(),
                  slot.currency.toString(),
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Builder(
                builder: (context) {
                  Color dateColor = colorScheme.onSurfaceVariant;
                  if (slot.status == 'due_soon') dateColor = Colors.orange;
                  if (slot.status == 'overdue' || slot.status == 'blocked') {
                    dateColor = Colors.red;
                  }
                  final isPast = slot.currentPeriodEnd.isBefore(DateTime.now());
                  return Row(
                    children: [
                      Icon(Icons.event_outlined, size: 15, color: dateColor),
                      const SizedBox(width: 6),
                      Text(
                        (isPast ? 'Échu le ' : 'Prochain paiement : ') +
                            DateFormat(
                              'dd/MM/yyyy',
                            ).format(slot.currentPeriodEnd),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: dateColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.green,
                ),
                title: Text(AppLocalizations.of(context)!.remindOnWhatsapp),
                subtitle: Text(slot.clientPhone),
                onTap: () {
                  Navigator.pop(ctx);
                  _openWhatsApp(
                    slot.clientPhone,
                    slot.clientName,
                    account.serviceName,
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primary,
                ),
                title: Text(AppLocalizations.of(context)!.resellerMarkPaid),
                subtitle: Text(
                  AppLocalizations.of(context)!.resellerExtendOneMonth,
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<ResellerBloc>().add(
                    RecordSlotPaymentRequested(slot.id, {
                      'amount': slot.price,
                      'paymentMethod': 'cash',
                    }),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.person_remove_outlined,
                  color: Colors.red,
                ),
                title: Text(
                  AppLocalizations.of(context)!.resellerFreeProfile,
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!.resellerFreeProfileDesc,
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmRemoveSlot(context, account, slot);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmRemoveSlot(
    BuildContext context,
    ResellerAccountModel account,
    ResellerSlotModel slot,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.resellerRemoveClientTitle),
        content: Text(
          'Voulez-vous retirer ${slot.clientName} du profil "${slot.profileName}" sur ${account.serviceName} ?\n\n'
          'Pensez à modifier le code PIN du profil sur le service pour révoquer son accès.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ResellerBloc>().add(DeleteSlotRequested(slot.id));
            },
            child: Text(AppLocalizations.of(context)!.resellerRemoveAndFree),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteMasterAccount(
    BuildContext context,
    ResellerAccountModel account,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          AppLocalizations.of(
            context,
          )!.deleteNamedQuestion(account.serviceName.toString()),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer ce compte maître "${account.serviceName}" ?\n\n'
          '⚠️ Tous les profils/slots associés (${account.slots.length} profil(s)) et les accès du coffre-fort seront définitivement supprimés.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ResellerBloc>().add(
                DeleteMasterAccountRequested(account.id),
              );
            },
            child: Text(AppLocalizations.of(context)!.deletePermanently),
          ),
        ],
      ),
    );
  }

  void _showGuideDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Material(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.resellerGuideTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          l10n.resellerGuideSubtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildGuideSection(
                context,
                Icons.folder_shared_outlined,
                l10n.resellerGuideMasterTitle,
                l10n.resellerGuideMasterDesc,
              ),
              const SizedBox(height: 14),
              _buildGuideSection(
                context,
                Icons.people_outline_rounded,
                l10n.resellerGuideSlotsTitle,
                l10n.resellerGuideSlotsDesc,
              ),
              const SizedBox(height: 14),
              _buildGuideSection(
                context,
                Icons.check_circle_outline,
                l10n.resellerGuidePaymentTitle,
                l10n.resellerGuidePaymentDesc,
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? Colors.white12
                        : Colors.black.withValues(alpha: 0.06),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.stars_rounded,
                          color: Colors.amber,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.resellerGuideQuotasTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.resellerGuideQuotasFree,
                      style: const TextStyle(fontSize: 12, height: 1.4),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.resellerGuideQuotasPremium,
                      style: const TextStyle(fontSize: 12, height: 1.4),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.resellerGuideQuotasBusiness,
                      style: const TextStyle(fontSize: 12, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(AppLocalizations.of(context)!.tutorialFinish),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideSection(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResellerBloc, ResellerState>(
      listener: (context, state) {
        if (state is ResellerActionSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is ResellerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is ResellerLoading && state is! ResellerLoaded) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.resellerSpace,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              elevation: 0,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        List<ResellerAccountModel> accounts = [];
        double totalMRR = 0;
        double netMargin = 0;
        int occupiedSlots = 0;
        int vacantSlots = 0;

        if (state is ResellerLoaded) {
          accounts = state.accounts;
          totalMRR = state.stats.mrr;
          netMargin = state.stats.netProfit;
          occupiedSlots = state.stats.occupiedSlots;
          vacantSlots = state.stats.vacantSlots;
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.resellerSpace,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline_rounded),
                tooltip: AppLocalizations.of(context)!.guideAndQuotas,
                onPressed: () => _showGuideDialog(context),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<ResellerBloc>().add(
                    FetchResellerDashboardRequested(),
                  );
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<ResellerBloc>().add(
                FetchResellerDashboardRequested(),
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Financial Card
                  GlassCard(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.25),
                    ),
                    borderRadius: 20,
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.resellerMonthlyRevenue,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  CurrencyHelper.formatAmount(
                                    totalMRR.toDouble(),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${netMargin >= 0 ? '+' : ''}${netMargin.toStringAsFixed(0)} XAF Net',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMiniStat(
                              AppLocalizations.of(context)!.accountsLabel,
                              '${accounts.length}',
                            ),
                            _buildMiniStat(
                              AppLocalizations.of(
                                context,
                              )!.resellerManagedSlots,
                              '$occupiedSlots',
                            ),
                            _buildMiniStat(
                              AppLocalizations.of(context)!.resellerFreeSlots,
                              '$vacantSlots',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section Title & Add Account Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.resellerActiveAccounts,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      KeyedSubtree(
                        key: _addAccountKey,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final accountData =
                                await Navigator.push<Map<String, dynamic>>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const AddMasterAccountPage(),
                                  ),
                                );
                            if (accountData != null && context.mounted) {
                              context.read<ResellerBloc>().add(
                                CreateMasterAccountRequested(accountData),
                              );
                            }
                          },
                          icon: const Icon(Icons.add, size: 16),
                          label: Text(AppLocalizations.of(context)!.newAccount),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Empty State or Accounts List
                  if (accounts.isEmpty && state is ResellerLoaded)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.resellerNoMasterAccount,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.resellerNoMasterAccountDesc,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...accounts.map(
                      (account) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ServiceAccountCard(
                          account: account,
                          onTap: () async {
                            final slotData =
                                await Navigator.push<Map<String, dynamic>>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddSlotPage(
                                      accountId: account.id,
                                      serviceName: account.serviceName,
                                    ),
                                  ),
                                );
                            if (slotData != null && context.mounted) {
                              context.read<ResellerBloc>().add(
                                AddSlotToAccountRequested(account.id, slotData),
                              );
                            }
                          },
                          onUnlockVault: () =>
                              _showVaultDialog(context, account),
                          onSlotTap: (slot) =>
                              _showSlotActions(context, account, slot),
                          onDeleteAccount: () =>
                              _confirmDeleteMasterAccount(context, account),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          // Couleur du thème : `Colors.black87` rendait le chiffre invisible
          // en mode sombre (noir sur fond sombre, constaté en capture E2E).
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
