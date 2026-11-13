#!/usr/bin/env node
// Versionnage automatique de l'app mobile Kauri (exécuté par .github/workflows/release.yml).
//
// À partir des commits (Conventional Commits) depuis la dernière version publiée :
//  1. calcule la version : BREAKING CHANGE / « type! » → majeure, feat → mineure, sinon correctif ;
//  2. attribue l'édition : nouvelle constellation pour une majeure/mineure, même édition pour un correctif ;
//  3. incrémente le numéro de build (versionCode Android / CFBundleVersion iOS), toujours
//     supérieur au précédent ET au dernier build connu des stores (LATEST_STORE_BUILD) ;
//  4. met à jour pubspec.yaml, release/versions.json, lib/core/config/app_release.dart ;
//  5. génère CHANGELOG.md (FR + EN), RELEASE_NOTES.md (FR + EN) et release_notes.json
//     (lu automatiquement par Codemagic pour les notes App Store / Play Store).
//
// Rédaction : si GEMINI_API_KEY est défini, Gemini rédige le changelog et les notes de
// store en français et en anglais (texte pour les utilisateurs) ; sinon repli
// déterministe à partir des messages de commit. Aucune donnée personnelle n'est envoyée
// (seulement les sujets de commit).
//
// Usage : node tool/release/release.mjs [--dry-run]
// Sorties (GITHUB_OUTPUT) : released, version, build, edition, tag, title.

import { execFileSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';

const ROOT = path.resolve(path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, '$1')), '..', '..');
const DRY = process.argv.includes('--dry-run');
const P = (...p) => path.join(ROOT, ...p);
const PLAY_LIMIT = 500; // limite Google Play « Nouveautés » (caractères)

const git = (...args) => execFileSync('git', args, { cwd: ROOT, encoding: 'utf8' }).trim();
const out = (k, v) => {
  if (process.env.GITHUB_OUTPUT) fs.appendFileSync(process.env.GITHUB_OUTPUT, `${k}=${v}\n`);
};

// ------------------------------------------------------------------ état
const historyFile = P('release', 'versions.json');
const history = JSON.parse(fs.readFileSync(historyFile, 'utf8'));
const last = history.releases[history.releases.length - 1];
const editions = JSON.parse(fs.readFileSync(P('tool', 'release', 'editions.json'), 'utf8')).editions;

const pubspecPath = P('pubspec.yaml');
const pubspec = fs.readFileSync(pubspecPath, 'utf8');
const m = pubspec.match(/^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)\s*$/m);
if (!m) throw new Error('pubspec.yaml : ligne « version: X.Y.Z+N » introuvable');
const pubBuild = Number(m[4]);

// ------------------------------------------------------------------ commits
const SEP = '\x1f';
const END = '\x1e';
// Depuis le tag de la dernière version (ou le commit de référence pour la toute première).
const since = last.tag || last.commit;
try {
  git('rev-parse', '--verify', '--quiet', `${since}^{commit}`);
} catch {
  throw new Error(`Référence de la dernière version introuvable (${since}) : le tag a-t-il été poussé ? (git fetch --tags)`);
}
const raw = git('log', `${since}..HEAD`, '--no-merges', `--format=%H${SEP}%s${SEP}%b${END}`);
const commits = raw
  .split(END)
  .map((c) => c.trim())
  .filter(Boolean)
  .map((c) => {
    const [hash, subject, body = ''] = c.split(SEP);
    const cc = subject.match(/^(\w+)(?:\(([^)]+)\))?(!)?:\s*(.+)$/);
    return {
      hash: hash.slice(0, 7),
      type: cc ? cc[1].toLowerCase() : 'other',
      scope: cc?.[2] || '',
      breaking: Boolean(cc?.[3]) || /BREAKING[ -]CHANGE/.test(body),
      text: (cc ? cc[4] : subject).trim(),
    };
  })
  .filter((c) => !(c.type === 'chore' && c.scope === 'release'));

if (commits.length === 0) {
  console.log('Aucun commit depuis la dernière version : pas de nouvelle version.');
  out('released', 'false');
  process.exit(0);
}

// ------------------------------------------------------------------ version
const [lM, lm, lp] = last.version.split('.').map(Number);
const bump = commits.some((c) => c.breaking) ? 'major' : commits.some((c) => c.type === 'feat') ? 'minor' : 'patch';
const version =
  bump === 'major' ? `${lM + 1}.0.0` : bump === 'minor' ? `${lM}.${lm + 1}.0` : `${lM}.${lm}.${lp + 1}`;
const storeBuild = Number(process.env.LATEST_STORE_BUILD || 0);
const build = Math.max(pubBuild, Number(last.build), storeBuild) + 1;

let edition = last.edition;
if (bump !== 'patch' || !edition) {
  const used = new Set(history.releases.map((r) => r.edition).filter(Boolean));
  edition = editions.find((e) => !used.has(e));
  if (!edition) throw new Error('Plus aucun nom d’édition disponible : compléter tool/release/editions.json');
}
const tag = `v${version}`;
const title = `v${version} - ${edition} Edition`;
const date = new Date().toISOString().slice(0, 10);

// ------------------------------------------------------------------ contenu
const SECTIONS = [
  { key: 'feat', fr: 'Nouveautés', en: 'New features' },
  { key: 'fix', fr: 'Corrections', en: 'Bug fixes' },
  { key: 'perf', fr: 'Performances', en: 'Performance' },
  { key: 'security', fr: 'Sécurité', en: 'Security' },
  { key: 'improve', fr: 'Améliorations', en: 'Improvements' },
  { key: 'tech', fr: 'Technique', en: 'Technical' },
];
const sectionOf = (c) => {
  if (c.type === 'feat') return 'feat';
  if (c.type === 'fix') return /secur|sécur|vuln|cve/i.test(c.text + c.scope) ? 'security' : 'fix';
  if (c.type === 'perf') return 'perf';
  if (['refactor', 'style', 'ui', 'i18n', 'l10n'].includes(c.type) || (c.type === 'chore' && c.scope === 'deps'))
    return 'improve';
  return 'tech'; // ci, test, docs, build, chore…
};
const grouped = Object.fromEntries(SECTIONS.map((s) => [s.key, []]));
for (const c of commits) grouped[sectionOf(c)].push(c);

function fallbackContent() {
  const items = (lang) =>
    Object.fromEntries(SECTIONS.map((s) => [s.key, grouped[s.key].map((c) => c.text)]));
  const userFacing = ['feat', 'fix', 'perf', 'security', 'improve'];
  const notes = (lang) => {
    const head = lang === 'fr' ? `Kauri ${title}` : `Kauri ${title}`;
    const lines = grouped.feat.slice(0, 4).map((c) => `• ${c.text}`);
    const tail =
      lang === 'fr'
        ? 'Corrections et améliorations de stabilité et de performance.'
        : 'Bug fixes, stability and performance improvements.';
    return [head, ...lines, tail].join('\n');
  };
  return {
    changelog: { fr: items('fr'), en: items('en') },
    notes: { fr: notes('fr'), en: notes('en') },
    userFacing,
  };
}

async function aiContent() {
  const key = process.env.GEMINI_API_KEY;
  if (!key) return null;
  const list = commits.map((c) => `- [${sectionOf(c)}] ${c.type}${c.scope ? `(${c.scope})` : ''}: ${c.text}`).join('\n');
  const prompt = `Tu es le rédacteur des versions de Kauri, une application mobile de finances personnelles et de tontines (Cameroun).
Version : ${title} (${bump === 'major' ? 'majeure' : bump === 'minor' ? 'mineure' : 'correctif'}).
Commits (format [section] type(portée): sujet) :
${list}

Réponds UNIQUEMENT avec un JSON valide de cette forme :
{"changelog":{"fr":{"feat":[],"fix":[],"perf":[],"security":[],"improve":[],"tech":[]},"en":{...mêmes clés...}},
 "notes":{"fr":"...","en":"..."}}
Règles :
- changelog : une phrase claire par élément, regroupe les doublons, garde la section indiquée, français correct pour "fr", anglais naturel pour "en".
- notes : notes de version pour l'App Store et le Play Store, destinées aux UTILISATEURS (pas de jargon technique, pas de noms de fichiers, pas de "CI", "refactor", "deps") ; commence par "Kauri ${title}" sur la première ligne ; puces "• " ; ${PLAY_LIMIT - 20} caractères maximum chacune ; si rien de visible, une phrase sur la stabilité et les performances.`;
  try {
    const res = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${encodeURIComponent(key)}`,
      {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({
          contents: [{ role: 'user', parts: [{ text: prompt }] }],
          generationConfig: { responseMimeType: 'application/json', temperature: 0.3 },
        }),
        signal: AbortSignal.timeout(60000),
      },
    );
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    const text = data?.candidates?.[0]?.content?.parts?.[0]?.text;
    const parsed = JSON.parse(text);
    for (const lang of ['fr', 'en']) {
      if (typeof parsed?.notes?.[lang] !== 'string' || typeof parsed?.changelog?.[lang] !== 'object')
        throw new Error('réponse incomplète');
      for (const s of SECTIONS) parsed.changelog[lang][s.key] = (parsed.changelog[lang][s.key] || []).filter(Boolean);
    }
    return parsed;
  } catch (e) {
    console.warn(`Gemini indisponible (${e.message}) : rédaction de repli à partir des commits.`);
    return null;
  }
}

const clamp = (s, n) => (s.length <= n ? s : `${s.slice(0, n - 1).replace(/\s+\S*$/, '')}…`);

const content = (await aiContent()) || fallbackContent();
content.notes.fr = clamp(content.notes.fr.trim(), PLAY_LIMIT);
content.notes.en = clamp(content.notes.en.trim(), PLAY_LIMIT);

// ------------------------------------------------------------------ rendu
const renderChangelog = (lang) => {
  const parts = [];
  for (const s of SECTIONS) {
    const items = content.changelog[lang][s.key] || [];
    if (items.length) parts.push(`#### ${s[lang]}\n${items.map((i) => `- ${i}`).join('\n')}`);
  }
  return parts.join('\n\n') || (lang === 'fr' ? '- Maintenance.' : '- Maintenance.');
};

const changelogEntry = `## ${title} — ${date}

> Build ${build} · ${commits.length} commit(s) · ${bump === 'major' ? 'version majeure' : bump === 'minor' ? 'version mineure' : 'correctif'}

### 🇫🇷 Français

${renderChangelog('fr')}

### 🇬🇧 English

${renderChangelog('en')}
`;

const CHANGELOG_HEAD = `# Journal des modifications — Kauri mobile / Changelog

Généré automatiquement à chaque version publiée (\`tool/release/release.mjs\`). Ne pas modifier à la main.
Automatically generated for each released version. Do not edit by hand.
`;
const changelogPath = P('CHANGELOG.md');
const previous = fs.existsSync(changelogPath)
  ? fs.readFileSync(changelogPath, 'utf8').replace(/^[\s\S]*?(?=^## )/m, '')
  : '';
const changelog = `${CHANGELOG_HEAD}\n${changelogEntry}\n${previous.startsWith('## ') ? previous : ''}`.trimEnd() + '\n';

const releaseNotesMd = `# Notes de version / Release notes — ${title}

Générées automatiquement (\`tool/release/release.mjs\`) ; publiées sur l'App Store et le Play Store
par Codemagic via \`release_notes.json\`.

## 🇫🇷 Français (fr-FR)

${content.notes.fr}

## 🇬🇧 English (en-US)

${content.notes.en}
`;

const releaseNotesJson = JSON.stringify(
  [
    { language: 'fr-FR', text: content.notes.fr },
    { language: 'en-US', text: content.notes.en },
    { language: 'en-GB', text: content.notes.en },
  ],
  null,
  2,
);

const appRelease = fs
  .readFileSync(P('lib', 'core', 'config', 'app_release.dart'), 'utf8')
  .replace(/static const String edition = '[^']*';/, `static const String edition = '${edition}';`);

history.releases.push({ version, build, edition, tag, date });

console.log(`${title} (build ${build}) — ${bump}, ${commits.length} commit(s)`);
console.log(`\nNotes FR (${content.notes.fr.length} car.) :\n${content.notes.fr}\n\nNotes EN (${content.notes.en.length} car.) :\n${content.notes.en}`);

if (DRY) {
  console.log('\n[--dry-run] Aucun fichier modifié.\n');
  console.log(changelogEntry);
  process.exit(0);
}

fs.writeFileSync(pubspecPath, pubspec.replace(m[0], `version: ${version}+${build}`));
fs.writeFileSync(changelogPath, changelog);
fs.writeFileSync(P('RELEASE_NOTES.md'), releaseNotesMd);
fs.writeFileSync(P('release_notes.json'), `${releaseNotesJson}\n`);
fs.writeFileSync(P('lib', 'core', 'config', 'app_release.dart'), appRelease);
fs.writeFileSync(historyFile, `${JSON.stringify(history, null, 2)}\n`);

out('released', 'true');
out('version', version);
out('build', String(build));
out('edition', edition);
out('tag', tag);
out('title', title);
