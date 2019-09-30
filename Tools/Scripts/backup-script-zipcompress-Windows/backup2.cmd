:: file "backup2.cmd"
@echo off
echo Allwinner V3 action cam firmware backup script by nutsey for www.GoPrawn.com forums
echo.
IF NOT EXIST adb.exe (echo tool file 'adb.exe' android debug not found. please provide a copy of it. now exiting...) ELSE (goto adbdevices)
pause
exit /b
:adbdevices
echo please wait ...
adb kill-server 1>nul 2>&1
adb get-state 1>nul 2>&1
echo.
IF %ERRORLEVEL% GTR 0 (echo device not found. check camera and usb connection and try again. now exiting...) ELSE (goto dobackup)
echo.
pause
exit /b

:dobackup
echo.
echo Backing up firmware files...
echo.

IF EXIST "backup" (
    echo found existing backup folder on computer's hard drive. renaming it to backup-old
    ren backup backup-old
    echo.
    )
mkdir backup

adb remount 1>nul 2>&1
adb shell cd /
adb shell rm -r /mnt/extsd/backup 1>nul 2>&1

:: changed /system/bin/dd commands to adb pull /dev/block/mtdblock* commands
:: because 'dd' may not be available in some stock firmware
:: an alternative method is to copy an ARM binary of busybox to the sdcard and
:: use "/mnt/extsd/busybox dd" commands if dd or other commands are desired
echo pulling mtdblock* data directly to computer storage without using "dd" commands
echo.
adb pull /dev/block/mtdblock0 backup/0-uboot.img
echo Block 0 'uboot' copied.
echo.
adb pull /dev/block/mtdblock1 backup/1-boot.img
echo Block 1 'boot' copied.
echo.
adb pull /dev/block/mtdblock2 backup/2-system.img
echo Block 2 'system' copied.
echo.
adb pull /dev/block/mtdblock3 backup/3-config.img
echo Block 3 'config' copied.
echo.
adb pull /dev/block/mtdblock4 backup/4-blogo.img
echo Block 4 'blogo' copied.
echo.
adb pull /dev/block/mtdblock5 backup/5-slogo.img
echo Block 5 'slogo' copied.
echo.
adb pull /dev/block/mtdblock6 backup/6-env.img
echo Block 6 'env' copied.
echo.
echo.
echo All blocks downloaded.
echo.
:: get build.prop text from device
adb pull /system/build.prop
more build.prop > backup\buildprop.txt
del build.prop
echo "build.prop" system properties was pulled.
echo.
cd backup
echo now making full_img.fex ...
echo.
copy /b 0-uboot.img+1-boot.img+2-system.img+3-config.img+4-blogo.img+5-slogo.img+6-env.img full_img.fex
echo.
echo done creating full_img.fex file
echo.
:: reference http://ss64.com/nt/   
set /p zipanswer=Compress all backup files together as 'backup.zip' (enter Y for yes, N for no) ?
if /i "%zipanswer:~,1%" EQU "Y" goto zipyes
if /i "%zipanswer:~,1%" NEQ "Y" goto zipno
echo.
:zipyes
echo.
cd ..
IF NOT EXIST backup.zip (goto checkzipexe)
echo 'backup.zip' already exists. renaming to backup-OLD.bak
ren backup.zip backup-OLD.bak
:checkzipexe
if not exist zip.exe (echo tool file 'zip.exe' not found. please download it from http://infozip.sourceforge.net or from http://www.info-zip.org/Zip.html ) ELSE (goto dozip)
echo.
pause
exit /b
:dozip
echo compressing all files into 'backup.zip' ...
echo.
copy /y /b goprawncomment.txt+backup\buildprop.txt backup\zipcomment.txt 1>nul 2>&1
REM reference for zip.exe is infozip.sf.net website
zip -UN=UTF8 -9jq backup.zip backup\0-uboot.img backup\1-boot.img backup\2-system.img backup\3-config.img backup\4-blogo.img backup\5-slogo.img backup\6-env.img backup\full_img.fex backup\buildprop.txt
type backup\zipcomment.txt | zip -z backup.zip 1>nul
echo.
echo done. see 'backup.zip' file
start .\backup.zip
:zipno
echo.
echo Firmware backup done. See new files in "backup" folder.
echo.
:exitdone
adb kill-server 1>nul 2>&1
pause
exit /b
