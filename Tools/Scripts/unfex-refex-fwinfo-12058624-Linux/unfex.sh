#!/bin/bash
#unfex.sh shell script for Linux based on unfex.bat
#UNFEX.BAT full_img.fex unpacking script by nutsey. Based on pack/unpack script by losber.
#Works with SFK tool (https://sourceforge.net/projects/swissfileknife/).
#or https://osdn.net/projects/sfnet_swissfileknife/releases/
#Put full_img.fex file into folder containing this script if you want to extract files.
#Separate partition files will be extracted into UNFEX folder.
#Check GoPrawn.com forums for ddetails

clear
echo "unfex.sh full_img.fex unpacking script by nutsey for GoPrawn.com forums"
echo "modified by petesimon for usage in Linux"
echo

pause () {
	echo
	read -t 20 -n1 -p "press any key to continue"
    echo
}

#set swiss file knife 32bit or 64bit
BITS=$(uname -i)
if [ "x86_64" = "$BITS" ]; then
     SFK=./sfk64
     echo
     echo using sfk 64 bit
   else
     SFK=./sfk32
     echo
     echo using sfk 32 bit
fi

if [ ! -f full_img.fex ]; then
   echo
   echo full_img.fex file not found.
   echo either get a full_img.fex file
   echo "or run 'bash refex.sh' to create a new fulL_img.fex file"
   echo exiting ...
   pause
   exit 1
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

if [ -d UNFEX ]; then
    echo
    echo UNFEX folder found. renaming it to UNFEX-old
    mv -T --backup=numbered UNFEX UNFEX-old
fi

mkdir UNFEX

echo
echo Extracting partitions ...
echo
$SFK partcopy full_img.fex 0     262144 UNFEX/0-uboot.img -yes
$SFK partcopy full_img.fex 0x40000 2883584 UNFEX/1-boot.img -yes
$SFK partcopy full_img.fex 0x300000 6488064 UNFEX/2-system.img -yes
$SFK partcopy full_img.fex 0x930000 2097152 UNFEX/3-config.img -yes
$SFK partcopy full_img.fex 0xB30000 131072 UNFEX/4-blogo.img -yes
$SFK partcopy full_img.fex 0xB50000 131072 UNFEX/5-slogo.img -yes
$SFK partcopy full_img.fex 0xB70000 65536 UNFEX/6-env.img -yes
echo
echo unfex extraction done. check the UNFEX folder for extracted files.

exit 0
