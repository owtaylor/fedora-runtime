#!/bin/sh

set -x
mkdir -p rpms
createrepo_c rpms
mock -r fedora-app-23-x86_64.cfg --clean
mock -r fedora-app-23-x86_64.cfg  --copyin app-list-required-pkg /
mock -r fedora-app-23-x86_64.cfg --shell "/usr/bin/python /app-list-required-pkg $@"
