#!/usr/bin/env bash
set -u
cd "$(dirname "$0")"

COLLECTION="DummyJSON Auth Testing.postman_collection.json"
ENVIRONMENT="DummyJSON.postman_environment.json"

command -v newman >/dev/null 2>&1 || npm install -g newman newman-reporter-htmlextra

rm -rf newman

newman run "$COLLECTION" \
  -e "$ENVIRONMENT" \
  -r cli,htmlextra \
  --reporter-htmlextra-export "newman/report.html" \
  --reporter-htmlextra-title "DummyJSON Auth Testing"

STATUS=$?
echo ""
echo "Laporan: newman/report.html"
exit $STATUS