import 'package:flutter/material.dart';
import 'package:kauri/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/payments/presentation/bloc/fintech_bloc.dart';
import '../../../../features/payments/presentation/bloc/fintech_event.dart';
import '../../../../di/injection.dart';
import '../../../../core/services/payment_service.dart';
import '../../../../core/services/log_service.dart';

class PaymentSuccessPage extends StatefulWidget {
  final String? ref;
  final String? status;

  const PaymentSuccessPage({super.key, this.ref, this.status});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  bool _isLoading = true;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    getIt<LogService>().info(
      'Affichage page succès paiement (ref: ${widget.ref})',
      component: 'PaymentSuccessPage',
    );
    _verifyPayment();
  }

  Future<void> _verifyPayment() async {
    final ref = widget.ref;
    if (ref != null && ref.trim().isNotEmpty) {
      setState(() => _isLoading = true);
      final paymentService = getIt<PaymentService>();
      // L'utilisateur peut revenir avant que l'opérateur ait confirmé : on
      // réessaie quelques fois avant de conclure à un échec.
      var success = false;
      for (var attempt = 0; attempt < 5 && !success; attempt++) {
        if (attempt > 0) {
          await Future.delayed(const Duration(seconds: 3));
          if (!mounted) return;
        }
        success = await paymentService.verifyTransaction(ref.trim());
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isVerified = success;
        });

        if (success) {
          getIt<LogService>().info(
            'Paiement vérifié avec succès: ${widget.ref}',
            component: 'PaymentSuccessPage',
          );
          context.read<AuthBloc>().add(AuthRefreshUserRequested());
          context.read<FintechBloc>().add(FetchWalletBalance());
          context.read<FintechBloc>().add(FetchWalletTransactions());
        } else {
          getIt<LogService>().warning(
            'Échec vérification paiement: ${widget.ref}',
            component: 'PaymentSuccessPage',
          );
        }
      }
    } else {
      // Pas de référence de transaction fournie : impossible de valider le paiement (K-18)
      getIt<LogService>().warning(
        'Tentative d\'accès à PaymentSuccessPage sans référence de transaction.',
        component: 'PaymentSuccessPage',
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isVerified = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.paymentVerificationInProgress,
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _isVerified
                          ? AppColors.success.withValues(alpha: 0.1)
                          : Theme.of(
                              context,
                            ).colorScheme.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isVerified
                          ? Icons.check_circle_rounded
                          : Icons.error_outline_rounded,
                      color: _isVerified
                          ? AppColors.success
                          : Theme.of(context).colorScheme.error,
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _isVerified
                        ? 'Paiement Confirmé !'
                        : 'Échec de la vérification',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h1,
                  ),
                  const SizedBox(height: 16),
                  Builder(
                    builder: (context) {
                      final user = context
                          .watch<AuthBloc>()
                          .state
                          .authResponse
                          ?.user;
                      final isBusiness = user?.isBusiness ?? false;
                      final planLabel = isBusiness
                          ? 'Super Premium (Business)'
                          : 'Premium';

                      return Text(
                        _isVerified
                            ? 'Votre abonnement $planLabel a été activé avec succès.\nProfitez de toutes vos fonctionnalités exclusives !'
                            : 'Nous n\'avons pas pu confirmer votre paiement.\nVeuillez contacter le support si vous avez été débité.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                  if (widget.ref != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.referenceValue(widget.ref.toString()),
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 48),
                  AppButton(
                    text: _isVerified
                        ? 'Continuer vers le Tableau de Bord'
                        : 'Retour au Tableau de Bord',
                    onPressed: () {
                      context.read<FintechBloc>().add(FetchWalletBalance());
                      context.read<FintechBloc>().add(
                        FetchWalletTransactions(),
                      );
                      context.go(RouteConstants.dashboard);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
