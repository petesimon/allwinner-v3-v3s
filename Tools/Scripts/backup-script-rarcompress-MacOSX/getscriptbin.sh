#!/bin/sh

# GETSCRIPTBIN Get hardware configuration file of the camera.
# Works with ADB tool.
# Check GoPrawn.com for details.

function pause {
    read -n1 -rs
}

echo Allwinner V3 action cam firmware backup script by petesimon for GoPrawn.com
echo

# make adb executable
chmod 755 ./adb

# Check device connection state
./adb get-state 1>/dev/null 2>&1
# adb devices -l | find "device product:" >/dev/null
if [ $? -eq 0 ]; then

echo Be sure you have a SD card inserted into the camera.
echo Press any key to continue...
pause>/dev/null
echo
echo Getting script.bin hardware description data...
echo ==========================================================
./adb kill-server && adb start-server
./adb remount
./adb root
./adb shell mkdir /mnt/extsd/backup
./adb shell dd if=/dev/block/mtdblock0 of=/mnt/extsd/backup/script.bin bs=1 skip=204800 count=36272
./adb pull /mnt/extsd/backup/script.bin .
echo ==========================================================
echo
echo Data saved to file "script.bin"
echo Done. Check SCRIPT.BIN file in BACKUP folder of SD Card.
echo Press any key to exit...
pause>/dev/null

else

echo DEVICE NOT FOUND! Please connect the camera to your PC.
echo Press any key to exit...
pause>/dev/null

fi
