#!/bin/sh
# cf-dualstack-update.sh — FreeBSD, curl + jq
# Update multiple A (IPv4) & AAAA (IPv6) records in Cloudflare
# Log to syslog (/var/log/messages). Option: -q / --quiet = silent (log only).

set -eu

# ========= CONFIG =========
API_TOKEN="APIToken"
ZONE_ID="ZoneID"

PROXIED=true       # true=orange cloud, false=DNS only
TTL=120            # 1=auto, else seconds (>=120)
RECORDS="freebsd.my azmawee.freebsd.my emas.freebsd.my"

CF_API="https://api.cloudflare.com/client/v4"

# ========= OPTIONS =========
QUIET=0
[ "${1:-}" = "-q" ] || [ "${1:-}" = "--quiet" ] && QUIET=1

log() {
  msg="$*"
  logger -t cf-ddns "$msg"
  [ "$QUIET" -eq 0 ] && echo "$msg"
}

# ========= REQS =========
need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing $1"; exit 1; }; }
need curl; need jq
auth_hdr() { printf "%s\n" "Authorization: Bearer ${API_TOKEN}"; }

# ========= IP DISCOVERY =========
get_ipv4() {
  for url in "https://ifconfig.co" "https://api.ipify.org" "https://ipv4.icanhazip.com"; do
    v4=$(curl -4 -fsS "$url" 2>/dev/null || true)
    v4=$(printf "%s" "$v4" | tr -d '\r\n[:space:]')
    if printf "%s" "$v4" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'; then
      printf "%s" "$v4"; return 0
    fi
  done
  return 1
}

get_ipv6() {
  for url in "https://ifconfig.co" "https://api64.ipify.org" "https://ipv6.icanhazip.com"; do
    v6=$(curl -6 -fsS "$url" 2>/dev/null || true)
    v6=$(printf "%s" "$v6" | tr -d '\r\n[:space:]')
    if printf "%s" "$v6" | grep -Ei '^[0-9a-f:]+$' >/dev/null 2>&1 && printf "%s" "$v6" | grep -q ':'; then
      printf "%s" "$v6"; return 0
    fi
  done
  return 1
}

# ========= CF HELPERS =========
get_record_id() {
  name="$1"; type="$2"
  curl -fsS -H "$(auth_hdr)" -H "Content-Type: application/json" \
    "${CF_API}/zones/${ZONE_ID}/dns_records?type=${type}&name=${name}" \
    | jq -r '.result[0].id // empty'
}

create_record() {
  name="$1"; type="$2"; content="$3"
  curl -fsS -X POST -H "$(auth_hdr)" -H "Content-Type: application/json" \
    "${CF_API}/zones/${ZONE_ID}/dns_records" \
    --data "{\"type\":\"${type}\",\"name\":\"${name}\",\"content\":\"${content}\",\"ttl\":${TTL},\"proxied\":${PROXIED}}" >/dev/null
  log "Created ${type} ${name} -> ${content}"
}

update_record() {
  rec_id="$1"; name="$2"; type="$3"; content="$4"
  curl -fsS -X PUT -H "$(auth_hdr)" -H "Content-Type: application/json" \
    "${CF_API}/zones/${ZONE_ID}/dns_records/${rec_id}" \
    --data "{\"type\":\"${type}\",\"name\":\"${name}\",\"content\":\"${content}\",\"ttl\":${TTL},\"proxied\":${PROXIED}}" >/dev/null
  log "Updated ${type} ${name} -> ${content}"
}

upsert_record() {
  name="$1"; type="$2"; content="$3"
  rec_id="$(get_record_id "$name" "$type" || true)"
  if [ -n "${rec_id:-}" ]; then
    cur_content=$(curl -fsS -H "$(auth_hdr)" -H "Content-Type: application/json" \
      "${CF_API}/zones/${ZONE_ID}/dns_records/${rec_id}" | jq -r '.result.content // empty')
    if [ "$cur_content" = "$content" ]; then
      log "No change ${type} ${name} (already ${content})"
    else
      update_record "$rec_id" "$name" "$type" "$content"
    fi
  else
    create_record "$name" "$type" "$content"
  fi
}

# ========= MAIN =========
V4=""; V6=""

if V4=$(get_ipv4); then
  log "Detected IPv4: ${V4}"
else
  log "WARN: IPv4 not detected, will skip A records"
fi

if V6=$(get_ipv6); then
  log "Detected IPv6: ${V6}"
else
  log "INFO: IPv6 not detected, will skip AAAA records"
fi

for host in $RECORDS; do
  [ -n "${V4:-}" ] && upsert_record "$host" "A"    "$V4"
  [ -n "${V6:-}" ] && upsert_record "$host" "AAAA" "$V6"
done

