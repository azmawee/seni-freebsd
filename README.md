# Seni FreeBSD

Repo ini ialah koleksi contoh konfigurasi dan skrip sebenar daripada buku **FreeBSD - Seni Membina Rangkaian Rumah Moden**.

## Tentang buku

Buku ini adalah panduan praktikal membina rangkaian rumah moden menggunakan FreeBSD, bermula daripada pemasangan sistem sehingga servis harian. Antaranya PPPoE, firewall PF, Wi-Fi, DNS terenkripsi dan AdGuard Home, NAS, web server, VPN, backup server, bhyve, media server, pemantauan sistem dan keselamatan rangkaian.

Tujuan repo ini adalah supaya pembaca boleh melihat, menyalin dan menyesuaikan konfigurasi sebenar yang digunakan dalam buku, bukan sekadar membaca teori.

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

## Nota

Semua fail adalah contoh untuk rujukan. Nilai seperti interface, IP, laluan dan kredensial perlu disesuaikan dengan rangkaian rumah sendiri sebelum digunakan. Kredensial dalam repo ini telah diganti dengan placeholder.

## Penulis

- GitHub: [github.com/azmawee](https://github.com/azmawee)
- Facebook: [facebook.com/maui512gbram](https://facebook.com/maui512gbram)
