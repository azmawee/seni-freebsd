#!/bin/bash
# Backup configs from FreeBSD server
set -euo pipefail
IFS=$'\n\t'

# Directories
backupdir="/conf_backup"
backupdir2="/maui9/conf_backup"
cp="/bin/cp -aLR"

# Ensure backupdir exists
mkdir -p "$backupdir/scripts" "$backupdir/root/dot.config" "$backupdir/root/dot.secrets" "$backupdir/root/dot.ssh" "$backupdir/root/dot.vnc"

# Define rsync sync function
_rsync() {
	rsync -vahrW --no-compress --delete "$backupdir/" "$backupdir2/"
}

# Root files
$cp /root/.cshrc "$backupdir/root/dot.cshrc" 2>/dev/null || true
$cp /root/.xinitrc "$backupdir/root/dot.xinitrc" 2>/dev/null || true
$cp /root/.my.cnf "$backupdir/root/dot.my.cnf" 2>/dev/null || true
$cp /root/.muttrc "$backupdir/root/dot.muttrc" 2>/dev/null || true
$cp /root/.mysql_secret "$backupdir/root/" 2>/dev/null || true
$cp /root/.tidal-dl.* "$backupdir/root/" 2>/dev/null || true
$cp /root/.secrets/* "$backupdir/root/dot.secrets/" 2>/dev/null || true
$cp /root/.config/* "$backupdir/root/dot.config/" 2>/dev/null || true
$cp /root/.ssh/* "$backupdir/root/dot.ssh/" 2>/dev/null || true
$cp /root/.vnc/* "$backupdir/root/dot.vnc/" 2>/dev/null || true
$cp /root/tidal-dl "$backupdir/root/" 2>/dev/null || true
$cp /usr/home/azmawee/.tmux.conf "$backupdir/root/dot.tmux.conf" 2>/dev/null || true

# Crontab
/usr/bin/crontab -l > "$backupdir/crontab-root" || true

# Core configs
core_files=(
	"/usr/home/root/.config/rclone/rclone.conf"
	"/boot/loader.conf"
	"/etc/sysctl.conf"
	"/etc/rtadvd.conf"
	"/etc/fstab"
	"/etc/fstab-hdd"
	"/etc/pf.conf"
	"/etc/hosts"
	"/etc/resolv.conf"
	"/etc/make.conf"
	"/etc/group"
	"/etc/passwd"
	"/etc/profile"
	"/etc/sec.conf"
	"/etc/sec.flags"
	"/etc/syslog.conf"
	"/etc/newsyslog.conf"
	"/etc/login.conf"
	"/httpd.conf"
	"/httpd-mpm.conf"
	"/usr/local/etc/mysql/conf.d/server.cnf"
	"/etc/rc.conf"
	"/etc/rc.local"
	"/etc/ssh/sshd_config"
	"/usr/share/skel"
	"/etc/ppp"
	"/usr/local/etc/namedb/named.conf"
)

for file in "${core_files[@]}"; do
	$cp "$file" "$backupdir/" 2>/dev/null || true
done

# Services config
$cp /usr/local/etc/{mpd5,smb4.conf,sudo.conf,sudoers,pkg.conf,php.ini,php.conf} "$backupdir" 2>/dev/null || true
$cp /usr/local/etc/{dhcpd.conf,dhcpd6.conf,dhcp6c.conf,ddclient.conf,nikto.conf,miniupnpd.conf} "$backupdir" 2>/dev/null || true
$cp /usr/local/etc/apcupsd/apcupsd.conf "$backupdir" 2>/dev/null || true
$cp /usr/local/etc/squid/squid.conf "$backupdir" 2>/dev/null || true
$cp /usr/local/etc/transmission/home/settings.json "$backupdir/transmission.settings.json" 2>/dev/null || true
$cp /usr/local/etc/urbackup/urbackupsrv.conf "$backupdir" 2>/dev/null || true
$cp /usr/local/etc/AdGuardHome.yaml "$backupdir" 2>/dev/null || true
$cp /maui6/vm/win10/win10.conf "$backupdir" 2>/dev/null || true

# UPS configs (NUT)
nut_files=(
	"ups.conf"
	"upsd.conf"
	"upsd.users"
	"upsmon.conf"
	"hosts.conf"
)

for f in "${nut_files[@]}"; do
	$cp "/usr/local/etc/nut/$f" "$backupdir/" 2>/dev/null || true
done

$cp /usr/local/bin/upssched "$backupdir/" 2>/dev/null || true

# Custom scripts
$cp /etc/*.sh "$backupdir/scripts/" 2>/dev/null || true
$cp /etc/*-rclone "$backupdir/scripts/" 2>/dev/null || true
$cp /etc/dyndns "$backupdir/scripts/" 2>/dev/null || true
$cp /etc/healthcheck "$backupdir/scripts/" 2>/dev/null || true
$cp /etc/internetcheck "$backupdir/scripts/" 2>/dev/null || true

# Permissions
chown -R nobody:azmawee "$backupdir"
chmod -R 771 "$backupdir"

# Final sync
_rsync

