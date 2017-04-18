Name:           fedora-app-build
Version:        24
Release:        1%{?dist}
Summary:        Extra setup needed for building apps
BuildArch:      noarch
Source1:        macros.xdg-app
Source2:        fedora-app-create

License:        GPL

Requires:	fedora-runtime

# No need to pull in the real backgrounds in an app
Provides: system-backgrounds-gnome

# This package is designed *not* to relocate properly into /app, since it's
# used to build aps, not to run in them
%define _prefix /usr
%define _sysconfdir /etc

%description
Workarounds for building apps

%package utils
Summary: Utility programs to build final app images

Requires: xdg-app tar python desktop-file-utils

%description utils
This subpackage contains the fedora-app-create tool for creating
a final app image out of a tarball of the contents.

%prep

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/rpm
install -t $RPM_BUILD_ROOT%{_sysconfdir}/rpm -m 644 %{SOURCE1}

mkdir -p $RPM_BUILD_ROOT%{_bindir}
install -t $RPM_BUILD_ROOT%{_bindir} -m 755 %{SOURCE2}

%files
%{_sysconfdir}/rpm/*

%files utils
%{_bindir}/fedora-app-create

%changelog
* Wed Apr 20 2016 Owen Taylor <otaylor@redhat.com> - 24-1
- Fix problem with excludes
- Redefine macros so doesn't rebuild to /app
- Add the -utils subpackage
- Suffix dist with ~app
- Change macros not to suffix %%dist

* Thu Apr  7 2016 Owen Taylor <otaylor@redhat.com> - 23-5
- Make the gvfs provides versioned to avoid problems with a manual
  Conflicts: gvfs < 1.25.2-2 in the gvfs-client packaging

* Wed Jun  3 2015 Alexander Larsson <alexl@redhat.com>
- Initial version
