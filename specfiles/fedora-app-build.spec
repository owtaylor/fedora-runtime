Name:           fedora-app-build
Version:        22
Release:        1%{?dist}
Summary:        Extra setup needed for building apps

License:        GPL

# No need to pull in the real backgrounds in an app
Provides: system-backgrounds-gnome

%description
Workarounds for building apps

%prep

%build

%install
rm -rf $RPM_BUILD_ROOT

mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/ld.so.conf.d/
echo "/app/%{_lib}" > $RPM_BUILD_ROOT%{_sysconfdir}/ld.so.conf.d/app.conf

%post -p /sbin/ldconfig

%files
%{_sysconfdir}/ld.so.conf.d/app.conf

%changelog
* Wed Jun  3 2015 Alexander Larsson <alexl@redhat.com>
- Initial version
