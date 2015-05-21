all: platform

PROXY=http://127.0.0.1:8123
VERSION=22

repo/config:
	ostree init --repo=repo --mode=bare-user

exportrepo/config:
	ostree init --repo=exportrepo --mode=archive-z2

repo/refs/heads/base/org.fedoraproject.Platform/x86_64/$(VERSION): repo/config fedora-runtime.json treecompose-post.sh group passwd
	rpm-ostree compose tree --proxy=$(PROXY) --repo=repo fedora-runtime.json


repo/refs/heads/runtime/org.fedoraproject.Platform/x86_64/$(VERSION): repo/refs/heads/base/org.fedoraproject.Platform/x86_64/$(VERSION)
	rm -rf platform
	mkdir -p platform
	cp metadata.platform platform/metadata
	ostree checkout --repo=repo --subpath=/usr -U base/org.fedoraproject.Platform/x86_64/$(VERSION) platform/files
	ostree commit --repo=repo --no-xattrs --owner-uid=0 --owner-gid=0 --link-checkout-speedup -s "Commit" --branch runtime/org.fedoraproject.Platform/x86_64/$(VERSION) platform

exportrepo/refs/heads/runtime/org.fedoraproject.Platform/x86_64/$(VERSION): repo/refs/heads/runtime/org.fedoraproject.Platform/x86_64/$(VERSION) exportrepo/config
	ostree pull-local --repo=exportrepo repo runtime/org.fedoraproject.Platform/x86_64/$(VERSION)

platform: exportrepo/refs/heads/runtime/org.fedoraproject.Platform/x86_64/$(VERSION)
