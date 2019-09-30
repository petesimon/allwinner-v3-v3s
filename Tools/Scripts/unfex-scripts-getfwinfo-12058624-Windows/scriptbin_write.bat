::SCRIPTBIN_WRITE Overwrite hardware configuration file of the camera so the
::uboot can pass that to the kernel.
::Works with SFK tool (https://sourceforge.net/projects/swissfileknife/).
::Check GoPrawn.com for details.

@echo off
echo SCRIPTBIN_WRITE.BAT Copy script.bin configuration file to full_img.fex by BNDias for GoPrawn.com
echo.

if not exist "%~dp0sfk.exe" goto SFKNOTFOUND
if not exist "%~dp0script.bin" goto SCRIPTBINNOTFOUND

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
echo Overwrite script.bin file on:
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
copy "%~dp0full_img.fex" "%~dp0full_img.fex.bak">nul
echo Existing FULL_IMG.FEX file renamed to FULL_IMG.FEX.BAK
echo Overwriting script.bin file on full_img.fex...
"%~dp0sfk" "partcopy" "%~dp0script.bin" -allfrom "0x00000" "%~dp0full_img.fex" "0x32000" "-yes" "-quiet"
echo Done. Check FULL_IMG.FEX file.
echo.
goto EXITBAT

:UBOOTIMGPROCESS
echo.
copy "%~dp0UNFEX/0-uboot.img" "%~dp0UNFEX/0-uboot.img.bak">nul
echo Existing UNFEX/0-UBOOT.IMG file renamed to UNFEX/0-UBOOT.IMG.BAK
echo Overwriting script.bin file on UNFEX/0-uboot.img...
"%~dp0sfk" "partcopy" "%~dp0script.bin" -allfrom "0x00000" "%~dp0UNFEX/0-uboot.img" "0x32000" "-yes" "-quiet"
echo Done. Check FULL_IMG.FEX file.
echo.
goto EXITBAT

:EXITBAT
echo Press any key to exit...
pause>nul
exit


:SFKNOTFOUND
echo SFK.EXE not found - Please download it from: https://sourceforge.net/projects/swissfileknife/
goto EXITBAT

:SCRIPTBINNOTFOUND
echo File SCRIPT.BIN not found.
goto EXITBAT

:FULLIMGNOTFOUND
echo FULL_IMG.FEX not found.
goto EXITBAT