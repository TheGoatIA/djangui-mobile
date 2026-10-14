const fs = require('fs');
const filePath = 'd:/Projets/NodeJS/djangui-api/src/services/planConfigService.ts';
let code = fs.readFileSync(filePath, 'utf8');

// Update Premium featureSummary
code = code.replace(
  /'Revendeur Hub : Comptes illimitÃ©s & 20 slots clients'|'Revendeur Hub : Comptes illimités & 20 slots clients'|'Revendeur Hub : Jusqu.*20.*profils.*'/g,
  "'Revendeur Hub : Jusqu\\'à 3 comptes maîtres & 10 profils clients'"
);

code = code.replace(
  /'Reseller Hub: Unlimited accounts & 20 slots'/g,
  "'Reseller Hub: Up to 3 master accounts & 10 client slots'"
);

code = code.replace(
  /'Budgets & Objectifs IllimitÃ©s'|'Budgets & Objectifs Illimités'/g,
  "'5 Budgets & 5 Objectifs d\\'épargne simultanés'"
);

code = code.replace(
  /'Unlimited Budgets & Goals'/g,
  "'5 Active Budgets & 5 Simultaneous Goals'"
);

code = code.replace(
  /'Tontines IllimitÃ©es \(CrÃ©ation & Auto-dÃ©bit\)'|'Tontines Illimitées \(Création & Auto-débit\)'/g,
  "'Jusqu\\'à 2 tontines créées (Participation libre)'"
);

code = code.replace(
  /'Unlimited Tontines \(Creation & Auto-debit\)'/g,
  "'Up to 2 created tontines (Unlimited joining)'"
);

// Update limits object in premium
code = code.replace(
  /maxBudgets:\s*null,\s*maxGoals:\s*null,\s*maxActiveTontines:\s*null,\s*maxMasterAccounts:\s*null,\s*maxClientSlots:\s*20,\s*withdrawalFeePercentage:\s*1\.5,\s*aiCoachHistoryLimit:\s*\d+,/,
  'maxBudgets: 5,\n      maxGoals: 5,\n      maxActiveTontines: 2,\n      maxMasterAccounts: 3,\n      maxClientSlots: 10,\n      withdrawalFeePercentage: 1.5,\n      aiCoachHistoryLimit: 50,'
);

fs.writeFileSync(filePath, code, 'utf8');
console.log('Updated planConfigService.ts successfully.');
