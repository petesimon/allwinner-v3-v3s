::SQUASHFS_UNMAKE.BAT script by BNDias (batch mode version).

@echo off

:: Set source file (2-system.img/rootfs.hex) and destination folder
set SOURCE=UNFEX\2-system.img
set DESTINATION=squashfs-root
setlocal EnableDelayedExpansion
if exist "%~dp0%DESTINATION%" (
	if exist "%~dp0%DESTINATION%"  rd /S /Q "%~dp0%DESTINATION%"
	echo.
	echo Existing %DESTINATION% folder deleted.
	echo.
)
endlocal
"%~dp0squashfs_tools/unsquashfs" -f -n -d "%~dp0%DESTINATION%" "%~dp0%SOURCE%"  >nul 2>&1

