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
  businessPlan: "Super Premium (Business)",
  businessPlanDesc: "La formule ultime pour gérer vos finances et votre activité de revendeur d'abonnements.",
  businessFeatureResellerUnlimited: "Hub Revendeur : Comptes & Profils illimités",
  businessFeatureAutoReminders: "Relances & Rappels WhatsApp automatisés",
  businessFeatureAccountingExports: "Exports comptables & bilans en 1 clic",
  businessFeatureAdvancedStats: "Statistiques & prévisions financières avancées",
  businessFeatureVIPSupport: "Support VIP dédié & prioritaire",
  upgradeToBusiness: "Passer à Super Premium",
  currentBusinessPlan: "Votre forfait Business actif"
};

const enKeys = {
  businessPlan: "Super Premium (Business)",
  businessPlanDesc: "The ultimate tier to manage your finances and subscription reseller business.",
  businessFeatureResellerUnlimited: "Reseller Hub: Unlimited Master Accounts & Slots",
  businessFeatureAutoReminders: "Automated WhatsApp payment reminders",
  businessFeatureAccountingExports: "1-Click Accounting & Financial exports",
  businessFeatureAdvancedStats: "Advanced financial statistics & projections",
  businessFeatureVIPSupport: "Dedicated priority VIP support",
  upgradeToBusiness: "Upgrade to Super Premium",
  currentBusinessPlan: "Your active Business plan"
};

addTranslations('d:/Projets/Flutter/djangui-mobile/lib/l10n/app_fr.arb', frKeys);
addTranslations('d:/Projets/Flutter/djangui-mobile/lib/l10n/app_en.arb', enKeys);
