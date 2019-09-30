::SQUASHFS_UNMAKE.BAT script by BNDias.

@echo off

:: Set source file (2-system.img/rootfs.hex) and destination folder
set SOURCE=UNFEX\2-system.img
set DESTINATION=squashfs-root
echo SQUASHFS_UNMAKE.BAT script by BNDias for GoPrawn.com
echo.

if not exist "%~dp0squashfs_tools\unsquashfs.exe" goto UNSQUASHFSNOTFOUND
if not exist "%~dp0%SOURCE%" goto SOURCENOTFOUND

setlocal EnableDelayedExpansion
if exist "%~dp0%DESTINATION%" (
	if exist "%~dp0%DESTINATION%_bak"  rd /S /Q "%~dp0%DESTINATION%_bak"
    move "%~dp0%DESTINATION%" "%DESTINATION%_bak">nul
	echo Existing %DESTINATION% folder renamed to %DESTINATION%_bak
	echo.
)
endlocal

echo.
"%~dp0squashfs_tools/unsquashfs" -f -d "%~dp0%DESTINATION%" "%~dp0%SOURCE%"
echo.
echo.
echo.
echo Done. Check "%DESTINATION%" folder.

:EXITBAT
echo Press any key to exit...
pause>nul
exit


:UNSQUASHFSNOTFOUND
echo.
echo SQUASHFS_TOOLS/UNSQUASHFS.EXE not found
if not exist "%~dp0squashfs_tools" mkdir "%~dp0squashfs_tools"
goto EXITBAT

:SOURCENOTFOUND
echo %SOURCE% file not found
goto EXITBAT