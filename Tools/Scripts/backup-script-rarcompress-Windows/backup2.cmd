@echo off
echo Allwinner V3 action cam firmware backup script by nutsey for www.GoPrawn.com forums
REM 'backup2.cmd' script
REM modified by user 'petesimon' for rar compression of backup files
REM WinRar file format is version 5 !
REM modifiied by @mattbatt of goprawn forums for some odd cameras that don't have 'dd' command
echo.
IF NOT EXIST adb.exe (echo tool file 'adb.exe' android debug not found. please provide a copy of it. now exiting...) ELSE (goto adbdevices)
echo.
pause
exit /b
:adbdevices
echo please wait ...
adb kill-server 1>nul 2>&1
adb get-state 1>nul 2>&1
IF %ERRORLEVEL% GTR 0 (echo device not found. check camera and usb connection and try again. now exiting...) ELSE (goto dobackup)
echo.
pause
exit /b

:dobackup
echo.
echo Backing up firmware files...
adb root 1>nul 2>&1
adb remount 1>nul 2>&1
echo.

IF EXIST "backup" (
    echo found existing backup folder on computer's hard drive. renaming it to backup-old
    ren backup backup-old
    echo.
    )
mkdir backup

adb remount 1>nul 2>&1
adb shell cd /
:: mtdblock* data is not saved on sdcard
echo. removing old backup folder from the sdcard
adb shell rm -r /mnt/extsd/backup 1>nul 2>&1
echo.
:: changed /system/bin/dd commands to adb pull /dev/block/mtdblock* commands
:: because 'dd' may not be available in some stock firmware
:: mtdblock* data is saved on computer hard drive
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
:: get build.prop text from device
adb pull /system/build.prop 1>nul 2>&1
more build.prop > buildprop.txt 1>nul 2>&1
copy buildprop.txt backup/buildprop.txt
del build.prop 1>nul 2>&1
echo.
cd backup
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
echo.
REM reference for rar.exe is Rar.txt file from rarlab.com website
copy /y /b goprawncomment.txt+backup\buildprop.txt backup\rarcomment.txt 1>nul 2>&1
.\rar a -logAFU -s -ma5 -m5 -idc -ai -ed -ep -md128m backup.rar backup\buildprop.txt backup\0-uboot.img backup\1-boot.img backup\2-system.img backup\3-config.img backup\4-blogo.img backup\5-slogo.img backup\6-env.img backup\full_img.fex fixed_script.txt
.\rar c -idq -scA -zbackup\rarcomment.txt backup.rar
echo.
echo compressing done. see 'backup.rar' archive file.
echo.
echo NOTICE:  RAR FILE IS VERSION 5.0 !
echo NOTICE:  YOU WILL NEED LATEST VERSION OF WINRAR OR 7-ZIP
if exist backup.rar (start .\backup.rar) else (echo backup.rar was not created)
:rarno
echo.
echo Firmware backup done. See new files in current folder AND in "backup" folder.
echo.
:exitdone
adb kill-server 1>nul 2>&1
pause
exit /b
