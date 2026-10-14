#!/usr/bin/env bash
# Vérifie un plancher de couverture de lignes sur coverage/lcov.info (non-régression).
# usage: tool/check_coverage.sh [seuil_%=<MIN_COVERAGE>]
set -euo pipefail
MIN="${1:-${MIN_COVERAGE:-0}}"
LCOV="${LCOV_FILE:-coverage/lcov.info}"
[ -f "$LCOV" ] || { echo "::error::$LCOV introuvable (lancer flutter test --coverage)"; exit 1; }

# Exclut le code généré (non testable utilement) avant de sommer LF/LH.
read -r LF LH < <(awk '
  /^SF:/ { skip = ($0 ~ /\.g\.dart$|\.chopper\.dart$|\.freezed\.dart$|injection\.config\.dart$|firebase_options\.dart$|\/l10n\/|app_localizations/) }
  /^LF:/ && !skip { lf += substr($0, 4) }
  /^LH:/ && !skip { lh += substr($0, 4) }
  END { printf "%d %d\n", lf, lh }' "$LCOV")

if [ "$LF" -eq 0 ]; then echo "::error::aucune ligne instrumentée"; exit 1; fi
PCT=$(awk -v h="$LH" -v f="$LF" 'BEGIN { printf "%.2f", h * 100 / f }')
echo "Couverture de lignes (hors code généré) : ${PCT}%  (${LH}/${LF})  — plancher : ${MIN}%"
awk -v p="$PCT" -v m="$MIN" 'BEGIN { exit (p + 0 < m + 0) ? 1 : 0 }' \
  || { echo "::error::Couverture ${PCT}% < plancher ${MIN}%"; exit 1; }
