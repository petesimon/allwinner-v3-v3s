::UNFEX.BAT full_img.fex unpacking script by nutsey. Based on pack/unpack script by losber. Works with SFK tool (https://sourceforge.net/projects/swissfileknife/).
::Put full_img.fex file into folder containing this script if you want to extract files.
::Separate partition files will be extracted into UNFEX folder.
::Check GoPrawn.com for details.

@echo off
echo UNFEX.BAT full_img.fex unpacking script by nutsey for GoPrawn.com
echo.

IF NOT EXIST "%~dp0sfk.exe" goto SFKNOTFOUND

IF NOT EXIST "%~dp0full_img.fex" (
	echo File FULL_IMG.FEX not found.
	echo Press any key to exit...
	pause>nul
	exit
)

IF NOT EXIST "%~dp0UNFEX" md "%~dp0UNFEX" >nul 2>&1
"%~dp0sfk" "partcopy" "%~dp0full_img.fex"       "0" "262144" "%~dp0UNFEX\0-uboot.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x40000" "1835008" "%~dp0UNFEX\1-boot.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x200000" "4980736" "%~dp0UNFEX\2-system.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x6C0000" "524288" "%~dp0UNFEX\3-config.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x740000" "65536" "%~dp0UNFEX\4-blogo.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x750000" "65536" "%~dp0UNFEX\5-slogo.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x760000" "65536" "%~dp0UNFEX\6-env.img" "-yes" "-quiet"
echo Done. Check REFEX folder for extracted files.

echo Press any key to exit...
pause>nul
exit


:SFKNOTFOUND
echo SFK.EXE not found - Please download it from: https://sourceforge.net/projects/swissfileknife/
echo Press any key to exit...
pause>nul
exit