#!/usr/bin/env node
// Notes « Nouveautés » des stores à partir de release_notes.json (généré par release.mjs).
//   node tool/release/whatsnew.mjs release_notes.json whatsnew       → whatsnew/whatsnew-<langue> (Google Play, 500 car. max)
//   node tool/release/whatsnew.mjs release_notes.json --print fr-FR  → texte d'une langue (TestFlight)
import fs from 'node:fs';
import path from 'node:path';

const [file, target, lang] = process.argv.slice(2);
const notes = JSON.parse(fs.readFileSync(file, 'utf8'));

if (target === '--print') {
  const n = notes.find((x) => x.language === lang) || notes[0];
  process.stdout.write(n.text);
} else {
  fs.mkdirSync(target, { recursive: true });
  for (const { language, text } of notes) {
    fs.writeFileSync(path.join(target, `whatsnew-${language}`), text.slice(0, 500));
    console.log(`${language} : ${Math.min(text.length, 500)} caractères`);
  }
}
