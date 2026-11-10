#!/bin/sh

# Lokasi fail untuk table bogons
BOGON_FILE="/etc/pf.bogons"
BOGON_URL="https://team-cymru.org/Services/Bogons/fullbogons-ipv4.txt"

# Flag senyap
SILENT=0
[ "$1" = "--silent" ] && SILENT=1

# Fungsi log
log() {
  [ $SILENT -eq 0 ] && echo "$@"
}

log "[INFO] Muat turun senarai bogon..."
fetch -q -o "$BOGON_FILE" "$BOGON_URL" || {
  echo "[ERROR] Gagal muat turun dari $BOGON_URL" >&2
  exit 1
}

log "[INFO] Apply ke pf..."
pfctl -t bogons -T replace -f "$BOGON_FILE" && log "[OK] Table bogons dikemaskini."

