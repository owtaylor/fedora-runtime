all: platform sdk

PROXY=--proxy=http://127.0.0.1:8123
VERSION=22
ARCH=x86_64

repo/config:
	ostree init --repo=repo --mode=bare-user

exportrepo/config:
	ostree init --repo=exportrepo --mode=archive-z2

repo/refs/heads/base/org.fedoraproject.Platform/$(ARCH)/$(VERSION): repo/config fedora-runtime.json treecompose-post.sh group passwd
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
	ostree checkout --repo=repo --subpath=/usr -U base/org.fedoraproject.Platform/$(ARCH)/$(VERSION) platform-var/files
	ostree commit --repo=repo --no-xattrs --owner-uid=0 --owner-gid=0 --link-checkout-speedup -s "Commit" --branch runtime/org.fedoraproject.Platform.Var/$(ARCH)/$(VERSION) platform-var

exportrepo/refs/heads/runtime/org.fedoraproject.Platform.Var/$(ARCH)/$(VERSION): repo/refs/heads/runtime/org.fedoraproject.Platform.Var/$(ARCH)/$(VERSION) exportrepo/config
	ostree pull-local --repo=exportrepo repo runtime/org.fedoraproject.Platform.Var/$(ARCH)/$(VERSION)

platform: exportrepo/refs/heads/runtime/org.fedoraproject.Platform/$(ARCH)/$(VERSION) exportrepo/refs/heads/runtime/org.fedoraproject.Platform.Var/$(ARCH)/$(VERSION)


repo/refs/heads/base/org.fedoraproject.Sdk/$(ARCH)/$(VERSION): repo/config fedora-sdk.json fedora-runtime.json treecompose-post.sh group passwd
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
	ostree checkout --repo=repo --subpath=/usr -U base/org.fedoraproject.Sdk/$(ARCH)/$(VERSION) sdk-var/files
	ostree commit --repo=repo --no-xattrs --owner-uid=0 --owner-gid=0 --link-checkout-speedup -s "Commit" --branch runtime/org.fedoraproject.Sdk.Var/$(ARCH)/$(VERSION) sdk-var

exportrepo/refs/heads/runtime/org.fedoraproject.Sdk.Var/$(ARCH)/$(VERSION): repo/refs/heads/runtime/org.fedoraproject.Sdk.Var/$(ARCH)/$(VERSION) exportrepo/config
	ostree pull-local --repo=exportrepo repo runtime/org.fedoraproject.Sdk.Var/$(ARCH)/$(VERSION)

sdk: exportrepo/refs/heads/runtime/org.fedoraproject.Sdk/$(ARCH)/$(VERSION) exportrepo/refs/heads/runtime/org.fedoraproject.Sdk.Var/$(ARCH)/$(VERSION)
