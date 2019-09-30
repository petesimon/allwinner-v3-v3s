::SCRIPTBIN_READ Get hardware configuration file of the camera.
::Works with SFK tool (https://sourceforge.net/projects/swissfileknife/).
::Check GoPrawn.com for details.

@echo off
echo SCRIPTBIN_READ.BAT Extract script.bin configuration file by BNDias for GoPrawn.com
echo.

if not exist "%~dp0sfk.exe" goto SFKNOTFOUND

if not exist "%~dp0full_img.fex" if not exist "%~dp0UNFEX/0-uboot.img" (
	goto IMGNOTFOUND
)
if exist "%~dp0full_img.fex" if not exist "%~dp0UNFEX/0-uboot.img" (
	goto FULLIMGPROCESS
)
if exist "%~dp0UNFEX/0-uboot.img" if not exist "%~dp0full_img.fex" (
	goto UBOOTIMGPROCESS
)
if exist "%~dp0full_img.fex" if exist "%~dp0UNFEX/0-uboot.img" (
	goto PROMPT
)

:PROMPT
echo Extract script.bin file from:
echo    1) full_img.fex
echo    2) UNFEX/0-uboot.img
echo    0) cancel
:PROMPTOPTION
set /p input=Option: 
if /i "%input%" EQU "1" goto FULLIMGPROCESS
if /i "%input%" EQU "2" goto UBOOTIMGPROCESS
if /i "%input%" EQU "0" goto EXITBAT
goto :PROMPTOPTION


:FULLIMGPROCESS
echo.
if exist "%~dp0script.bin" (
	copy "%~dp0script.bin" "%~dp0script.bin.bak">nul
	echo Existing SCRIPT.BIN file renamed to SCRIPT.BIN.BAK
)
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x32000" "36272" "%~dp0script.bin" "-yes" "-quiet"
echo Extracting script.bin from full_img.fex...
echo Done. Check SCRIPT.BIN file.
echo.
goto EXITBAT

:UBOOTIMGPROCESS
echo.
if exist "%~dp0script.bin" (
	copy "%~dp0script.bin" "%~dp0script.bin.bak">nul
	echo Existing SCRIPT.BIN file renamed to SCRIPT.BIN.BAK
)
"%~dp0sfk" "partcopy" "%~dp0UNFEX/0-uboot.img" "0x32000" "36272" "%~dp0script.bin" "-yes" "-quiet"
echo Extracting script.bin from UNFEX/0-uboot.img...
echo Done. Check SCRIPT.BIN file.
echo.
goto EXITBAT

:EXITBAT
echo Press any key to exit...
pause>nul
exit


:SFKNOTFOUND
echo SFK.EXE not found - Please download it from: https://sourceforge.net/projects/swissfileknife/
goto EXITBAT

:IMGNOTFOUND
echo FULL_IMG.FEX or UNFEX/0-UBOOT.IMG not found.
goto EXITBAT