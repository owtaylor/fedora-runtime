Name:           fedora-app-build
Version:        1.0
Release:        2%{?dist}
Summary:        Extra files needed for building apps

License:        GPL

BuildRequires: glade-devel

%description
Workarounds for building apps

%prep

%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT%{_datadir}/fedora-app-build/pkgconfig
cp /usr/%{_lib}/pkgconfig/gladeui-2.0.pc $RPM_BUILD_ROOT%{_datadir}/fedora-app-build/pkgconfig
sed -i -e s_catalogdir=.*_catalogdir=/app/share/glade/catalogs_ $RPM_BUILD_ROOT%{_datadir}/fedora-app-build/pkgconfig/gladeui-2.0.pc

%files
%{_datadir}/fedora-app-build

%changelog
* Wed Jun  3 2015 Alexander Larsson <alexl@redhat.com>
- Initial version
