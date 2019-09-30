#!/bin/bash
#squashfs_make.sh script for Linux by petesimon, based on the .bat file
#SQUASHFS_MAKE.BAT script by BNDias of Goprawn.com forums
#build a new squashfs '2-system.img' file from data in a folder
#works with Swiss File Knife https://osdn.net/projects/sfnet_swissfileknife/releases/

clear
echo "squashfs packer for Allwinner V3(s) system image"
echo "original script by BNDias of Goprawn.com forums"
echo "modified by petesimon for Linux"
echo

pause () {
	echo
	read -n1 -p "press the Enter key to continue"
	echo
}

# set source file and destination folder and file size
DESTI="UNFEX/2-system.img"
DESTIOLD="UNFEX/2-system.img.old"
SOURCE="squashfs-root"
DESTSIZE=6488064

[ -z "$(which mksquashfs)" ] && echo "No 'mksquashfs' found. Install 'squashfs-tools' package first" && echo "exiting ..." && pause && exit 1
[ ! -d $SOURCE ] && echo "$SOURCE folder not found. Run 'bash squashfs_unmake.sh' first." && echo "exiting ..." && pause && exit 1

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

if [ -f $DESTI ]; then
    mv -T --backup=numbered $DESTI $DESTIOLD
    echo "$DESTI file found. renaming it to $DESTIOLD"
fi

# if new 02-system.img is too small then make it bigger
SFILESIZE=$(stat -c%s "$DESTI")
SYSDUMMY=sysdummy.bin

if [ -f 02-system.tmp ]; then
    rm 02-system.tmp > /dev/null
fi

if (( SFILESIZE < DESTSIZE )); then
    echo
    if [ ! -f $SYSDUMMY ]; then
        echo
        echo "$SYSDUMMY file not found."
        echo "exiting ..."
        pause
        exit 1
      else
        echo "processing $DESTI using sfk to be $DESTSIZE bytes ..."
        cat "$DESTI" "$SYSDUMMY" > 02-system.tmp
        echo
        $SFK partcopy 02-system.tmp 0 "$DESTSIZE" "$DESTI" -yes
        echo
        rm -f 02-system.tmp
    fi
fi

echo
echo "Creating a new $DESTI ..."
mksquashfs "$SOURCE" "$DESTI" -comp xz -Xbcj x86 -noappend -no-recovery -root-owned
echo

echo
echo Done. Check new $DESTI file
exit 0

