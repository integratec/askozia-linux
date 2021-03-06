#!/bin/bash
#
# Written by Benjamin Schieder <blindcoder@scavenger.homeip.net>
#
# Use:
# newpackage.sh [-main] <rep>/<pkg> http://www.example.com/down/pkg.tar.bz2
#
# will create <pkg>.desc and <pkg>.conf. .desc will contain the [D] and [COPY]
# already filled in. The other tags are mentioned with TODO.
#
# .conf will contain an empty <pkg>_main() { } and custmain="<pkg>_main"
# if -main is specified.
#
# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: misc/archive/newpackage.sh
# Copyright (C) 2004 - 2005 The T2 SDE Project
# Copyright (C) 1998 - 2003 ROCK Linux Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---
#

if [ "$1" == "-main" ] ; then
	create_main=1
	shift
fi

if [ $# -lt 2 ] ; then
	cat <<-EEE
Usage:
$0 <option> package/repository/packagename Download_1 < Download_2, Download_n >

Where <option> may be:
	-main		Create a package.conf file with main-function

	EEE
	exit 1
fi


dir=${1#package/} ; shift
package=${dir##*/}
if [ "$package" = "$dir" ]; then
	echo "failed"
	echo -e "\t$dir must be <rep>/<pkg>!\n"
	exit
fi

rep="$( echo package/*/$package | cut -d'/' -f 2 )"
if [ "$rep" != "*" ]; then
	echo "failed"
	echo -e "\tpackage $package belongs to $rep!\n"
	exit
fi

rep=${dir/\/$package/}
confdir="package/$dir"
maintainer='The T2 Project <t2@t2-project.org>'

echo -n "Creating $confdir ... "
if [ -e $confdir ] ; then
	echo "failed"
	echo -e "\t$confdir already exists!\n"
	exit
fi
if mkdir -p $confdir ; then
	echo "ok"
else
	echo "failed"
	exit
fi

echo -n "Creating $package.desc ... "
	cat >$confdir/$package.desc <<EEE
[I] TODO: Short Information

[T] TODO: Long Expanation
[T] TODO: Long Expanation
[T] TODO: Long Expanation
[T] TODO: Long Expanation
[T] TODO: Long Expanation

[U] TODO: URL

[A] TODO: Author
[M] ${maintainer:-TODO: Maintainer}

[C] TODO: Category

[L] TODO: License
[S] TODO: Status
[V] TODO: Version
[P] X -----5---9 800.000

EEE

while [ "$1" ]; do
	dl=$1; shift
	file=`echo $dl | sed 's,^.*/,,g'`
	server=${dl%$file}
	echo [D] 0 $file $server >> $confdir/$package.desc
done
echo >> $confdir/$package.desc

echo "ok"
echo -n "Creating $package.conf ... "

if [ "$create_main" == "1" ] ; then
	cat >>$confdir/$package.conf <<-EEE
${package}_main() { 
	: TODO
}

custmain="${package}_main"
EEE
fi

echo "ok"
echo "Remember to fill in the TODO's:"
grep TODO $confdir/$package.*
echo
