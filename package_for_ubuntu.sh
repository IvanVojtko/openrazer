#!/bin/bash

# Make deployment directory
directory=$(mktemp -d)

# Copy DEBIAN directory
mkdir -p ${directory}
cp -r install_files/DEBIAN_ubuntu ${directory}/DEBIAN
chmod 755 ${directory}/DEBIAN
chmod 755 ${directory}/DEBIAN/{pre,post}*


# Create file structure
mkdir -p ${directory}/etc/{init,init.d,udev/rules.d,dbus-1/system.d,xdg/autostart}
mkdir -p ${directory}/usr/{bin,lib/python3/dist-packages/,sbin,share/razer_bcd/fx,src/razer_chroma_driver-1.0.0/driver,share/razer_tray_applet,share/razer_chroma_controller,share/applications}


# Copy over upstart script
cp install_files/init/razer_bcd.conf ${directory}/etc/init/razer_bcd.conf
cp install_files/init.d/razer_bcd_ubuntu ${directory}/etc/init.d/razer_bcd
cp install_files/desktop/razer_tray_applet_autostart.desktop ${directory}/etc/xdg/autostart/razer_tray_applet.desktop

# Copy over udev rule
cp install_files/udev/95-razerkbd.rules ${directory}/etc/udev/rules.d/95-razerkbd.rules

# Copy over dbus rule
cp install_files/dbus/org.voyagerproject.razer.daemon.conf ${directory}/etc/dbus-1/system.d/org.voyagerproject.razer.daemon.conf

# Copy over bash helper
cp install_files/share/bash_keyboard_functions.sh ${directory}/usr/share/razer_bcd/bash_keyboard_functions.sh

# Copy over application entry
cp install_files/desktop/razer_tray_applet.desktop ${directory}/usr/share/applications/razer_tray_applet.desktop
cp install_files/desktop/razer_chroma_controller.desktop ${directory}/usr/share/applications/razer_chroma_controller.desktop

# Copy over libchroma and daemon
cp lib/librazer_chroma.so ${directory}/usr/lib/librazer_chroma.so
cp lib/librazer_chroma_controller.so ${directory}/usr/lib/librazer_chroma_controller.so
cp daemon/razer_bcd ${directory}/usr/sbin/razer_bcd
cp daemon/fx/pez2001_collection.so ${directory}/usr/share/razer_bcd/fx
cp daemon/fx/pez2001_mixer.so ${directory}/usr/share/razer_bcd/fx
cp daemon/fx/pez2001_light_blast.so ${directory}/usr/share/razer_bcd/fx
cp daemon/fx/pez2001_progress_bar.so ${directory}/usr/share/razer_bcd/fx

# Copy daemon controller
cp daemon_controller/razer_bcd_controller ${directory}/usr/bin/razer_bcd_controller


# Copy Python3 lib into the python path
cp -r gui/lib/razer ${directory}/usr/lib/python3/dist-packages/razer

# Copy Tray application
cp -r gui/tray_applet/* ${directory}/usr/share/razer_tray_applet

# Copy Configuration GUI application
mkdir ${directory}/usr/share/razer_chroma_controller/data
cp gui/chroma_controller/*.py ${directory}/usr/share/razer_chroma_controller/
cp -r gui/chroma_controller/data/* ${directory}/usr/share/razer_chroma_controller/data
cp gui/tray_applet/daemon_dbus.py ${directory}/usr/share/razer_chroma_controller/daemon_dbus.py
cp examples/dynamic ${directory}/usr/share/razer_chroma_controller/

# Copy razer kernel driver to src
cp Makefile ${directory}/usr/src/razer_chroma_driver-1.0.0/Makefile
cp install_files/dkms/dkms.conf ${directory}/usr/src/razer_chroma_driver-1.0.0/dkms.conf
cp driver/{Makefile,razerkbd.c,razerkbd.h,razermouse.c,razermouse.h} ${directory}/usr/src/razer_chroma_driver-1.0.0/driver

rm $TMPDIR/razer-chroma*.deb
dpkg-deb --build ${directory}
dpkg-name ${directory}.deb

rm -rf ${directory}








