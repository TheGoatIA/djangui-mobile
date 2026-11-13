#!/usr/bin/env node
// Garde-fou des builds de PRODUCTION : refuse toute configuration qui ne vise pas
// l'API de production (ex. une URL de staging copiée par erreur dans un secret).
// Usage : node tool/release/check-prod-defines.mjs dart_defines.prod.json
import fs from 'node:fs';

const file = process.argv[2];
const d = JSON.parse(fs.readFileSync(file, 'utf8'));
const errors = [];
if (d.ENV !== 'production') errors.push(`ENV doit valoir "production" (reçu : ${d.ENV})`);
if (d.API_BASE_URL !== 'https://api.kauri-app.com/api/v1') {
  errors.push(`API_BASE_URL doit être https://api.kauri-app.com/api/v1 (reçu : ${d.API_BASE_URL})`);
}
if (errors.length) {
  for (const e of errors) console.error(`::error::${e}`);
  process.exit(1);
}
console.log(`Configuration de production OK : ${d.API_BASE_URL} (ENV=${d.ENV}, argent réel par défaut=${d.ENABLE_REAL_MONEY})`);
