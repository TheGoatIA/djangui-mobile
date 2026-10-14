#!/usr/bin/env node
/**
 * Échoue si un plugin Flutter résolu exige un compileSdk supérieur au maximum supporté par la
 * toolchain Android du projet (AGP 8.11.x => API 36). Un plugin en compileSdk 37 (ex.
 * permission_handler_android 14.x) casse le build de release avec :
 *   "Failed to find target with hash string 'android-37'"
 *
 * usage: node tool/check_android_plugin_sdk.js [max=36] [package_config.json]
 */
const fs = require('fs');
const path = require('path');
const { fileURLToPath } = require('url');

const max = parseInt(process.argv[2] || '36', 10);
const cfgPath = process.argv[3] || '.dart_tool/package_config.json';
if (!fs.existsSync(cfgPath)) {
  console.error(`::error::${cfgPath} introuvable (lancer flutter pub get)`);
  process.exit(1);
}
const cfg = JSON.parse(fs.readFileSync(cfgPath, 'utf8'));
const base = path.dirname(path.resolve(cfgPath));

let worst = 0;
const bad = [];
for (const pkg of cfg.packages) {
  const root = pkg.rootUri.startsWith('file:') ? fileURLToPath(pkg.rootUri) : path.resolve(base, pkg.rootUri);
  for (const name of ['android/build.gradle', 'android/build.gradle.kts']) {
    const file = path.join(root, name);
    if (!fs.existsSync(file)) continue;
    const m = /compileSdk(?:Version)?\s*(?:=|\s)\s*(\d+)/.exec(fs.readFileSync(file, 'utf8'));
    if (!m) continue;
    const v = parseInt(m[1], 10);
    worst = Math.max(worst, v);
    if (v > max) bad.push({ name: pkg.name, v });
  }
}

console.log(`compileSdk maximal exigé par les plugins : ${worst} (limite toolchain : ${max})`);
if (bad.length) {
  for (const b of bad) {
    console.error(
      `::error::plugin ${b.name} exige compileSdk ${b.v} > ${max} — rétrograder ce plugin ` +
        `(Dependabot : ignorer sa majeure, voir .github/dependabot.yml)`,
    );
  }
  process.exit(1);
}
