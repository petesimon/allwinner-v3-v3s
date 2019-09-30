#!/bin/sh

# BACKUP Get firmware backup file and partition files of the camera.
# rar 5 compression
# Works with ./adb tool.
# Check GoPrawn.com for details.

function pause {
    read -n1 -rs
}

echo Allwinner V3 action cam firmware backup script by nutsey for GoPrawn.com
echo

# make binarieas as executable
chmod 755 ./adb
chmod 755 ./rar

# check device connection state
./adb get-state 1>/dev/null 2>&1
if [ $? -eq 0 ]; then

echo Be sure you have a SD card inserted into the camera.
echo Press any key to continue...
pause>/dev/null
echo
echo Backing up firmware files...
echo ==========================================================
./adb kill-server && ./adb start-server
./adb remount
./adb shell cd /
./adb shell rm -r /mnt/extsd/backup
./adb shell mkdir /mnt/extsd/backup
echo Backup folder created.
echo
./adb shell dd if=/dev/block/mtdblock0 of=/mnt/extsd/backup/0-uboot.img
echo Block 0 copied.
echo
./adb shell dd if=/dev/block/mtdblock1 of=/mnt/extsd/backup/1-boot.img
echo Block 1 copied.
echo
./adb shell dd if=/dev/block/mtdblock2 of=/mnt/extsd/backup/2-system.img
echo Block 2 copied.
echo
./adb shell dd if=/dev/block/mtdblock3 of=/mnt/extsd/backup/3-config.img
echo Block 3 copied.
echo
./adb shell dd if=/dev/block/mtdblock4 of=/mnt/extsd/backup/4-blogo.img
echo Block 4 copied.
echo
./adb shell dd if=/dev/block/mtdblock5 of=/mnt/extsd/backup/5-slogo.img
echo Block 5 copied.
echo
./adb shell dd if=/dev/block/mtdblock6 of=/mnt/extsd/backup/6-env.img
echo Block 6 copied.
echo

if [ - f backup ]; then
   echo Found existing backup folder. renaming it to backup-old
   mv -f backup backup-old
fi

./adb pull /mnt/extsd/backup backup
echo
echo All blocks downloaded.
echo ==========================================================
cd backup
echo Building full_img.fex...
cat 0-uboot.img 1-boot.img 2-system.img 3-config.img 4-blogo.img 5-slogo.img 6-env.img > full_img.fex
echo
echo Done. Check BACKUP folder of SD Card.

cd ..
#  RAR BACKUP FILES
# reference http://ss64.com/nt/
# reference rar.txt file from rarlab.com website
echo
if [ -x backup.rar ]; then
	echo Existing backup.rar file renamed to backup.rar.bak
	mv -f backup.rar backup.rar.bak 1>/dev/null 2>&1
fi
echo Compressing backup files...
cat rarcomment.txt | ./rar a -s -ma5 -m5 -idcd -ai -ed -ep -md32m backup.rar backup/0-uboot.img backup/1-boot.img backup/2-system.img backup/3-config.img backup/4-blogo.img backup/5-slogo.img backup/6-env.img backup/full_img.fex
echo Done. Files compressed into backup.rar file.
echo Note: backup.rar is version 5 !
echo Please share your firmware online.

else
echo DEVICE NOT FOUND! Please connect the camera to your PC.
fi

echo Press any key to exit...
pause>/dev/null
exit
