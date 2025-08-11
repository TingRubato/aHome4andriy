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

echo "== Checking AWS credentials (profile=$PROFILE) =="
if ! aws sts get-caller-identity --profile "$PROFILE" >/dev/null 2>&1; then
  echo "ERROR: Unable to validate credentials for profile '$PROFILE'." >&2
  echo "If using SSO: aws sso login --profile $PROFILE" >&2
  exit 2
fi

echo "== Deploying backend (appId=$APP_ID branch=$BRANCH region=$REGION profile=$PROFILE) =="
if [ -n "${CI:-}" ] || [ "${AMPLIFY_CI:-}" = "1" ]; then
  echo "Detected CI environment -> using pipeline-deploy"
  AWS_PROFILE="$PROFILE" AWS_REGION="$REGION" AWS_BRANCH="$BRANCH" AWS_APP_ID="$APP_ID" bash -c '
  if command -v ampx >/dev/null 2>&1; then
    ampx pipeline-deploy --branch "$AWS_BRANCH" --app-id "$AWS_APP_ID"
  else
    npx ampx pipeline-deploy --branch "$AWS_BRANCH" --app-id "$AWS_APP_ID"
  fi
  '
else
  echo "Local shell detected -> using sandbox (hot deploy)"
  AWS_PROFILE="$PROFILE" AWS_REGION="$REGION" AWS_BRANCH="$BRANCH" AWS_APP_ID="$APP_ID" bash -c '
  if command -v ampx >/dev/null 2>&1; then
    ampx sandbox --outputs-format json --outputs-version 1.2 --outputs-out-dir .
  else
    npx ampx sandbox --outputs-format json --outputs-version 1.2 --outputs-out-dir .
  fi
  '
fi || {
  rc=$?
  echo "Backend deploy failed (exit $rc). Common causes:" >&2
  echo "  - Expired SSO session (aws sso login --profile $PROFILE)" >&2
  echo "  - Missing permissions for SSM / CloudFormation / AppSync" >&2
  echo "  - Incorrect appId or region (current: $APP_ID / $REGION)" >&2
  echo "  - Attempted pipeline-deploy locally (use sandbox)" >&2
  exit $rc
}

echo "== Building frontend =="
npm run build

echo "Done. If using Amplify hosting with this app/branch, upload dist/ or let connected repo build pipeline handle it."
