# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: target/share/firmware/build.sh
# Copyright (C) 2004 - 2008 The T2 SDE Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---
#
#Description: initramfs

. $base/misc/target/functions.in

set -e

# set initramfs preparation directory
imagelocation="$build_toolchain/initramfs"

echo "Preparing initramfs image from build result ..."

rm -rf $imagelocation{,.cpio,.igz}
mkdir -p $imagelocation ; cd $imagelocation

find $build_root -printf "%P\n" | sed '

# stuff we never need

/^TOOLCHAIN/							d;
/^offload/								d;

/\.a$/									d;
/\.o$/									d;
/\.old$/								d;
/\.svn/									d;
/\.po/									d;

 /^boot/								d;
/\/doc/									d;
  /etc\/conf/							d;
  /etc\/cron.d/							d;
  /etc\/cron.daily/						d;
  /etc\/dahdi\/system.conf/				d;
  /etc\/hotplug/						d;
  /etc\/hotplug.d/						d;
  /etc\/init.d/							d;
  /etc\/opt/							d;
  /etc\/postinstall.d/					d;
  /etc\/profile.d/						d;
  /etc\/rc.d/							d;
  /etc\/skel/							d;
  /etc\/stone.d/						d;
/\/games/								d;
/\/include/								d;
  /lib\/modules/						d;
/\/opt/									d;
/\/src/									d;
#/\/terminfo/							d;
  /usr\/bin\/aclocal/					d;
  /usr\/bin\/auto/						d;
  /usr\/bin\/bison/						d;
  /usr\/bin\/flite/						d;
  /usr\/bin\/gettext/					d;
  /usr\/bin\/libtool/					d;
  /usr\/bin\/locale/					d;
  /usr\/bin\/ngettext/					d;
  /usr\/bin\/msg/						d;
  /usr\/bin\/php-config/				d;
  /usr\/bin\/phpize/					d;
  /usr\/bin\/recode-sr-latin/			d;
  /usr\/bin\/xgettext/					d;
  /usr\/bin\/yacc/						d;
  /usr\/lib\/build/						d;
  /usr\/lib\/gettext/					d;
  /usr\/lib\/grub/						d;
  /usr\/lib\/perl5/						d;
  /usr\/lib\/pkgconfig/					d;
  /usr\/man/							d;
  /usr\/sbin\/astgenkey/				d;
  /usr\/sbin\/autosupport/				d;
  /usr\/sbin\/dahdi_genconf/			d;
  /usr\/sbin\/dahdi_hardware/			d;
  /usr\/sbin\/dahdi_registration/		d;
  /usr\/sbin\/grub/						d;
  /usr\/sbin\/lsdahdi/					d;
  /usr\/sbin\/muted/					d;
  /usr\/sbin\/safe_asterisk/			d;
  /usr\/sbin\/sethdlc/					d;
  /usr\/sbin\/stereoize/				d;
  /usr\/sbin\/streamplayer/				d;
  /usr\/sbin\/xpp_blink/				d;
  /usr\/sbin\/xpp_sync/					d;
  /usr\/share\/aclocal/					d;
  /usr\/share\/autoconf/				d;
  /usr\/share\/automake/				d;
  /usr\/share\/bison/					d;
  /usr\/share\/dahdi/					d;
  /usr\/share\/dict/					d;
  /usr\/share\/gettext/					d;
  /usr\/share\/info/					d;
  /usr\/share\/libtool/					d;
  /usr\/share\/locale/					d;
  /usr\/share\/man/						d;
  /usr\/share\/misc/					d;
  /usr\/share\/nls/						d;
  /var\/adm/							d;

' > tar.input

copy_with_list_from_file $build_root . $PWD/tar.input
rm tar.input

echo "Preparing initramfs image from target defined files ..."
copy_from_source $base/target/$target/rootfs .
copy_from_source $base/target/share/initramfs/rootfs .

echo "Setup some symlinks ..."
ln -s /offload/kernel-modules lib/modules

echo "Stamping build ..."
echo $config > etc/version
echo `date` > etc/version.buildtime
#_exec("echo " . time() . " > etc/version.buildtime.unix");
echo $SDECFG_SHORTID > etc/platform

echo "Creating links for identical files ..."
link_identical_files

echo "Setting permissions ..."
chmod 755 bin/*
chmod 755 sbin/*
chmod 755 usr/bin/*
chmod 755 usr/sbin/*
chmod 644 usr/www/*
chmod 755 usr/www/*.php
chmod 755 usr/www/*.cgi
chmod 755 usr/share/udhcpc/default.script
chmod 755 etc/rc*
chmod 644 etc/pubkey.pem
chmod 644 etc/inc/*

echo "Cleaning away stray files ..."
find ./ -type f -name "._*" -print -delete

echo "Creating initramfs image ..."
find . | cpio -H newc -o > ../initramfs.cpio

echo "Compressing initramfs image ..."
cd ..
cat initramfs.cpio | gzip > initramfs.igz

rm initramfs.cpio
du -sh $imagelocation{,.igz}

echo "The image is located at $imagelocation.igz."
