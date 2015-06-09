#!/bin/sh

set -x
mock -r fedora-app-22-x86_64.cfg --clean
mock -r fedora-app-22-x86_64.cfg --install --disablerepo=fedora --disablerepo=updates "$@"
mock -r fedora-app-22-x86_64.cfg --shell "tar cvf /app.tar -C /app ."
mock -r fedora-app-22-x86_64.cfg  --copyout /app.tar .
