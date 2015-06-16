#!/bin/sh
if xdg-app list-remotes --user | grep fedora-local-build > /dev/null; then
    xdg-app update-runtime --user org.fedoraproject.Platform 23
    xdg-app update-runtime --user org.fedoraproject.Sdk 23
else
    xdg-app add-remote --no-gpg-verify --user fedora-local-build file://`pwd`/exportrepo
    xdg-app install-runtime --user fedora-local-build org.fedoraproject.Platform 23
    xdg-app install-runtime --user fedora-local-build org.fedoraproject.Sdk 23
fi

./build-app.sh evince org.gnome.evince --share=ipc --command=evince --socket=x11 --socket=wayland --socket=session-bus --filesystem=host
./build-app.sh gedit org.gnome.gedit --share=ipc --command=gedit --socket=x11 --socket=wayland --socket=session-bus --filesystem=host
ostree summary -u --repo=exportrepo

# Try with:
# xdg-app install-app --user fedora-local-build org.gnome.evince
# xdg-app install-app --user fedora-local-build org.gnome.gedit
