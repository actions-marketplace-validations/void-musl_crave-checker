#!/usr/bin/env bash
set -e

CURRENT_RUN_ID="$1"

if [ -z "$CURRENT_RUN_ID" ]; then
  echo "[Error]: Missing Current Run ID parameter."
  exit 1
fi

RUNS_JSON=$(gh run list --repo "$GITHUB_REPOSITORY" --status in_progress --json databaseId,name)

for row in $(echo "$RUNS_JSON" | jq -r '.[] | @base64'); do

  DECODED_ROW=$(echo "$row" | base64 --decode)
  LOOP_RUN_ID=$(echo "$DECODED_ROW" | jq -r '.databaseId')
  LOOP_RUN_NAME=$(echo "$DECODED_ROW" | jq -r '.name')

  if [ "$LOOP_RUN_ID" == "$CURRENT_RUN_ID" ]; then
    continue
  fi

  if [[ "$LOOP_RUN_NAME" == *"crave=active"* ]]; then
    echo "[Update]: Found another running build (ID: $LOOP_RUN_ID) with crave=active."
    echo "[Exec]: Stopping this run to avoid conflicts."
    exit 1
  fi

done

echo "[Update]: Checked all active builds. No crave=active runs found. Proceeding."
