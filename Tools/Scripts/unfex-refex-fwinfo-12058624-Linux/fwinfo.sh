#!/bin/bash
#FWINFO.CMD script for batch mode by nutsey for GoPrawn.com
#fwinfo.sh script for Linux by petesimon, based on the .cmd/.bat files
#using Swiss File Knife ( https://osdn.net/projects/sfnet_swissfileknife/releases/ )
#data in a 'squashfs-root' folder must already exist before using this script
#check www.Goprawn.com forums for more details

clear
echo FWINFO firmware info script by nutsey
echo this fwinfo.sh script is by petesimon for Linux for 12058624 bytes files

pause () {
	echo
	read -r -t 20 -n1 -p "press the Enter key to continue"
	echo
}

#set swiss file knife 32bit or 64bit
BITS=$(uname -i)
if [ "x86_64" = "$BITS" ]; then
     echo
     SFK=./sfk64
     echo using sfk 64 bit
   else
     echo
     SFK=./sfk32
     echo using sfk 32 bit
fi

if [ ! -f $SFK ]; then
    echo
    echo $SFK file for Swiss File Knife for Linux not found.
    echo "Please download it from: https://sourceforge.net/projects/swissfileknife/"
    echo exiting ...
    pause
    exit 1  
  else
    chmod 755 $SFK
fi

SQFSDIR=./squashfs-root

if [ ! -d "$SQFSDIR" ]; then
    echo
    echo "$SQFSDIR folder not found. run 'bash squashfs_unmake.sh' first."
    echo exiting ...
    pause
    exit 1
fi

UNFEXDIR=./UNFEX

if [ ! -d "$UNFEXDIR" ]; then
    echo
    echo "$UNFEXDIR folder not found. run 'bash unfex.sh' first"
    echo exiting ...
    pause
    exit 1
fi

if [ ! -f "script.fex" ]; then
    echo
    echo "script.fex file not found. run 'bash convertscriptbin.sh' first."
    echo exiting ...
    pause
    exit 1
fi

#use sfk and put information into a fwinfo.txt text file
echo processing ... please wait ...
[ -d tmp ] && rm -fR ./tmp
[ ! -d tmp ] && mkdir ./tmp

$SFK extract $SQFSDIR/etc/MiniGUI.cfg -text "/defaultmode=*-32bpp/[part2]/" -astext -firsthit > tmp/lcdres.tmp
$SFK partcopy tmp/lcdres.tmp -allfrom 3 tmp/lcdres2.tmp -yes -quiet
LCDRES2=$(cat tmp/lcdres2.tmp)
#debug
#echo "LCDRES2 = $LCDRES2"
#pause

[ ! -d FWINFO ] && mkdir FWINFO
echo "Product:" >> tmp/fwinfo.tmp
$SFK extract $SQFSDIR/build.prop -text "/ro.build.product=*/[part2]/" -astext >> tmp/fwinfo.tmp
echo "Manufacturer:" >> tmp/fwinfo.tmp
$SFK extract $SQFSDIR/build.prop -text "/ro.build.user=*/[part2]/" -astext >> tmp/fwinfo.tmp

if [ -f $SQFSDIR/etc/info.xml ]; then
    echo "Short id:" >> tmp/fwinfo.tmp
    $SFK extract $SQFSDIR/etc/info.xml -text "/<Short>*</[part2]/" -astext >> tmp/fwinfo.tmp
    echo "OEM id:" >> tmp/fwinfo.tmp
    $SFK extract $SQFSDIR/etc/info.xml -text "/<SubClient>*</[part2]/" -astext >> tmp/fwinfo.tmp
    echo "Camera type:" >> tmp/fwinfo.tmp
    $SFK extract $SQFSDIR/etc/info.xml -text "/<CamType>*</[part2]/" -astext >> tmp/fwinfo.tmp
    echo "FW original date:" >> tmp/fwinfo.tmp
    $SFK extract $SQFSDIR/build.prop -text "/ro.build.version.incremental=*.*.*.*/[part6]/" -astext >> tmp/fwinfo.tmp
    echo "FW mod. date:" >> tmp/fwinfo.tmp
    $SFK extract $SQFSDIR/etc/info.xml -text "/<FirmDate>*</[part2]/" -astext >> tmp/fwinfo.tmp
  else
    echo "FW date:" >> tmp/fwinfo.tmp
    $SFK extract $SQFSDIR/build.prop -text "/ro.build.version.incremental=*.*.*.*/[part6]/" -astext >> tmp/fwinfo.tmp
fi

echo "Camera name:" >> tmp/fwinfo.tmp
$SFK extract $SQFSDIR/res/cfg/"$LCDRES2".cfg -text "/product_type=*/[part2]/" -astext >> tmp/fwinfo.tmp
echo "Version:" >> tmp/fwinfo.tmp
$SFK extract $SQFSDIR/res/cfg/"$LCDRES2".cfg -text "/software_version=*/[part2]/" -astext >> tmp/fwinfo.tmp
echo "LCD model:" >> tmp/fwinfo.tmp
$SFK extract script.fex -text "/lcd_driver_name = \q*\q/[part2]/" -astext >> tmp/fwinfo.tmp
echo "LCD resolution:" >> tmp/fwinfo.tmp
cat tmp/lcdres.tmp >> tmp/fwinfo.tmp

if [ -f $SQFSDIR/etc/info.xml ]; then
    echo "LCD count:" >> tmp/fwinfo.tmp
    $SFK extract $SQFSDIR/etc/info.xml -text "/<ScreenStruct>*</[part2]/" -astext >> tmp/fwinfo.tmp
fi

echo "Sensor model:" >> tmp/fwinfo.tmp
$SFK extract script.fex -text "/vip_dev0_mname = \q*\q/[part2]/" -astext >> tmp/fwinfo.tmp
$SFK partcopy tmp/fwinfo.tmp -fromto 0 -9 FWINFO/fwinfo.txt -yes -quiet
cp UNFEX/4-blogo.img FWINFO/on-logo.jpg > /dev/null
cp UNFEX/5-slogo.img FWINFO/off-logo.jpg > /dev/null
rm -R tmp
echo
echo "Done. Look in 'FWINFO' folder for new files ..."
echo
