#!/bin/sh
set -e

OPTS=/data/options.json

# Read an add-on option; prints an empty string if unset/null (works for booleans too)
opt() {
    jq -r --arg k "$1" 'if has($k) and .[$k] != null then .[$k] else "" end' "$OPTS"
}

# --- Secret key: use the option if set, otherwise generate once and persist ---
SECRET_VAL="$(opt secret)"
if [ -z "$SECRET_VAL" ]; then
    if [ ! -f /data/secret ]; then
        head -c 48 /dev/urandom | base64 | tr -d '\n=+/' > /data/secret
    fi
    SECRET_VAL="$(cat /data/secret)"
fi
export SECRET="$SECRET_VAL"

# --- Other options -> Yamtrack environment variables ---
TZ_VAL="$(opt timezone)";           export TZ="${TZ_VAL:-UTC}"
URLS_VAL="$(opt urls)";             [ -n "$URLS_VAL" ] && export URLS="$URLS_VAL"
TMDB_VAL="$(opt tmdb_api_key)";     [ -n "$TMDB_VAL" ] && export TMDB_API="$TMDB_VAL"
REG_VAL="$(opt registration)";      [ -n "$REG_VAL" ] && export REGISTRATION="$REG_VAL"

export PUID=1000
export PGID=1000

# --- Persist the SQLite database in the add-on's /data (included in HA backups) ---
mkdir -p /data/db /data/redis
if [ ! -L /yamtrack/db ]; then
    rm -rf /yamtrack/db
    ln -s /data/db /yamtrack/db
fi
chown -R "${PUID}:${PGID}" /data/db

# --- Start Redis locally (cache/task broker only, so no persistence needed) ---
redis-server --bind 127.0.0.1 --port 6379 --dir /data/redis \
    --save "" --appendonly no --daemonize yes
for i in $(seq 1 20); do
    redis-cli -h 127.0.0.1 ping >/dev/null 2>&1 && break
    sleep 0.5
done
export REDIS_URL="redis://127.0.0.1:6379"

# --- Hand over to the upstream Yamtrack entrypoint ---
exec /entrypoint.sh
