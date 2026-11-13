#!/usr/bin/env bash
# Notification Slack (#deployment) HOMOGÈNE pour tous les pipelines Kauri (API, admin, mobile).
#
# Variables d'environnement :
#   SLACK_WEBHOOK  webhook entrant du canal #deployment (absent → notification ignorée)
#   STATUS         success | failure | cancelled   (en général ${{ job.status }})
#   COMPONENT      ex. "API", "Admin", "Mobile Android", "Mobile iOS", "Mobile"
#   ACTION         ex. "Déploiement", "Distribution aux testeurs", "Nouvelle version"
#   ENVIRONMENT    ex. "STAGING", "PRODUCTION"
#   VERSION        ex. "20261113.2", "v4.1.0 - Orion Edition (build 34)"
#   LINK           (optionnel) adresse de l'environnement ou de la distribution
#   DETAILS        (optionnel) texte libre affiché sous le résumé (notes de version…)
#   COMMIT_MSG     (optionnel) message du commit déployé
set -euo pipefail

if [ -z "${SLACK_WEBHOOK:-}" ]; then
  echo "SLACK_DEPLOY_WEBHOOK_URL non défini : notification ignorée."
  exit 0
fi

case "${STATUS:-failure}" in
  success)   ICON="✅"; STATE="réussi" ;;
  cancelled) ICON="⚪"; STATE="annulé" ;;
  *)         ICON="❌"; STATE="ÉCHEC" ;;
esac

ENVIRONMENT="${ENVIRONMENT:-?}"
case "$ENVIRONMENT" in
  PRODUCTION) ENV_LABEL="🔴 PRODUCTION" ;;
  STAGING)    ENV_LABEL="🟡 STAGING (test)" ;;
  *)          ENV_LABEL="$ENVIRONMENT" ;;
esac

RUN_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}"
SHA="${GITHUB_SHA:0:7}"
COMMIT_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/commit/${GITHUB_SHA}"
FIRST_LINE="$(printf '%s' "${COMMIT_MSG:-}" | head -1 | cut -c1-150)"
TITLE="${ICON} Kauri ${COMPONENT:-?} — ${ACTION:-Déploiement} ${ENVIRONMENT} : ${STATE}"
NOW="$(TZ=Africa/Douala date '+%d/%m/%Y %H:%M')"

if [ "${STATUS:-failure}" != "success" ]; then
  HELP="Rien n'a été publié pour cette étape. Ouvrir le pipeline pour voir l'étape en échec."
else
  HELP=""
fi

jq -n \
  --arg title "$TITLE" \
  --arg env "$ENV_LABEL" \
  --arg version "${VERSION:-—}" \
  --arg branch "${GITHUB_REF_NAME:-—}" \
  --arg commit "<${COMMIT_URL}|${SHA}>${FIRST_LINE:+ — ${FIRST_LINE}}" \
  --arg actor "${GITHUB_ACTOR:-—}" \
  --arg link "${LINK:-}" \
  --arg details "${DETAILS:-}" \
  --arg help "$HELP" \
  --arg run "$RUN_URL" \
  --arg repo "${GITHUB_REPOSITORY}" \
  --arg now "$NOW" \
  '{
    text: $title,
    blocks: (
      [ { type: "header", text: { type: "plain_text", text: ($title | .[0:150]), emoji: true } },
        { type: "section", fields: [
            { type: "mrkdwn", text: ("*Environnement*\n" + $env) },
            { type: "mrkdwn", text: ("*Version*\n" + $version) },
            { type: "mrkdwn", text: ("*Branche*\n" + $branch) },
            { type: "mrkdwn", text: ("*Lancé par*\n" + $actor) } ] },
        { type: "section", text: { type: "mrkdwn", text: ("*Commit*\n" + $commit) } } ]
      + (if $link != "" then [ { type: "section", text: { type: "mrkdwn", text: ("*Lien*\n" + $link) } } ] else [] end)
      + (if $details != "" then [ { type: "section", text: { type: "mrkdwn", text: ($details | .[0:2900]) } } ] else [] end)
      + (if $help != "" then [ { type: "section", text: { type: "mrkdwn", text: ("⚠️ " + $help) } } ] else [] end)
      + [ { type: "actions", elements: [ { type: "button", text: { type: "plain_text", text: "Voir le pipeline" }, url: $run } ] },
          { type: "context", elements: [ { type: "mrkdwn", text: ($repo + " · GitHub Actions · " + $now) } ] } ]
    )
  }' > /tmp/slack-payload.json

curl -sS -X POST -H 'Content-type: application/json' --data @/tmp/slack-payload.json "$SLACK_WEBHOOK" >/dev/null
echo "Notification Slack envoyée : $TITLE"
