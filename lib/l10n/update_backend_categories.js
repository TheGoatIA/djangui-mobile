const fs = require('fs');
const filePath = 'd:/Projets/NodeJS/djangui-api/src/services/planConfigService.ts';
let code = fs.readFileSync(filePath, 'utf8');

// Replace items for Premium
code = code.replace(
  /\{ id: 'budgets', name: \{ fr: 'Nombre de budgets actifs', en: 'Active budgets limit' \}, included: true, highlight: true, value: \{ fr: 'Illimit[^']+', en: 'Unlimited' \} \}/,
  "{ id: 'budgets', name: { fr: 'Nombre de budgets actifs', en: 'Active budgets limit' }, included: true, highlight: true, value: { fr: '5 Budgets actifs', en: '5 Active budgets' } }"
);

code = code.replace(
  /\{ id: 'goals', name: \{ fr: 'Objectifs d[^']+épargne & Dettes', en: 'Saving & Debt goals' \}, included: true, highlight: true, value: \{ fr: 'Illimit[^']+', en: 'Unlimited' \} \}/,
  "{ id: 'goals', name: { fr: 'Objectifs d’épargne & Dettes', en: 'Saving & Debt goals' }, included: true, highlight: true, value: { fr: '5 Objectifs simultanés', en: '5 Simultaneous goals' } }"
);

code = code.replace(
  /\{ id: 'ocr', name: \{ fr: 'Scan de re[^']+ \/ OCR intelligent', en: 'Smart Receipt Scan \/ OCR' \}, included: true, value: \{ fr: 'Illimit[^']+', en: 'Unlimited' \} \}/,
  "{ id: 'ocr', name: { fr: 'Scan de reçus / OCR intelligent', en: 'Smart Receipt Scan / OCR' }, included: true, value: { fr: '15 scans / mois', en: '15 scans / month' } }"
);

code = code.replace(
  /\{ id: 'coach_chat', name: \{ fr: 'Coach Financier IA Anne', en: 'AI Financial Coach Anne' \}, included: true, highlight: true, value: \{ fr: '100 msgs[^']+', en: '100 messages history' \} \}/,
  "{ id: 'coach_chat', name: { fr: 'Coach Financier IA Anne', en: 'AI Financial Coach Anne' }, included: true, highlight: true, value: { fr: '50 requêtes & 30j d’historique', en: '50 requests & 30d history' } }"
);

code = code.replace(
  /\{ id: 'tontine_create', name: \{ fr: 'Cr[^']+ation et gestion de tontines', en: 'Create & manage tontines' \}, included: true, value: \{ fr: 'Illimit[^']+', en: 'Unlimited' \} \}/,
  "{ id: 'tontine_create', name: { fr: 'Création et gestion de tontines', en: 'Create & manage tontines' }, included: true, value: { fr: '2 tontines créées max', en: '2 managed tontines max' } }"
);

code = code.replace(
  /\{ id: 'master_accounts', name: \{ fr: 'Services & Comptes Ma[^']+', en: 'Master Accounts & Services' \}, included: true, highlight: true, value: \{ fr: 'Illimit[^']+', en: 'Unlimited' \} \}/,
  "{ id: 'master_accounts', name: { fr: 'Services & Comptes Maîtres', en: 'Master Accounts & Services' }, included: true, highlight: true, value: { fr: '3 comptes maîtres max', en: '3 master accounts max' } }"
);

code = code.replace(
  /\{ id: 'client_slots', name: \{ fr: 'Profils \/ Slots clients g[^']+', en: 'Managed client slots' \}, included: true, highlight: true, value: \{ fr: '20 slots clients', en: '20 client slots' \} \}/,
  "{ id: 'client_slots', name: { fr: 'Profils / Slots clients gérés', en: 'Managed client slots' }, included: true, highlight: true, value: { fr: '10 profils clients max', en: '10 client slots max' } }"
);

fs.writeFileSync(filePath, code, 'utf8');
console.log('Categories details updated in planConfigService.ts');
