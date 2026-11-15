import 'package:flutter/material.dart';
import 'package:kauri/core/theme/app_text_styles.dart';

class RealMoneyInfoPage extends StatelessWidget {
  const RealMoneyInfoPage({super.key});

  String _text(BuildContext context, String fr, String en) {
    final isFr = Localizations.localeOf(context).languageCode == 'fr';
    return isFr ? fr : en;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          _text(context, 'Kauri & l\'Argent Réel', 'Kauri & Real Money'),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _text(
                        context,
                        'Le passage d\'une application de "suivi budgétaire" à une véritable Fintech (manipulant du vrai argent) est un tournant majeur. Voici ce que cela implique pour vous et pour nous.',
                        'Transitioning from a "budget tracking" app to a true Fintech app (handling real money) is a major turning point. Here is what it means for you and for us.',
                      ),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            _buildSection(
              context,
              icon: Icons.gavel_outlined,
              title: _text(
                context,
                '1. Vérification d\'Identité Stricte (KYC)',
                '1. Strict Identity Verification (KYC)',
              ),
              content: _text(
                context,
                'Nous ne sommes plus juste une application technologique, mais un acteur financier. \n\n• Vos retraits massifs nécessiteront une vérification infaillible de vos pièces d\'identité.\n• Kauri agit en toute conformité avec les régulateurs financiers.\n• Nous surveillons activement contre le blanchiment d\'argent pour protéger notre écosystème.',
                'We are no longer just a tech app, but a financial actor.\n\n• Large withdrawals will require an infallible verification of your ID documents.\n• Kauri acts in full compliance with financial regulators.\n• We actively monitor against money laundering to protect our ecosystem.',
              ),
            ),

            _buildSection(
              context,
              icon: Icons.account_balance_outlined,
              title: _text(
                context,
                '2. Sécurité absolue de vos Fonds',
                '2. Absolute Security of your Funds',
              ),
              content: _text(
                context,
                'Votre argent n\'est plus un simple chiffre à l\'écran. \n\n• Comptabilité Immuable (Ledger) : Chaque mouvement d\'argent est retracé au centime près par notre système en partie double.\n• Réconciliation Bancaire : Les comptes physiques de Kauri correspondent mathématiquement, et de façon certifiée, au solde virtuel de votre portefeuille quotidiennement.',
                'Your money is no longer just a number on a screen.\n\n• Immutable Ledger : Every money movement is tracked down to the cent by our double-entry system.\n• Bank Reconciliation : Kauri\'s physical accounts perfectly match your virtual wallet balance daily, certified mathematically.',
              ),
            ),

            _buildSection(
              context,
              icon: Icons.group_outlined,
              title: _text(
                context,
                '3. Tontines 100% Garanties',
                '3. 100% Guaranteed Tontines',
              ),
              content: _text(
                context,
                'Comme de l\'argent réel circule, la responsabilité est maximale. \n\nLe non-paiement de sa cotisation n\'entraîne plus seulement une perte de points de confiance, mais des actions réelles : recouvrement légal, limites et gels de compte. Cela protège la communauté et le fonctionnement sain des tontines.',
                'Since real money flows, responsibility is absolute.\n\nFailing to pay your contribution is no longer just losing trust points, but triggers real actions: legal recovery, account limits, and freezes. This protects the community and the healthy function of your tontines.',
              ),
            ),

            _buildSection(
              context,
              icon: Icons.security_outlined,
              title: _text(
                context,
                '4. Sécurité de niveau Bancaire',
                '4. Bank-Level Security',
              ),
              content: _text(
                context,
                'L\'application est soumise à des audits de sécurité en continu. Les tentatives de fraude de notre IA (faire annuler une dette, faux relevé) déclenchent automatiquement des sanctions irréversibles et des signalements.\nVos cartes bancaires sont protégées via la norme stricte PCI-DSS de nos partenaires.',
                'The app undergoes continuous security audits. Attempts to defraud our AI (canceling debts, fake receipts) automatically trigger irreversible sanctions and reports.\nYour credit cards are protected under strict PCI-DSS compliance via our partners.',
              ),
            ),

            _buildSection(
              context,
              icon: Icons.support_agent_outlined,
              title: _text(
                context,
                '5. Support Client Réactif',
                '5. Reactive Customer Support',
              ),
              content: _text(
                context,
                'L\'argent génère parfois de l\'anxiété.\n\nUn réseau défaillant lors d\'un dépôt Mobile Money ? Une désynchronisation ? Pas de panique. Kauri dédie une équipe complète au support opérationnel. Nous assurons la traçabilité continue pour qu\'aucun centime ne disparaisse.',
                'Money can cause anxiety.\n\nA failing network during a Mobile Money deposit? A desynchronization? Do not panic. Kauri commits a full team to operational support. We ensure continuous traceability so that no cent is ever lost.',
              ),
            ),

            _buildSection(
              context,
              icon: Icons.account_balance_wallet_outlined,
              title: _text(
                context,
                '6. Où va concrètement votre argent',
                '6. Where your money actually goes',
              ),
              content: _text(
                context,
                'Kauri ne conserve jamais vos fonds elle-même. Vos dépôts et retraits transitent exclusivement par NotchPay, un agrégateur Mobile Money déjà autorisé à opérer au Cameroun.\n\n• Votre argent reste chez NotchPay, dans son système régulé — Kauri n\'en a jamais la garde directe.\n• Le solde affiché dans l\'application représente votre droit sur les fonds détenus par NotchPay, pas une créance indépendante de Kauri.\n• Les retraits Mobile Money (Orange/MTN) sont exécutés directement par NotchPay vers votre compte.\n\nCela signifie que la sécurité réglementaire de vos fonds repose sur l\'agrément de NotchPay en tant que prestataire de paiement, en plus des contrôles internes de Kauri décrits ci-dessus.',
                'Kauri never holds your funds itself. Your deposits and withdrawals move exclusively through NotchPay, a Mobile Money aggregator already authorized to operate in Cameroon.\n\n• Your money stays with NotchPay, inside its regulated system — Kauri never takes direct custody of it.\n• The balance shown in the app represents your claim on the funds NotchPay holds, not a separate debt owed by Kauri.\n• Mobile Money withdrawals (Orange/MTN) are executed directly by NotchPay to your account.\n\nThis means the regulatory security of your funds rests on NotchPay\'s license as a payment service provider, in addition to Kauri\'s own internal controls described above.',
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h3.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
