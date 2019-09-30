::REFEX.BAT full_img.fex packing script by nutsey. Based on pack/unpack script by losber.
::Packs partition files from UNFEX folder into full_img.fex
::Make sure you have proper partition files in UNFEX folder. Use at your own risk!!!
::Check GoPrawn.com for details.

:: modified by petesimon of Goprawn forums for Yi Discovery firmware

@echo off
setlocal
set sysfile="%~dp0UNFEX\2-system.img"
set syssize=8388608
echo REFEX.BAT full_img.fex packing script by nutsey for GoPrawn.com
echo.

IF NOT EXIST "%~dp0sfk.exe" goto SFKNOTFOUND
IF NOT EXIST "%~dp0UNFEX\0-uboot.img" GOTO NOTFOUND
IF NOT EXIST "%~dp0UNFEX\1-boot.img" GOTO NOTFOUND
IF NOT EXIST "%~dp0UNFEX\2-system.img" GOTO NOTFOUND
IF NOT EXIST "%~dp0UNFEX\3-config.img" GOTO NOTFOUND
IF NOT EXIST "%~dp0UNFEX\4-blogo.img" GOTO NOTFOUND
IF NOT EXIST "%~dp0UNFEX\5-slogo.img" GOTO NOTFOUND
IF NOT EXIST "%~dp0UNFEX\6-env.img" GOTO NOTFOUND

FOR %%A IN (%sysfile%) DO set size=%%~zA
IF %size% GTR %syssize% GOTO BADFILESIZE

IF %size% LSS %syssize% (
    echo Processing 2-SYSTEM.IMG...
    echo.
	IF NOT EXIST "%~dp0sysdummy.bin" GOTO DUMMYNOTFOUND
    copy /b "%~dp0UNFEX\2-system.img"+"%~dp0sysdummy.bin" "%~dp02-system.tmp" >nul 2>&1
    "%~dp0sfk" "partcopy" "%~dp02-system.tmp" "0" "%syssize%" "%~dp0UNFEX\2-system.img" "-yes" "-quiet"
    del "%~dp02-system.tmp" >nul 2>&1
)

IF EXIST "%~dp0full_img.fex" (
    IF EXIST "%~dp0full_img.fex.bak"  del /F "%~dp0full_img.fex.bak"
    ren "%~dp0full_img.fex" "full_img.fex.bak">nul
    echo Existing FULL_IMG.FEX file renamed to FULL_IMG.FEX.BAK 
    echo.
)

echo Merging partitions...
echo.
copy /b "%~dp0UNFEX\0-uboot.img"+"%~dp0UNFEX\1-boot.img"+"%~dp0UNFEX\2-system.img"+"%~dp0UNFEX\3-config.img"+"%~dp0UNFEX\4-blogo.img"+"%~dp0UNFEX\5-slogo.img"+"%~dp0UNFEX\6-env.img" "%~dp0full_img.fex" >nul 2>&1
echo Done. Partition files packed to FULL_IMG.FEX.
echo Press any key to exit...
pause>nul
exit


:SFKNOTFOUND
echo SFK.EXE not found - Please download it from: https://sourceforge.net/projects/swissfileknife/
echo Press any key to exit...
pause>nul
exit

:NOTFOUND
echo Partition file(-s) in UNFEX folder not found.
echo Press any key to exit...
pause>nul
exit

:DUMMYNOTFOUND
echo SYSDUMMY.BIN file not found
echo Press any key to exit...
pause>nul
exit

:BADFILESIZE
echo Error! The size of 2-SYSTEM.IMG file exceeds %syssize% bytes.
echo Press any key to exit...
pause>nul
exit
