#!/bin/bash
#squashfs_unmake.sh script for Linux by petesimon, based on the .bat file
#SQUASHFS_UNMAKE.BAT script by BNDias of Goprawn.com forums

clear
echo "squashfs unpacker for Allwinner V3(s) system image"
echo "original script by BNDias of Goprawn.com forums"
echo "modified by petesimon for Linux"
echo

pause () {
	echo
	read -n1 -p "press the Enter key to continue"
	echo
}

# set source file and destination folder
SOURCE=UNFEX/2-system.img
DESTI=squashfs-root
DESTIOLD=squashfs-root-old

[ -z "$(which unsquashfs)" ] && echo "No 'unsquashfs' found. Install 'squashfs-tools' package first" && echo "exiting ..." && pause && exit 1
[ ! -f $SOURCE ] && echo "$SOURCE file not found. Run 'bash unfex.sh' first." && echo "exiting ..." && pause && exit 1

if [ -d $DESTI ]; then
    mv -T --backup=numbered $DESTI $DESTIOLD
    echo "$DESTI folder found. renaming it to $DESTIOLD"
fi

echo
echo "Unpacking $SOURCE to $DESTI folder ..."
unsquashfs -f -d "$DESTI" "$SOURCE"
echo
echo "Done. Check $DESTI folder for new files."

exit 0
