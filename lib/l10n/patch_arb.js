const fs = require('fs');

function addTranslations(filePath, newKeys) {
  let content = fs.readFileSync(filePath, 'utf8').trim();
  if (content.endsWith('}')) {
    content = content.slice(0, -1).trim();
    if (!content.endsWith(',')) content += ',';
    for (const [k, v] of Object.entries(newKeys)) {
      content += '\n    ' + JSON.stringify(k) + ': ' + JSON.stringify(v) + ',';
    }
    content = content.slice(0, -1) + '\n}\n';
    fs.writeFileSync(filePath, content, { encoding: 'utf8' });
    console.log('Updated ' + filePath);
  }
}

const frKeys = {
  otherTools: "Autres outils",
  resellerGuideTitle: "Guide Espace Revendeur",
  resellerGuideSubtitle: "Comment fonctionne la gestion des abonnements partagés ?",
  resellerGuideMasterTitle: "1. Comptes Maîtres (Vos abonnements)",
  resellerGuideMasterDesc: "Vous enregistrez ici vos comptes d'origine (Netflix, Spotify, Canva...). Vous y définissez ce que vous payez au fournisseur et la date de renouvellement de votre abonnement.",
  resellerGuideSlotsTitle: "2. Profils & Slots Clients",
  resellerGuideSlotsDesc: "Chaque compte est découpé en slots (écrans/profils). Vous attribuez chaque slot à un client avec son nom, son numéro WhatsApp, son prix de revente et sa date de début.",
  resellerGuidePaymentTitle: "3. 'Marquer comme payé'",
  resellerGuidePaymentDesc: "Quand votre client vous règle, cliquez sur son profil puis 'Marquer comme payé'. Le système enregistre l'historique et prolonge automatiquement son accès d'un mois (le badge repasse au vert).",
  resellerGuideQuotasTitle: "4. Quotas par Forfait",
  resellerGuideQuotasFree: "• Forfait Gratuit : Jusqu'à 2 comptes maîtres et 3 profils clients.",
  resellerGuideQuotasPremium: "• Forfait Premium : Comptes maîtres illimités et jusqu'à 20 profils clients.",
  resellerGuideQuotasBusiness: "• Forfait Business : Comptes et profils illimités, exports comptables et statistiques avancées."
};

const enKeys = {
  otherTools: "Other Tools",
  resellerGuideTitle: "Reseller Hub Guide",
  resellerGuideSubtitle: "How does shared subscription management work?",
  resellerGuideMasterTitle: "1. Master Accounts (Your Subscriptions)",
  resellerGuideMasterDesc: "Register your primary accounts here (Netflix, Spotify, Canva...). Set what you pay to the provider and your next renewal date.",
  resellerGuideSlotsTitle: "2. Client Profiles & Slots",
  resellerGuideSlotsDesc: "Each master account is divided into slots (screens/profiles). Assign each slot to a client with their name, WhatsApp number, resale price, and start date.",
  resellerGuidePaymentTitle: "3. 'Mark as Paid'",
  resellerGuidePaymentDesc: "When a client pays you, tap their profile and select 'Mark as Paid'. The system logs the transaction and automatically extends their access by one cycle.",
  resellerGuideQuotasTitle: "4. Tier Quotas",
  resellerGuideQuotasFree: "• Free Plan: Up to 2 master accounts and 3 client profiles.",
  resellerGuideQuotasPremium: "• Premium Plan: Unlimited master accounts and up to 20 client profiles.",
  resellerGuideQuotasBusiness: "• Business Plan: Unlimited master accounts and profiles, accounting exports, and advanced analytics."
};

addTranslations('d:/Projets/Flutter/djangui-mobile/lib/l10n/app_fr.arb', frKeys);
addTranslations('d:/Projets/Flutter/djangui-mobile/lib/l10n/app_en.arb', enKeys);
