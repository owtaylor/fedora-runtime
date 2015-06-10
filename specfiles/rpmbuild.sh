#!/bin/sh
rpmbuild --define "_topdir `pwd`" --define "_srcrpmdir `pwd`/SRPMS" "$@"
