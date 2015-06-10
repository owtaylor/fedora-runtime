all: platform sdk

PROXY=
VERSION=22
ARCH=x86_64

repo/config:
	ostree init --repo=repo --mode=bare-user

exportrepo/config:
	ostree init --repo=exportrepo --mode=archive-z2

repo/refs/heads/base/org.fedoraproject.Platform/$(ARCH)/$(VERSION): repo/config fedora-runtime.json treecompose-post.sh group passwd
	rpm-ostree compose tree --force-nocache $(PROXY) --repo=repo fedora-runtime.json

repo/refs/heads/base/org.fedoraproject.Sdk/$(ARCH)/$(VERSION): repo/config fedora-sdk.json fedora-runtime.json treecompose-post.sh group passwd
	rpm-ostree compose tree --force-nocache $(PROXY) --repo=repo fedora-sdk.json

repo/refs/heads/runtime/org.fedoraproject.Platform/$(ARCH)/$(VERSION): repo/refs/heads/base/org.fedoraproject.Platform/$(ARCH)/$(VERSION)
	./commit-subtree.sh base/org.fedoraproject.Platform/$(ARCH)/$(VERSION) runtime/org.fedoraproject.Platform/$(ARCH)/$(VERSION) metadata.platform /usr files

repo/refs/heads/runtime/org.fedoraproject.Platform.Var/$(ARCH)/$(VERSION): repo/refs/heads/base/org.fedoraproject.Platform/$(ARCH)/$(VERSION)
	./commit-subtree.sh base/org.fedoraproject.Platform/$(ARCH)/$(VERSION) runtime/org.fedoraproject.Platform.Var/$(ARCH)/$(VERSION) metadata.platform /var files  /usr/share/rpm files/lib/rpm

repo/refs/heads/runtime/org.fedoraproject.Sdk/$(ARCH)/$(VERSION): repo/refs/heads/base/org.fedoraproject.Sdk/$(ARCH)/$(VERSION)
	./commit-subtree.sh base/org.fedoraproject.Sdk/$(ARCH)/$(VERSION) runtime/org.fedoraproject.Sdk/$(ARCH)/$(VERSION) metadata.sdk /usr files

repo/refs/heads/runtime/org.fedoraproject.Sdk.Var/$(ARCH)/$(VERSION): repo/refs/heads/base/org.fedoraproject.Sdk/$(ARCH)/$(VERSION)
	./commit-subtree.sh base/org.fedoraproject.Sdk/$(ARCH)/$(VERSION) runtime/org.fedoraproject.Sdk.Var/$(ARCH)/$(VERSION) metadata.sdk /var files /usr/share/rpm files/lib/rpm

exportrepo/refs/heads/runtime/org.fedoraproject.Platform/$(ARCH)/$(VERSION): repo/refs/heads/runtime/org.fedoraproject.Platform/$(ARCH)/$(VERSION) exportrepo/config
	ostree pull-local --repo=exportrepo repo runtime/org.fedoraproject.Platform/$(ARCH)/$(VERSION)

exportrepo/refs/heads/runtime/org.fedoraproject.Platform.Var/$(ARCH)/$(VERSION): repo/refs/heads/runtime/org.fedoraproject.Platform.Var/$(ARCH)/$(VERSION) exportrepo/config
	ostree pull-local --repo=exportrepo repo runtime/org.fedoraproject.Platform.Var/$(ARCH)/$(VERSION)

exportrepo/refs/heads/runtime/org.fedoraproject.Sdk/$(ARCH)/$(VERSION): repo/refs/heads/runtime/org.fedoraproject.Sdk/$(ARCH)/$(VERSION) exportrepo/config
	ostree pull-local --repo=exportrepo repo runtime/org.fedoraproject.Sdk/$(ARCH)/$(VERSION)

exportrepo/refs/heads/runtime/org.fedoraproject.Sdk.Var/$(ARCH)/$(VERSION): repo/refs/heads/runtime/org.fedoraproject.Sdk.Var/$(ARCH)/$(VERSION) exportrepo/config
	ostree pull-local --repo=exportrepo repo runtime/org.fedoraproject.Sdk.Var/$(ARCH)/$(VERSION)

platform: exportrepo/refs/heads/runtime/org.fedoraproject.Platform/$(ARCH)/$(VERSION) exportrepo/refs/heads/runtime/org.fedoraproject.Platform.Var/$(ARCH)/$(VERSION)

sdk: exportrepo/refs/heads/runtime/org.fedoraproject.Sdk/$(ARCH)/$(VERSION) exportrepo/refs/heads/runtime/org.fedoraproject.Sdk.Var/$(ARCH)/$(VERSION)

clean:
	rm -rf repo exportrepo .commit-*
