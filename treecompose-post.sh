#!/usr/bin/env bash

set -e
# Work around /var/lib/machines being a btrfs volume
btrfs subvolume delete /var/lib/machines || true
mkdir -p /var/lib/machines

# Non writable directories are a pain in the ass since xdg-app rm -rf
# can't remove files in them
find /usr -type d -exec chmod u+w {} \;

mkdir -p /usr/cache/fontconfig
mkdir -p  /etc/fonts/conf.d

cat <<__EOF__ > /etc/fonts/conf.d/50-xdg-app.conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
        <cachedir>/usr/cache/fontconfig</cachedir>

        <dir>/app/share/fonts</dir>
        <cachedir>/app/cache/fontconfig</cachedir>

        <include ignore_missing="yes">/app/etc/fonts/local.conf</include>

        <dir>/run/host/fonts</dir>
</fontconfig>
__EOF__

touch -d @0 /usr/share/fonts
touch -d @0 /usr/share/fonts/*
HOME=/root /usr/bin/fc-cache -fs

# TODO: This is inherited from fedora-atomic, but not right for desktop use
# See: https://bugzilla.redhat.com/show_bug.cgi?id=1051816
KEEPLANG=en_US
find /usr/share/locale -mindepth  1 -maxdepth 1 -type d -not -name "${KEEPLANG}" -exec rm -rf {} +
localedef --list-archive | grep -a -v ^"${KEEPLANG}" | xargs localedef --delete-from-archive
mv -f /usr/lib/locale/locale-archive /usr/lib/locale/locale-archive.tmpl
build-locale-archive
