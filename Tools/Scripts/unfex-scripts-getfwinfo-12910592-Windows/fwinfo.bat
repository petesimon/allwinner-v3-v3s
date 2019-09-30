::FWINFO.BAT script for gathering Allwinner V3 firmware details by nutsey for GoPrawn.com
@echo off
setlocal
if not exist UNFEX\4-blogo.img GOTO LOGONOTFOUND
if not exist UNFEX\5-slogo.img GOTO LOGONOTFOUND
if not exist squashfs-root\build.prop GOTO BUILDPROPNOTFOUND
if not exist squashfs-root\res\cfg\320x240.cfg GOTO CFGNOTFOUND
if not exist script.fex GOTO FEXNOTFOUND
echo Allwinner V3 firmware information script by nutsey v0.2.
echo.
if not exist \FWINFO md FWINFO >nul 2>&1
echo Product:  > fwinfo.tmp
.\sfk extract squashfs-root\build.prop -text "/ro.build.product=*/[part2]/" -astext >> fwinfo.tmp
echo Manufacturer:  >> fwinfo.tmp
.\sfk extract squashfs-root\build.prop -text "/ro.build.user=*/[part2]/" -astext >> fwinfo.tmp
echo FW date:  >> fwinfo.tmp
.\sfk extract squashfs-root\build.prop -text "/ro.build.version.incremental=*.*.*.*/[part6]/" -astext >> fwinfo.tmp
echo Version:  >> fwinfo.tmp
.\sfk extract squashfs-root\res\cfg\320x240.cfg -text "/software_version=*/[part2]/" -astext >> fwinfo.tmp
echo LCD model:  >> fwinfo.tmp
.\sfk extract script.fex -text "/lcd_driver_name = \q*\q/[part2]/" -astext >> fwinfo.tmp
echo Sensor model:  >> fwinfo.tmp
.\sfk extract script.fex -text "/vip_dev0_mname = \q*\q/[part2]/" -astext >> fwinfo.tmp
.\sfk partcopy fwinfo.tmp -fromto 0 -9 FWINFO\fwinfo.txt -yes -quiet
del fwinfo.tmp >nul 2>&1
type FWINFO\fwinfo.txt
copy /B UNFEX\4-blogo.img FWINFO\on-logo.jpg >nul 2>&1
copy /B UNFEX\5-slogo.img FWINFO\off-logo.jpg >nul 2>&1
echo.
echo Check FWINFO folder for ON-LOGO.JPG, OFF-LOGO.JPG and FWINFO.TXT files. Press any key to exit...
pause>nul
exit
:LOGONOTFOUND
echo 4-blogo.img and 5-slogo.img not found in UNFEX folder! Run UNFEX script first. Press any key to exit...
pause>nul
exit
:FEXNOTFOUND
echo SCRIPT.FEX not found! Please exract SCRIPT.BIN and convert it to FEX first. Press any key to exit...
pause>nul
exit
:BUILDPROPNOTFOUND
echo BUILD.PROP not found! Unpack SYSTEM partition before run. Press any key to exit...
pause>nul
exit
:CFGNOTFOUND
echo CFG file not found! Unpack SYSTEM partition before run. Press any key to exit...
pause>nul
exit /b
