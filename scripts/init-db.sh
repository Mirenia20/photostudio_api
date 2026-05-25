#!/usr/bin/env bash
set -euo pipefail

DB_FILE="db/photostudio.db"

mkdir -p db
rm -f "$DB_FILE"

sqlite3 "$DB_FILE" < db/schema.sql
sqlite3 "$DB_FILE" < db/seed.sql

echo "[OK] Database created: $DB_FILE"
sqlite3 "$DB_FILE" ".tables"
