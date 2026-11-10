# Seni FreeBSD

Repo ini mengandungi configs dan scripts dari buku **FreeBSD - Seni Membina Rangkaian Rumah Moden**.

## Struktur

```
configs/
├── firewall/   # PF, SEC, miniUPnP (perimeter, NAT, blocking)
├── pppoe/      # PPPoE/mpd5, ppp, dhcp6c, ip-up/ip-down
├── web/        # Apache httpd
├── samba/      # Samba file sharing
└── system/     # rc.conf, sysctl.conf
scripts/        # cloudflare-ddns.sh, config_backup.sh
```

Semua fail adalah contoh untuk rujukan. Sesuaikan nilai (interface, IP, laluan, kredensial) dengan rangkaian rumah sendiri sebelum guna.
