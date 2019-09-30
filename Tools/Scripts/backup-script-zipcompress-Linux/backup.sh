#!/bin/bash
#24 September 2019
#backup.sh shell script for Linux to backup Allwinner V3(s) firmware
#this script may also work for Allwinner V5/V316 and similar chipsets
#this script assumes that the 'dd' command is available inside the camera
#see www.Goprawn.com forums and www.fb.com/groups/allwinner4kcamerasusergroup onlilne
#contact me directly at petesimon (@) yahoo.com

do_zip () {
	[ -f backup.zip ] && mv --backup=numbered -T backup.zip backup.zip.old && echo "old backup.zip found and renamed it to backup.old"
	echo ""
    zip -9jr backup.zip backup/0-uboot.img backup/1-boot.img backup/2-system.img backup/3-config.img backup/4-blogo.img backup/5-slogo.img backup/6-env.img backup/full_img.fex backup/buildprop.txt ;
    cat goprawncomment.txt | zip -z backup.zip >/dev/null;
}

pause () {
	echo
	read -n1 -t 20 -p "press the Enter key to continue"
	echo
}

clear
echo "Allwinner V3(s) action cam firmware backup script for Linux by hphde adopted from nutsey for www.GoPrawn.com forums"
echo "modified by petesimon of www.Goprawn.com forums"
[ -z "$(which adb)" ] && echo "No 'adb' found. You need to install that first" && pause && exit 1
[ -z "$(which zip)" ] && echo "No 'zip' found. You need to install that first" && pause && exit 1

echo ""
echo "Enter password for using 'sudo' when needed ..."
echo ""
# add new udev rule files for android adb devices
# ATTR{idVendor}=="1f3a", ATTR{idProduct}=="1002"
# and
# ATTR{idVendor}=="18d1", ATTR{idProduct}="0002"
echo "Adding a udev rule file to your Linux system ..."
echo "Executing command 'sudo udevadm control -R'"
echo ""
if [ -f "/etc/udev/rules.d/51-android.rules" ]; then
    sudo cp 51-android.rules /etc/udev/rules.d/52-android.rules
    sudo udevadm control -R
 else
    sudo cp 51-android.rules /etc/udev/rules.d/
    sudo udevadm control -R
fi

if [ -f "/etc/udev/rules.d/53-android.rules" ]; then
    sudo cp 53-android.rules /etc/udev/rules.d/54-android.rules
    sudo udevadm control -R
 else
    sudo cp 53-android.rules /etc/udev/rules.d/
    sudo udevadm control -R
fi

echo "Please wait ..."
adb kill-server 2>/dev/null
sleep 3
adb kill-server 2>/dev/null
sleep 3
adb get-state >/dev/null
[ $? -gt 0 ] && echo "Device not found. Check camera and USB connection and try again" && pause && exit 1

echo ""
echo "Be sure that a SD card is in the camera..."
pause
adb root >/dev/null
adb remount >/dev/null
adb shell cd /
adb shell rm -f /mnt/extsd/backup/* >/dev/null
adb shell mkdir /mnt/extsd/backup >/dev/null

echo ""
echo "Generating blocks of data from the camera onto the SD card..."
FILES="0-uboot.img 1-boot.img 2-system.img 3-config.img 4-blogo.img 5-slogo.img 6-env.img"
for F in $FILES; do
  echo "Copying $F"
  # no 'busybox' available, so try 'toolbox dd'
  adb shell toolbox dd if=/dev/block/mtdblock${F:0:1} of=/mnt/extsd/backup/$F
done

[ -d backup ] && mv -T --backup=numbered backup backup-old && echo "Old backup directory found and renamed to backup-old"
adb pull /mnt/extsd/backup
echo "All mtd blocks downloaded"

# get build.prop text from device
adb pull /system/build.prop
# convert UTF8 UNIX text to ASCII DOS/Windows text.
# if awk/gawk doesn't work, then use sed
awk 'sub("$", "\r")' build.prop > backup/buildprop.txt
# remove temp buildprop files
rm -f build.prop >/dev/null
echo "build.prop system property file was pulled, and saved as buildprop.txt."

cd backup
echo "Now creating full_img.fex ..."
cat 0-uboot.img 1-boot.img 2-system.img 3-config.img 4-blogo.img 5-slogo.img 6-env.img >full_img.fex
echo "Done creating full_img.fex file ..."
cd ..
# let the user choose to create/not create a compressed archive file
while true; do
    read -t 20 -n1 -p "Do you wish to create a 'backup.zip' file? Answer Y for yes or N for no." choice
    case $choice in
        [Yy] ) echo "Wait ..." ; do_zip ; xdg-open backup.zip ; break;;
        [Nn] ) break;;
    esac
done
echo ""
echo "Firmware backup done. See new files in 'backup' folder, and 'backup.zip if any'"
pause
exit 0
