::SQUASHFS_MAKE.BAT script by BNDias.

@echo off

:: Set source folder and destination file
set SOURCE=squashfs-root
set DESTINATION=UNFEX\2-system.img
set DESTSIZE=6488064
echo SQUASHFS_MAKE.BAT script by BNDias for GoPrawn.com
echo.

if not exist "%~dp0squashfs_tools\mksquashfs.exe" goto MKSQUASHFSNOTFOUND
if not exist "%~dp0%SOURCE%" goto SOURCENOTFOUND

setlocal EnableDelayedExpansion
if exist "%~dp0%DESTINATION%" (
	if exist "%~dp0%DESTINATION%.bak"  del /F "%~dp0%DESTINATION%.bak"
	for %%A in ("%~dp0%DESTINATION%") do  set FILENAME=%%~nxA
	ren "%~dp0%DESTINATION%" "!FILENAME!.bak">nul
	echo Existing %DESTINATION% file renamed to %DESTINATION%.bak
	echo.
)
endlocal

echo.
"%~dp0squashfs_tools/mksquashfs" "%~dp0%SOURCE%" "%~dp0%DESTINATION%" -comp xz -Xbcj x86 -noappend -no-recovery -root-owned
echo.
echo.
echo.
for %%A in (%DESTINATION%) do set size=%%~zA
if %size% GTR %DESTSIZE% goto BADFILESIZE
if %size% LSS %DESTSIZE% (
	if not exist "%~dp0sysdummy.bin" GOTO DUMMYNOTFOUND
    copy /b "%~dp0UNFEX\2-system.img"+"%~dp0sysdummy.bin" "%~dp02-system.tmp" >nul 2>&1
    "%~dp0sfk" "partcopy" "%~dp02-system.tmp" "0" "6488064" "%~dp0UNFEX\2-system.img" "-yes" "-quiet"
    del "%~dp02-system.tmp" >nul 2>&1
)
echo Done. Check "%DESTINATION%" file.

:EXITBAT
echo Press any key to exit...
pause>nul
exit


:MKSQUASHFSNOTFOUND
echo.
echo SQUASHFS_TOOLS/MKSQUASHFS.EXE not found
if not exist "%~dp0squashfs_tools" mkdir "%~dp0squashfs_tools"
goto EXITBAT

:SOURCENOTFOUND
echo %SOURCE% folder not found
goto EXITBAT

:BADFILESIZE
echo Error! The size of "%DESTINATION%" file exceeds %DESTSIZE% bytes.
del /F "%~dp0%DESTINATION%">nul
goto EXITBAT

:DUMMYNOTFOUND
echo SYSDUMMY.BIN file not found
goto EXITBAT