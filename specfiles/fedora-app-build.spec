Name:           fedora-app-build
Version:        22
Release:        3%{?dist}
Summary:        Extra setup needed for building apps
BuildArch:      noarch

License:        GPL

# No need to pull in the real backgrounds in an app
Provides: system-backgrounds-gnome

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
