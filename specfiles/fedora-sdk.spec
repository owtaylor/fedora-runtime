Name:           fedora-sdk
Version:        22
Release:        2%{?dist}
Summary:        An xdg-app sdk runtime based on fedora
BuildArch:      noarch

License:        GPL

Requires:       fedora-runtime
Requires:       valgrind
Requires:       strace
Requires:       gdb
Requires:       cpio
Requires:       patchelf
Requires:       rpm-build
Requires:       dnf
Requires:       dnf-plugins-core
Requires:       python-dnf

%description
An xdg-app sdk for the fedora runtime

%prep


%build


%install
rm -rf $RPM_BUILD_ROOT


%files

%changelog
* Wed Jun  3 2015 Alexander Larsson <alexl@redhat.com>
- Initial version
