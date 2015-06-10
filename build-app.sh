#!/bin/sh

RPM=$1
shift
DIR=$1
shift
set -e
set -x
mock -r fedora-app-22-x86_64.cfg --clean
mock -r fedora-app-22-x86_64.cfg --install --disablerepo=fedora --disablerepo=updates "$RPM"
mock -r fedora-app-22-x86_64.cfg --shell "tar cvf /app.tar /app"
mock -r fedora-app-22-x86_64.cfg  --copyout /app.tar .

xdg-app build $DIR tar xvCf / app.tar
rm app.tar
