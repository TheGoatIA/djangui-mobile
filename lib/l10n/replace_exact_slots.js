const fs = require('fs');
const filePath = 'd:/Projets/NodeJS/djangui-api/src/services/planConfigService.ts';
let code = fs.readFileSync(filePath, 'utf8');

// Replace all occurrences of '20 slots' or '20 slots clients' with '10 profils clients max'
code = code.split("'20 slots'").join("'10 profils clients max'");
code = code.split("'20 client slots'").join("'10 client slots max'");

fs.writeFileSync(filePath, code, 'utf8');
console.log('Successfully replaced 20 slots with 10 profils clients max');
