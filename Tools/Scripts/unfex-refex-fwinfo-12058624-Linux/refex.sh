#!/bin/bash
#refex.sh shell script for Linux based on refex.bat
#REFEX.BAT full_img.fex packing script by nutsey. Based on pack/unpack script by losber.
#Works with SFK tool (https://sourceforge.net/projects/swissfileknife/).
#or https://osdn.net/projects/sfnet_swissfileknife/releases/
#Packs partition files from UNFEX folder into full_img.fex
#Make sure you have proper partition img files in UNFEX folder. Use at your own risk!!!
#Check GoPrawn.com for details.

clear
echo "refex.sh full_img.fex (re)packing script by nutsey for GoPrawn.com forums"
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
     echo
     SFK=./sfk64
     echo "using sfk 64 bit"
   else
     echo
     SFK=./sfk32
     echo "using sfk 32 bit"
fi

if [ ! -f $SFK ]; then
    echo
    echo "$SFK file for Swiss File Knife for Linux not found."
    echo "Please download it from: https://sourceforge.net/projects/swissfileknife/"
    echo "exiting ..."
    pause
    exit 1  
  else
    chmod 755 $SFK > /dev/null
fi

SYSFILE="UNFEX/2-system.img"
SYSSIZE=6488064
echo
echo "setting system file as $SYSFILE and as $SYSSIZE bytes in size"
echo

#if any img files not found, then abort
if [ ! -d UNFEX ]; then
    echo
    echo "UNFEX folder not found. run 'bash unfex.sh' script first"
    echo "exiting ..."
    pause
    exit 1
  else
    IMGFILES="UNFEX/0-uboot.img UNFEX/1-boot.img UNFEX/2-system.img UNFEX/3-config.img UNFEX/4-blogo.img UNFEX/5-slogo.img UNFEX/6-env.img"
    for F in $IMGFILES; do
      if [ ! -f "$F" ]; then
         echo
         echo "$F file not found. run 'bash unfex.sh' script first."
         echo "exiting ..."
         pause
         exit 1
      fi
done
fi

# if 02-system.img is too large then abort
SFILESIZE=$(stat -c%s "$SYSFILE")
if (( SFILESIZE > SYSSIZE )); then
    echo
    echo "WARNING: $SYSFILE is $SFILESIZE and it is too large."
    echo "max file size is $SYSSIZE"
    echo "exiting ..."
    pause
    exit 1
fi

# if 02-system.img is too small then make it bigger
SYSDUMMY="sysdummy.bin"
if [ -f 02-system.tmp ]; then
    rm 02-system.tmp > /dev/null
fi
    
if (( SFILESIZE < SYSSIZE )); then
    echo
    if [ ! -f $SYSDUMMY ]; then
        echo
        echo "$SYSDUMMY file not found."
        echo "exiting ..."
        pause
        exit 1
      else
        echo "processing $SYSFILE using sfk to be $SYSSIZE bytes ..."
        cat "$SYSFILE" "$SYSDUMMY" > 02-system.tmp
        echo
        $SFK partcopy 02-system.tmp 0 6488064 "$SYSFILE" -yes
        echo
        rm -f 02-system.tmp > /dev/null
    fi
fi

if (( SFILESIZE = SYSSIZE )); then
    echo
    echo "$SYSFILE is okay. no further processing is needed."
fi

if [ -f full_img.fex ]; then
    echo
    echo "full_img.fex found. renaming to full_img.fex.old ..."
    mv -T --backup=numbered full_img.fex full_img.fex.old
fi

echo
echo "Merging partitions into a full_img.fex file ..."
echo
cat UNFEX/0-uboot.img UNFEX/1-boot.img $SYSFILE UNFEX/3-config.img UNFEX/4-blogo.img UNFEX/5-slogo.img UNFEX/6-env.img > full_img.fex
echo "done merging partitions ..."
echo "look in current directory for a new full_img.fex file"
exit 0

