#!/usr/bin/env bash
set -euo pipefail

# Simple deploy orchestrator for Amplify Gen2 backend + static frontend
# Usage: ./scripts/deploy.sh [-b branch] [-a appId] [-r region]

BRANCH="main"
APP_ID="d1ntn929km6rwk"
REGION="us-east-1"
PROFILE="${AWS_PROFILE:-ByteCarnival}"

while getopts "b:a:r:p:h" opt; do
  case $opt in
    b) BRANCH="$OPTARG";;
    a) APP_ID="$OPTARG";;
    r) REGION="$OPTARG";;
    p) PROFILE="$OPTARG";;
    h)
      echo "Usage: $0 [-b branch] [-a appId] [-r region] [-p profile]"; exit 0;;
  esac
done

echo "== Deploying backend (appId=$APP_ID branch=$BRANCH region=$REGION profile=$PROFILE) =="
AWS_BRANCH="$BRANCH" AWS_APP_ID="$APP_ID" ampx pipeline-deploy --branch "$BRANCH" --app-id "$APP_ID" --region "$REGION" || {
  echo "Backend deploy failed" >&2; exit 1; }

echo "== Building frontend =="
npm run build

echo "Done. If using Amplify hosting with this app/branch, upload dist/ or let connected repo build pipeline handle it."
