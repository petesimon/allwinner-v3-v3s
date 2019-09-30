::JPG2IMG.BAT converting script by nutsey.
::Converts JPEG image files to IMG files for using with REFEX script.
::Put BLOGO.JPG and SLOGO.JPG files to UNFEX folder before running this script. They will be converted to 4-BLOGO.IMG and 5-SLOGO.IMG files you can pack into FULL_IMG.FEX with REFEX.
::Original IMG files will be renamed to BAK.
::Check GoPrawn.com for details.

:: * this script modified for firmware full_img.fex that is 7798784 bytes
:: * 'maxsize' for jpg images is 65536 bytes
:: * every instance of 131072 is changed to 65536

@echo off
setlocal
set bfile="%~dp0UNFEX\blogo.jpg"
set sfile="%~dp0UNFEX\slogo.jpg"
set maxsize=65536
echo JPG2IMG.BAT converting script by nutsey for GoPrawn.com
echo.

IF NOT EXIST "%~dp0sfk.exe" goto SFKNOTFOUND
IF NOT EXIST "%~dp0UNFEX\blogo.jpg" GOTO NOTFOUND
IF NOT EXIST "%~dp0UNFEX\slogo.jpg" GOTO NOTFOUND
IF NOT EXIST "%~dp0jpgdummy.bin" GOTO DUMMYNOTFOUND

FOR %%A IN (%bfile%) DO set size=%%~zA
IF %size% GTR %maxsize% GOTO BADFILESIZE
FOR %%A IN (%sfile%) DO set size=%%~zA
IF %size% GTR %maxsize% GOTO BADFILESIZE

IF EXIST "%~dp0UNFEX\4-blogo.img.bak" (
	del "%~dp0UNFEX\4-blogo.img.bak" >nul 2>&1
)
IF EXIST "%~dp0UNFEX\5-slogo.img.bak" (
	del "%~dp0UNFEX\5-slogo.img.bak" >nul 2>&1
)
IF EXIST "%~dp0UNFEX\4-blogo.img" (
	ren "%~dp0UNFEX\4-blogo.img" "4-blogo.img.bak"
	echo Existing 4-BLOGO.IMG file renamed to 4-BLOGO.IMG.BAK
	echo.
)
IF EXIST "%~dp0UNFEX\5-slogo.img" (
	ren "%~dp0UNFEX\5-slogo.img" "5-slogo.img.bak"
	echo Existing 5-SLOGO.IMG file renamed to 5-SLOGO.IMG.BAK
	echo.
)

copy /b "%~dp0UNFEX\blogo.jpg"+"%~dp0jpgdummy.bin" "%~dp0blogo.tmp" >nul 2>&1
copy /b "%~dp0UNFEX\slogo.jpg"+"%~dp0jpgdummy.bin" "%~dp0slogo.tmp" >nul 2>&1
"%~dp0sfk" "partcopy" "%~dp0blogo.tmp" "0" "65536" "%~dp0UNFEX\4-blogo.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0slogo.tmp" "0" "65536" "%~dp0UNFEX\5-slogo.img" "-yes" "-quiet"
del "%~dp0blogo.tmp" >nul 2>&1
del "%~dp0slogo.tmp" >nul 2>&1

echo Done. JPEG files converted to IMG.
echo Press any key to exit...
pause>nul
exit

:SFKNOTFOUND
echo SFK.EXE not found - Please download it from: https://sourceforge.net/projects/swissfileknife/
echo Press any key to exit...
pause>nul
exit

:NOTFOUND
echo JPEG file(-s) in UNFEX folder not found.
echo Press any key to exit...
pause>nul
exit

:DUMMYNOTFOUND
echo JPGDUMMY.BIN file not found
echo Press any key to exit...
pause>nul
exit

:BADFILESIZE
echo File size of JPEG file(-s) exceeds 65536 bytes.
echo Press any key to exit...
pause>nul
exit
