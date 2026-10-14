const fs = require('fs');
const path = require('path');

function getAllFiles(dir) {
  let results = [];
  const list = fs.readdirSync(dir);
  list.forEach(file => {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);
    if (stat && stat.isDirectory()) {
      results = results.concat(getAllFiles(filePath));
    } else if (file.endsWith('.dart') || file.endsWith('.arb')) {
      results.push(filePath);
    }
  });
  return results;
}

const files = getAllFiles('d:/Projets/Flutter/djangui-mobile/lib');
let fixedFiles = 0;

for (const file of files) {
  let content = fs.readFileSync(file, 'utf8');
  let original = content;

  // Additional corrupted forms (including non-breaking space after A tilde)
  const map = [
    ['Ã\u00a0', 'à'],
    ['Ã ', 'à'],
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
    ['Ã©', 'é'],
    ['Ã¨', 'è'],
    ['Ã¢', 'â'],
    ['Ãª', 'ê'],
    ['Ã', 'à']
  ];

  for (const [bad, good] of map) {
    if (content.includes(bad)) {
      content = content.split(bad).join(good);
    }
  }

  if (content !== original) {
    fs.writeFileSync(file, content, { encoding: 'utf8' });
    console.log('Cleaned:', file);
    fixedFiles++;
  }
}

console.log('Cleaned files total:', fixedFiles);
