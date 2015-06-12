#!/bin/sh

RPM=$1
shift
APPID=$1
shift

set -e
set -x

DIR=$APPID.builddir
rm -rf  $DIR
xdg-app build-init $DIR $APPID org.fedoraproject.Sdk org.fedoraproject.Platform 23

mock -r fedora-app-23-x86_64.cfg --clean
mock -r fedora-app-23-x86_64.cfg --install --disablerepo=* --enablerepo=app "$RPM"
mock -r fedora-app-23-x86_64.cfg --shell "tar cvf /app.tar /app"
mock -r fedora-app-23-x86_64.cfg  --copyout /app.tar .

xdg-app build $DIR tar xvCf / app.tar
rm app.tar

# Look at all exported desktop files
for i in `find $DIR/files/share/applications/ -name "*.desktop"`; do
    bn=`basename $i`
    # Does it have an icon?
    if grep "^Icon=" $i > /dev/null; then
	icon=`grep "^Icon=" $i | sed s/Icon=//`

	# Does the icon not have the app-id as prefix?
	if ! [[ ${icon} = ${APPID}* ]]; then
	    found_icon=no
	    icon_prefix=${APPID%.$icon}

	    # Rename any matching icons
	    for icon_file in `find $DIR/files/share/icons/hicolor/ -name "$icon.*"`; do
		mv $icon_file  "`dirname $icon_file`/${icon_prefix}.`basename $icon_file`"
		found_icon=yes
	    done

	    # If we renamed the icon, change the desktop file
	    if [ $found_icon == "yes" ]; then
		desktop-file-edit --set-icon="${icon_prefix}.$icon" $i
	    fi
	fi
    fi

    # Is the desktop file not prefixed with the app id, then prefix it
    if ! [[ ${bn} = ${APPID}* ]]; then
	mv $i "`dirname $i`/${APPID%.`basename $i .desktop`}.${bn}";
    fi
done
