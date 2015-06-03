Name:           fedora-runtime
Version:        22
Release:        1%{?dist}
Summary:        An xdg-app runtime based on fedora

License:        GPL

Requires:       fedora-release basesystem glibc nss-altfiles bash setup rpm
Requires:	gnupg2
Requires:	xz gzip bzip2
Requires:	coreutils util-linux which curl findutils btrfs-progs
Requires:	abattis-cantarell-fonts
Requires:	dejavu-sans-fonts dejavu-serif-fonts dejavu-lgc-sans-fonts dejavu-lgc-serif-fonts dejavu-sans-mono-fonts dejavu-lgc-sans-mono-fonts
Requires:	gnu-free-serif-fonts gnu-free-mono-fonts gnu-free-sans-fonts google-crosextra-caladea-fonts google-crosextra-carlito-fonts
Requires:	liberation-fonts-common liberation-mono-fonts liberation-narrow-fonts liberation-sans-fonts liberation-serif-fonts
Requires:	libICE libSM libX11 libXScrnSaver libXau libXcomposite libXcursor libXdamage libXext libXfixes libXft libXi libXinerama libXpm libXrandr libXrender libXt libXtst libXv libXxf86vm libxkbcommon-x11 xcb-util
Requires:	mesa-libEGL mesa-libglapi mesa-libgbm mesa-libwayland-egl mesa-libGL mesa-dri-drivers
Requires:	pulseaudio-libs pulseaudio-libs-glib2
Requires:	gtk2 gtk2-immodules gtk3 gtk3-immodules
Requires:	clutter clutter-gtk
Requires:	adwaita-icon-theme gnome-themes-standard gsettings-desktop-schemas
Requires:	gobject-introspection dbus-glib dconf gjs json-glib librsvg2 libsecret webkitgtk4 enchant libproxy avahi-glib
Requires:	lcms2 zenity desktop-file-utils attr bzip2 elfutils less libatomic_ops libtool-ltdl libsamplerate tar zip unzip startup-notification
Requires:	speex libvpx libexif libogg jasper flac-libs libjpeg-turbo libpng libsndfile libtheora libtiff libvisual libvorbis libwebp
Requires:	SDL2 SDL2_image SDL2_net SDL2_mixer SDL2_ttf
Requires:	perl python3 python3-cairo python3-gobject

%description
An xdg-app runtime based on fedora

%prep


%build


%install
rm -rf $RPM_BUILD_ROOT


%files



%changelog
* Wed Jun  3 2015 Alexander Larsson <alexl@redhat.com>
- Initial version
