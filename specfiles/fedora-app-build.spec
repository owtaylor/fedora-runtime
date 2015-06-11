Name:           fedora-app-build
Version:        23
Release:        1%{?dist}
Summary:        Extra setup needed for building apps
BuildArch:      noarch

License:        GPL

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

%files

%changelog
* Wed Jun  3 2015 Alexander Larsson <alexl@redhat.com>
- Initial version
