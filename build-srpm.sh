#!/bin/sh

set -x
mkdir -p rpms
mock -r fedora-app-22-x86_64.cfg --resultdir=rpms --rebuild "$@"
createrepo_c rpms
