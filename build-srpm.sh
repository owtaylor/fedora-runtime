#!/bin/sh

set -x
mkdir -p rpms
mock -r fedora-app-23-x86_64.cfg --resultdir=rpms --rebuild "$@"
createrepo_c rpms
