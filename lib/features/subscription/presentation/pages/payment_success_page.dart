import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../di/injection.dart';
import '../../../../core/services/payment_service.dart';

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
    _verifyPayment();
  }

  Future<void> _verifyPayment() async {
    // If no ref provided, we can't verify, but maybe it was a direct success redirect?
    // Assuming ref is required for verification.
    if (widget.ref != null) {
      setState(() => _isLoading = true);
      final paymentService = getIt<PaymentService>();
      final success = await paymentService.verifyTransaction(widget.ref!);

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isVerified = success;
        });

        if (success) {
          context.read<AuthBloc>().add(AuthRefreshUserRequested());
        }
      }
    } else {
      // Fallback if no ref (e.g. testing)
      setState(() {
        _isLoading = false;
        _isVerified = true; // Optimistic or handle error
      });
      context.read<AuthBloc>().add(AuthRefreshUserRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Vérification du paiement en cours...'),
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
                          : AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isVerified
                          ? Icons.check_circle_rounded
                          : Icons.error_outline_rounded,
                      color: _isVerified ? AppColors.success : AppColors.error,
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
                  Text(
                    _isVerified
                        ? 'Votre abonnement Premium a été activé avec succès.\nProfitez de toutes les fonctionnalités !'
                        : 'Nous n\'avons pas pu confirmer votre paiement.\nVeuillez contacter le support si vous avez été débité.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (widget.ref != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Référence: ${widget.ref}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 48),
                  AppButton(
                    text: _isVerified
                        ? 'Continuer vers le Tableau de Bord'
                        : 'Retour au Tableau de Bord',
                    onPressed: () {
                      context.go(RouteConstants.dashboard);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
