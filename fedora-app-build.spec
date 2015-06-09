Name:           fedora-app-build
Version:        1.0
Release:        11%{?dist}
Summary:        Extra files needed for building apps
Source1:        app-list-required-pkg

License:        GPL

BuildRequires: glade-devel

# No need to pull in the real backgrounds in an app
Provides: system-backgrounds-gnome

%description
Workarounds for building apps

%prep

%build

%install
rm -rf $RPM_BUILD_ROOT

mkdir -p $RPM_BUILD_ROOT%{_bindir}

install %{SOURCE1} $RPM_BUILD_ROOT%{_bindir}/

mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/ld.so.conf.d/
echo "/app/%{_lib}" > $RPM_BUILD_ROOT%{_sysconfdir}/ld.so.conf.d/app.conf

%post -p /sbin/ldconfig

%files
%{_bindir}/app-list-required-pkg
%{_sysconfdir}/ld.so.conf.d/app.conf

%changelog
* Wed Jun  3 2015 Alexander Larsson <alexl@redhat.com>
- Initial version
