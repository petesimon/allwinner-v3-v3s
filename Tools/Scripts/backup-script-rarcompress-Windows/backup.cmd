@echo off
echo Allwinner V3/V5 action cam firmware backup script by nutsey for www.GoPrawn.com forums
:: modified by user 'petesimon' for rar compression of backup files
:: WinRar file format is version 5 ! Get new Winrar from https://rarlab.com
echo.
echo wait please ...
IF NOT EXIST adb.exe (echo tool file 'adb.exe' android debug not found. please provide a copy of it.) ELSE (goto adbdevices)
goto exitdone
:adbdevices
adb kill-server 1>nul 2>&1
adb get-state 1>nul 2>&1
IF %ERRORLEVEL% GTR 0 (echo device not found. check camera and usb connection and try again.) ELSE (goto dobackup)
goto exitdone

:dobackup
echo.
echo Backing up firmware files...
echo.
adb root 1>nul 2>&1
adb remount 1>nul 2>&1
adb shell cd / 1>nul 2>&1
adb shell rm -R /mnt/extsd/backup 1>nul 2>&1
adb shell mkdir /mnt/extsd/backup 1>nul 2>&1
echo Backup folder created on SD card of camera...
echo.
adb shell toolbox dd if=/dev/block/mtdblock0 of=/mnt/extsd/backup/0-uboot.img
echo Block 0 'uboot' copied.
echo.
adb shell toolbox dd if=/dev/block/mtdblock1 of=/mnt/extsd/backup/1-boot.img
echo Block 1 'boot' copied.
echo.
adb shell toolbox dd if=/dev/block/mtdblock2 of=/mnt/extsd/backup/2-system.img
echo Block 2 'system' copied.
echo.
adb shell toolbox dd if=/dev/block/mtdblock3 of=/mnt/extsd/backup/3-config.img
echo Block 3 'config' copied.
echo.
adb shell toolbox dd if=/dev/block/mtdblock4 of=/mnt/extsd/backup/4-blogo.img
echo Block 4 'blogo' copied.
echo.
adb shell toolbox dd if=/dev/block/mtdblock5 of=/mnt/extsd/backup/5-slogo.img
echo Block 5 'slogo' copied.
echo.
adb shell toolbox dd if=/dev/block/mtdblock6 of=/mnt/extsd/backup/6-env.img
echo Block 6 'env' copied.

IF EXIST "backup" (
    echo.
    echo found existing backup folder on computer's hard drive. renaming it to backup-old
    ren backup backup-old
    echo.
    )

echo.
adb pull /mnt/extsd/backup backup
echo All blocks downloaded.
echo.
cd backup
adb root 1>nul 2>&1
adb remount 1>nul 2>&1
:: get build.prop text from device
adb pull /system/build.prop
type build.prop > buildprop.txt
del build.prop
echo "build.prop" system properties was pulled.
echo.
echo now making full_img.fex ...
echo.
copy /b 0-uboot.img+1-boot.img+2-system.img+3-config.img+4-blogo.img+5-slogo.img+6-env.img full_img.fex
echo.
echo done creating full_img.fex file
echo.
:: reference http://ss64.com/nt/   
set /p raranswer=Compress all backup files together as 'backup.rar' (enter Y for yes, N for no) ?
if /i "%raranswer:~,1%" EQU "Y" goto raryes
if /i "%raranswer:~,1%" NEQ "Y" goto rarno
echo.
:raryes
echo.
cd ..
IF NOT EXIST backup.rar (goto checkrarexe)
echo 'backup.rar' already exists. renaming to backup-old.rar
ren backup.rar backup-old.rar
:checkrarexe
if not exist rar.exe (echo tool file 'rar.exe' not found. please download 'rar.exe' version 5 or better from http://www.rarlab.com) ELSE (goto dorar)
goto exitdone
:dorar
echo compressing all files into 'backup.rar' ...
REM reference for rar.exe is Rar.txt file from rarlab.com website
copy /y /b goprawncomment.txt+backup\buildprop.txt backup\rarcomment.txt 1>nul 2>&1
.\rar a -logAFU -s -ma5 -m5 -idc -ai -ed -ep -md128m backup.rar backup\buildprop.txt backup\0-uboot.img backup\1-boot.img backup\2-system.img backup\3-config.img backup\4-blogo.img backup\5-slogo.img backup\6-env.img backup\full_img.fex
.\rar c -idq -scA -zbackup\rarcomment.txt backup.rar
echo.
echo compressing done. see 'backup.rar' archive file.
echo.
echo.
echo NOTICE:  RAR FILE IS VERSION 5.0 !
echo NOTICE:  YOU WILL NEED LATEST VERSION OF WINRAR OR 7-ZIP !
echo.
echo.
if exist backup.rar (start .\backup.rar) else (echo backup.rar file was not created)
:rarno
echo.
echo Firmware backup done. See new files in current folder AND in "backup" folder.
echo.
:exitdone
echo now exiting...
adb kill-server 1>nul 2>&1
pause
exit /b
