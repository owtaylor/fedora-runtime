Name:           fedora-app-build
Version:        23
Release:        4%{?dist}
Summary:        Extra setup needed for building apps
BuildArch:      noarch
Source1:        macros.xdg-app

License:        GPL

Requires:	fedora-runtime

# No need to pull in the real backgrounds in an app
Provides: system-backgrounds-gnome
# We include gvfs-client, but the gvfs part is on the host side
Provides: gvfs

%description
Workarounds for building apps

%prep

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/rpm
install -t $RPM_BUILD_ROOT%{_sysconfdir}/rpm -m 644 %{SOURCE1}

%files
%{_sysconfdir}/rpm/*

%changelog
* Wed Jun  3 2015 Alexander Larsson <alexl@redhat.com>
- Initial version
