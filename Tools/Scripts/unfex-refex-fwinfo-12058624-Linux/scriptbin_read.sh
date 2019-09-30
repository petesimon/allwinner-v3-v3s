#!/bin/bash
#scriptbin_read.sh script for Linux based on the .bat file
#SCRIPTBIN_READ.BAT : Get hardware configuration info, binary file of the camera.
#Works with SFK tool (https://sourceforge.net/projects/swissfileknife/).
#or ( https://osdn.net/projects/sfnet_swissfileknife/releases/ ).
#Check GoPrawn.com forums for details.

clear
echo "scriptbin_read : get hardware config info, binary file, of the camera"
echo "by nutsey, BNDias and various authors of Goprawn.com forums"
echo "modified by petesimon for Linux"

pause () {
	echo
	read -t 20 -n1 -p "press the Enter key to continue"
	echo
}

FEXFILE="full_img.fex"
UFILE="UNFEX/0-uboot.img"

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

if [ -f script.bin ]; then
   echo
   echo "found script.bin file. renaming it to script.bin.old"
   mv -T --backup=numbered script.bin script.bin.old
fi

echo
if [ ! -f $FEXFILE ]; then
    echo "$FEXFILE file not found. trying to use $UFILE instead..."
    echo
    if [ -f $UFILE ]; then
        echo "Getting script.bin from $UFILE ..."
        echo
        $SFK partcopy $UFILE 0x32000 36272 script.bin -yes
        echo
        echo "Done. Look for a new script.bin file"
        echo "Run 'bash convertscriptbin.sh' to get readable text in script.fex"
        exit 0
      else #using nested if
           echo "$UFILE and/or $FEXFILE files not found"
           echo "Get a full_img.fex file, or run 'bash unfex.sh' first"
           echo exiting ...
           pause
           exit 1
    fi #end nested if
  else #using parent else
    echo "Getting script.bin from $FEXFILE ..."
    echo
    $SFK partcopy $FEXFILE 0x32000 36272 script.bin -yes
    echo
    echo "Done. Look for a new script.bin file"
    echo "Run 'bash convertscriptbin.sh' to get readable text in script.fex"
    exit 0
fi #end parent if

exit 0 # end script
