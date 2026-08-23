const fs = require('fs');
const path = require('path');

function fixMojibakeString(str) {
  // Map of UTF-8 byte sequences misinterpreted as Windows-1252 / ISO-8859-1
  const map = [
    ['ÃƒÆ’Ã‚Â©', 'é'],
    ['ÃƒÆ’Ã‚Â¨', 'è'],
    ['ÃƒÆ’Ã‚Â ', 'à'],
    ['ÃƒÆ’Ã‚Â¢', 'â'],
    ['ÃƒÆ’Ã‚Âª', 'ê'],
    ['ÃƒÆ’Ã‚Â®', 'î'],
    ['ÃƒÆ’Ã‚Â´', 'ô'],
    ['ÃƒÆ’Ã‚Â§', 'ç'],
    ['ÃƒË†', 'È'],
    ['Ãƒâ€°', 'É'],
    ['Ãƒâ‚¬', 'À'],
    ['ÃƒÂ©', 'é'],
    ['ÃƒÂ¨', 'è'],
    ['ÃƒÂ ', 'à'],
    ['ÃƒÂ¢', 'â'],
    ['ÃƒÂª', 'ê'],
    ['ÃƒÂ®', 'î'],
    ['ÃƒÂ´', 'ô'],
    ['ÃƒÂ§', 'ç'],
    ['Ã©', 'é'],
    ['Ã¨', 'è'],
    ['Ã ', 'à'],
    ['Ã\u00a0', 'à'],
    ['Ã¢', 'â'],
    ['Ãª', 'ê'],
    ['Ã®', 'î'],
    ['Ã¯', 'ï'],
    ['Ã´', 'ô'],
    ['Ã¹', 'ù'],
    ['Ã»', 'û'],
    ['Ã§', 'ç'],
    ['Ã‰', 'É'],
    ['Ãˆ', 'È'],
    ['Ã€', 'À'],
    ['Ã‚', 'Â'],
    ['ÃŠ', 'Ê'],
    ['ÃŽ', 'Î'],
    ['Ã”', 'Ô'],
    ['Ã™', 'Ù'],
    ['Ã›', 'Û'],
    ['Ã‡', 'Ç'],
    ['â€™', "'"],
    ['â€“', '–'],
    ['â€”', '—'],
    ['â€¦', '…'],
    ['âš ', '⚠️'],
    ['âœ“', '✓'],
    ['Â«', '«'],
    ['Â»', '»'],
    ['Â°', '°'],
    ['Â', '']
  ];

  let res = str;
  for (const [bad, good] of map) {
    if (res.includes(bad)) {
      res = res.split(bad).join(good);
    }
  }
  return res;
}

const arbPath = path.join(__dirname, 'app_fr.arb');
let raw = fs.readFileSync(arbPath, 'utf8');

// Strip UTF-8 BOM if present
if (raw.charCodeAt(0) === 0xFEFF) {
  raw = raw.slice(1);
}

let fixed = fixMojibakeString(raw);

// Run a second pass just in case of nested mis-encodings
fixed = fixMojibakeString(fixed);

fs.writeFileSync(arbPath, fixed, { encoding: 'utf8' });
console.log('app_fr.arb completely cleaned and saved without BOM.');

// Also clean app_en.arb
const arbEnPath = path.join(__dirname, 'app_en.arb');
let rawEn = fs.readFileSync(arbEnPath, 'utf8');
if (rawEn.charCodeAt(0) === 0xFEFF) {
  rawEn = rawEn.slice(1);
}
let fixedEn = fixMojibakeString(fixMojibakeString(rawEn));
fs.writeFileSync(arbEnPath, fixedEn, { encoding: 'utf8' });
console.log('app_en.arb completely cleaned and saved without BOM.');
