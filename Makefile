all: platform sdk

PROXY=
VERSION=22
ARCH=x86_64

local.repo: local.repo.in
	sed s_@builddir@_$(CURDIR)_ local.repo.in > local.repo

rpms/fedora-runtime-tag: fedora-runtime.spec fedora-22-x86_64.cfg
	mkdir -p rpms
	rm -rf tmp_srpm
	mkdir -p tmp_srpm rpms
	rm -f srpm/fedora-runtime*.src.rpm
	mock -r fedora-22-x86_64.cfg --resultdir=tmp_srpm --buildsrpm --sources . --spec fedora-runtime.spec
	mock --configdir=. -r fedora-22-x86_64.cfg --resultdir=rpms --rebuild tmp_srpm/fedora-runtime-*.src.rpm
	rm -rf tmp_srpm
	createrepo_c rpms
	touch rpms/fedora-runtime-tag

rpms/fedora-sdk-tag: fedora-runtime.spec fedora-sdk.spec fedora-22-x86_64.cfg
	mkdir -p rpms
	rm -rf tmp_srpm
	mkdir -p tmp_srpm rpms
	rm -f srpm/fedora-sdk*.src.rpm
	mock -r fedora-22-x86_64.cfg --resultdir=tmp_srpm --buildsrpm --sources . --spec fedora-sdk.spec
	mock --configdir=. -r fedora-22-x86_64.cfg --resultdir=rpms --rebuild tmp_srpm/fedora-sdk-*.src.rpm
	rm -rf tmp_srpm
	createrepo_c rpms
	touch rpms/fedora-sdk-tag

rpms/fedora-app-build-tag: fedora-app-build.spec app-list-required-pkg fedora-22-x86_64.cfg
	mkdir -p rpms
	rm -rf tmp_srpm
	mkdir -p tmp_srpm rpms
	rm -f srpm/fedora-app-build*.src.rpm
	mock -r fedora-22-x86_64.cfg --resultdir=tmp_srpm --buildsrpm --sources . --spec fedora-app-build.spec
	mock --configdir=. -r fedora-22-x86_64.cfg --resultdir=rpms --rebuild tmp_srpm/fedora-app-build-*.src.rpm
	rm -rf tmp_srpm
	createrepo_c rpms
	touch rpms/fedora-app-build-tag

repo/config:
	ostree init --repo=repo --mode=bare-user

exportrepo/config:
	ostree init --repo=exportrepo --mode=archive-z2

repo/refs/heads/base/org.fedoraproject.Platform/$(ARCH)/$(VERSION): repo/config fedora-runtime.json local.repo rpms/fedora-runtime-tag treecompose-post.sh group passwd
	rpm-ostree compose tree $(PROXY) --repo=repo fedora-runtime.json


repo/refs/heads/runtime/org.fedoraproject.Platform/$(ARCH)/$(VERSION): repo/refs/heads/base/org.fedoraproject.Platform/$(ARCH)/$(VERSION)
	rm -rf platform
	mkdir -p platform
	cp metadata.platform platform/metadata
	ostree checkout --repo=repo --subpath=/usr -U base/org.fedoraproject.Platform/$(ARCH)/$(VERSION) platform/files
	ostree commit --repo=repo --no-xattrs --owner-uid=0 --owner-gid=0 --link-checkout-speedup -s "Commit" --branch runtime/org.fedoraproject.Platform/$(ARCH)/$(VERSION) platform

exportrepo/refs/heads/runtime/org.fedoraproject.Platform/$(ARCH)/$(VERSION): repo/refs/heads/runtime/org.fedoraproject.Platform/$(ARCH)/$(VERSION) exportrepo/config
	ostree pull-local --repo=exportrepo repo runtime/org.fedoraproject.Platform/$(ARCH)/$(VERSION)

repo/refs/heads/runtime/org.fedoraproject.Platform.Var/$(ARCH)/$(VERSION): repo/refs/heads/base/org.fedoraproject.Platform/$(ARCH)/$(VERSION)
	rm -rf platform-var
	mkdir -p platform-var
	cp metadata.platform platform-var/metadata
	ostree checkout --repo=repo --subpath=/var -U base/org.fedoraproject.Platform/$(ARCH)/$(VERSION) platform-var/files
	mkdir -p platform-var/files/lib
	ostree checkout --repo=repo --subpath=/usr/share/rpm -U base/org.fedoraproject.Platform/$(ARCH)/$(VERSION) platform-var/files/lib/rpm
	ostree commit --repo=repo --no-xattrs --owner-uid=0 --owner-gid=0 --link-checkout-speedup -s "Commit" --branch runtime/org.fedoraproject.Platform.Var/$(ARCH)/$(VERSION) platform-var

exportrepo/refs/heads/runtime/org.fedoraproject.Platform.Var/$(ARCH)/$(VERSION): repo/refs/heads/runtime/org.fedoraproject.Platform.Var/$(ARCH)/$(VERSION) exportrepo/config
	ostree pull-local --repo=exportrepo repo runtime/org.fedoraproject.Platform.Var/$(ARCH)/$(VERSION)

platform: exportrepo/refs/heads/runtime/org.fedoraproject.Platform/$(ARCH)/$(VERSION) exportrepo/refs/heads/runtime/org.fedoraproject.Platform.Var/$(ARCH)/$(VERSION)


repo/refs/heads/base/org.fedoraproject.Sdk/$(ARCH)/$(VERSION): repo/config fedora-sdk.json fedora-runtime.json local.repo rpms/fedora-sdk-tag treecompose-post.sh group passwd
	rpm-ostree compose tree $(PROXY) --repo=repo fedora-sdk.json


repo/refs/heads/runtime/org.fedoraproject.Sdk/$(ARCH)/$(VERSION): repo/refs/heads/base/org.fedoraproject.Sdk/$(ARCH)/$(VERSION)
	rm -rf sdk
	mkdir -p sdk
	cp metadata.sdk sdk/metadata
	ostree checkout --repo=repo --subpath=/usr -U base/org.fedoraproject.Sdk/$(ARCH)/$(VERSION) sdk/files
	ostree commit --repo=repo --no-xattrs --owner-uid=0 --owner-gid=0 --link-checkout-speedup -s "Commit" --branch runtime/org.fedoraproject.Sdk/$(ARCH)/$(VERSION) sdk

exportrepo/refs/heads/runtime/org.fedoraproject.Sdk/$(ARCH)/$(VERSION): repo/refs/heads/runtime/org.fedoraproject.Sdk/$(ARCH)/$(VERSION) exportrepo/config
	ostree pull-local --repo=exportrepo repo runtime/org.fedoraproject.Sdk/$(ARCH)/$(VERSION)

repo/refs/heads/runtime/org.fedoraproject.Sdk.Var/$(ARCH)/$(VERSION): repo/refs/heads/base/org.fedoraproject.Sdk/$(ARCH)/$(VERSION)
	rm -rf sdk-var
	mkdir -p sdk-var
	cp metadata.sdk sdk-var/metadata
	ostree checkout --repo=repo --subpath=/var -U base/org.fedoraproject.Sdk/$(ARCH)/$(VERSION) sdk-var/files
	mkdir -p sdk-var/files/lib
	ostree checkout --repo=repo --subpath=/usr/share/rpm -U base/org.fedoraproject.Sdk/$(ARCH)/$(VERSION) sdk-var/files/lib/rpm
	ostree commit --repo=repo --no-xattrs --owner-uid=0 --owner-gid=0 --link-checkout-speedup -s "Commit" --branch runtime/org.fedoraproject.Sdk.Var/$(ARCH)/$(VERSION) sdk-var

exportrepo/refs/heads/runtime/org.fedoraproject.Sdk.Var/$(ARCH)/$(VERSION): repo/refs/heads/runtime/org.fedoraproject.Sdk.Var/$(ARCH)/$(VERSION) exportrepo/config
	ostree pull-local --repo=exportrepo repo runtime/org.fedoraproject.Sdk.Var/$(ARCH)/$(VERSION)

sdk: exportrepo/refs/heads/runtime/org.fedoraproject.Sdk/$(ARCH)/$(VERSION) exportrepo/refs/heads/runtime/org.fedoraproject.Sdk.Var/$(ARCH)/$(VERSION)
