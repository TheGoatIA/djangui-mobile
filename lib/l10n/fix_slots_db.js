const fs = require('fs');
const filePath = 'd:/Projets/NodeJS/djangui-api/src/services/planConfigService.ts';
let code = fs.readFileSync(filePath, 'utf8');

// Replace remaining '20 slots' or '20 slots clients' with '10 profils clients max'
code = code.replace(
  /\{ id: 'client_slots', name: \{ fr: 'Profils \/ Slots clients g[^']+', en: 'Managed client slots' \}, included: true, highlight: true, value: \{ fr: '[^']+', en: '[^']+' \} \}/g,
  "{ id: 'client_slots', name: { fr: 'Profils / Slots clients gérés', en: 'Managed client slots' }, included: true, highlight: true, value: { fr: '10 profils clients max', en: '10 client slots max' } }"
);

fs.writeFileSync(filePath, code, 'utf8');
console.log('Fixed client_slots in planConfigService.ts');
