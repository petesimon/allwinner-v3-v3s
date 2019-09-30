::UNFEX.BAT full_img.fex unpacking script by nutsey. Based on pack/unpack script by losber.
::Works with SFK tool (https://sourceforge.net/projects/swissfileknife/).
::Put full_img.fex file into folder containing this script if you want to extract files.
::Separate partition files will be extracted into UNFEX folder.
::Check GoPrawn.com for details.

@echo off
echo UNFEX.BAT full_img.fex unpacking script by nutsey for GoPrawn.com
echo.

IF NOT EXIST "%~dp0sfk.exe" goto SFKNOTFOUND

IF NOT EXIST "%~dp0full_img.fex" (
	echo File FULL_IMG.FEX not found.
	echo copy a FULL_IMG.FEX file to the same folder where the scripts are located.
	echo Press any key to exit...
	pause>nul
	exit
)

:: for "small" firmware, 8126464 bytes full_img.fex
:: see post #603, and see comment #603.2 on www.goprawn.com forums for more info
IF NOT EXIST "%~dp0UNFEX" md "%~dp0UNFEX" >nul 2>&1
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0" "262144" "%~dp0UNFEX\0-uboot.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x40000" "2621440" "%~dp0UNFEX\1-boot.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x2C0000" "4718592" "%~dp0UNFEX\2-system.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x740000" "327680" "%~dp0UNFEX\3-config.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x790000" "65536" "%~dp0UNFEX\4-blogo.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x7A0000" "65536" "%~dp0UNFEX\5-slogo.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x7B0000" "65536" "%~dp0UNFEX\6-env.img" "-yes" "-quiet"
echo Done. Check UNFEX folder for extracted files.

echo Press any key to exit...
pause>nul
exit

:SFKNOTFOUND
echo SFK.EXE not found - Please download it from: https://sourceforge.net/projects/swissfileknife/
echo Press any key to exit...
pause>nul
exit