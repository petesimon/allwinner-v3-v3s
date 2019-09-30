::FWINFO.CMD script for batch mode by nutsey for GoPrawn.com
@echo off
setlocal
echo.
.\sfk extract squashfs-root\etc\MiniGUI.cfg -text "/defaultmode=*-32bpp/[part2]/" -astext -firsthit > lcdres.tmp
.\sfk partcopy lcdres.tmp -allfrom 3 lcdres2.tmp -yes -quiet
set /P lcdres=<lcdres.tmp
set /P lcdres2=<lcdres2.tmp
del lcdres.tmp >nul 2>&1
del lcdres2.tmp >nul 2>&1
if not exist \FWINFO md FWINFO >nul 2>&1
echo Product:  >> fwinfo.tmp
.\sfk extract squashfs-root\build.prop -text "/ro.build.product=*/[part2]/" -astext >> fwinfo.tmp
echo Manufacturer:  >> fwinfo.tmp
.\sfk extract squashfs-root\build.prop -text "/ro.build.user=*/[part2]/" -astext >> fwinfo.tmp
if exist .\squashfs-root\etc\info.xml (
echo Short id:  >> fwinfo.tmp
.\sfk extract squashfs-root\etc\info.xml -text "/<Short>*</[part2]/" -astext >> fwinfo.tmp
echo OEM id:  >> fwinfo.tmp
.\sfk extract squashfs-root\etc\info.xml -text "/<SubClient>*</[part2]/" -astext >> fwinfo.tmp
echo Camera type:  >> fwinfo.tmp
.\sfk extract squashfs-root\etc\info.xml -text "/<CamType>*</[part2]/" -astext >> fwinfo.tmp
echo FW orig. date:  >> fwinfo.tmp
.\sfk extract squashfs-root\build.prop -text "/ro.build.version.incremental=*.*.*.*/[part6]/" -astext >> fwinfo.tmp
echo FW mod. date:  >> fwinfo.tmp
.\sfk extract squashfs-root\etc\info.xml -text "/<FirmDate>*</[part2]/" -astext >> fwinfo.tmp
) else (
echo FW date:  >> fwinfo.tmp
.\sfk extract squashfs-root\build.prop -text "/ro.build.version.incremental=*.*.*.*/[part6]/" -astext >> fwinfo.tmp
)
echo Camera name:  >> fwinfo.tmp
.\sfk extract squashfs-root\res\cfg\%lcdres2%.cfg -text "/product_type=*/[part2]/" -astext >> fwinfo.tmp
echo Version:  >> fwinfo.tmp
.\sfk extract squashfs-root\res\cfg\%lcdres2%.cfg -text "/software_version=*/[part2]/" -astext >> fwinfo.tmp
echo LCD model:  >> fwinfo.tmp
.\sfk extract script.fex -text "/lcd_driver_name = \q*\q/[part2]/" -astext >> fwinfo.tmp
echo LCD resolution:  >> fwinfo.tmp
echo %lcdres%  >> fwinfo.tmp
if exist .\squashfs-root\etc\info.xml (
echo LCD count:  >> fwinfo.tmp
.\sfk extract squashfs-root\etc\info.xml -text "/<ScreenStruct>*</[part2]/" -astext >> fwinfo.tmp
)
echo Sensor model:  >> fwinfo.tmp
.\sfk extract script.fex -text "/vip_dev0_mname = \q*\q/[part2]/" -astext >> fwinfo.tmp
.\sfk partcopy fwinfo.tmp -fromto 0 -9 FWINFO\fwinfo.txt -yes -quiet
del fwinfo.tmp >nul 2>&1
copy /B UNFEX\4-blogo.img FWINFO\on-logo.jpg >nul 2>&1
copy /B UNFEX\5-slogo.img FWINFO\off-logo.jpg >nul 2>&1
echo.
