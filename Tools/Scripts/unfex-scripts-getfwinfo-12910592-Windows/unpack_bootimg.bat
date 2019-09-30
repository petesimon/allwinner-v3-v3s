::UNPACK_BOOTIMG.BAT script by BNDias.

@echo off

::Set source file and destination folder
set ORIGINAL=UNFEX\1-boot.img
set SOURCE=1-boot.img
set DESTINATION=boot-root

::Change working directory
set ROOT=%~dp0
cd "%ROOT%"

echo UNPACK_BOOTIMG.BAT script by BNDias for GoPrawn.com
echo.

if not exist bootimg.exe goto BOOTIMGNOTFOUND
if not exist "%ORIGINAL%" goto SOURCENOTFOUND
copy /B UNFEX\1-boot.img 1-boot.img >nul 2>&1
if not exist "%SOURCE%" goto SOURCENOTFOUND


if exist "%DESTINATION%" (
    if exist "%DESTINATION%_bak"  rd /S /Q "%DESTINATION%_bak"
    move "%DESTINATION%" "%DESTINATION%_bak" >nul
    echo Existing %DESTINATION% folder renamed to %DESTINATION%_bak
    echo.
)
mkdir "%DESTINATION%"

setlocal EnableDelayedExpansion

::Set exclude list (not extracted files/folders)
if exist ExcludeList.txt del ExcludeList.txt >nul 2>&1
for %%f in (*) do  echo "%%f" >> ExcludeList.txt
for /D %%d in (*) do  echo "%%d" >> ExcludeList.txt
echo "ExcludeList.txt" >> ExcludeList.txt

::Rename source file to BOOT.IMG
if "%SOURCE%" NEQ "boot.img" (
    if exist boot.img del /F boot.img
    ren "%SOURCE%" boot.img >nul
)



::Extract BOOT.IMG
echo Extracting %source%...
echo ==================================================
bootimg --unpack-bootimg boot.img
echo ==================================================



::Rename BOOT.IMG to original filename
if "%SOURCE%" NEQ "boot.img" (
    ren boot.img "%SOURCE%" >nul
)

del 1-boot.img >nul 2>&1

::Copy extracted content to destination folder
for %%f in (*) do (
    find "%%f" ExcludeList.txt >nul
    if !ERRORLEVEL! == 1  move /y "%%f" "%DESTINATION%" >nul
)
for /D %%d in (*) do (
    find "%%d" ExcludeList.txt >nul
    if !ERRORLEVEL! == 1  move /y "%%d" "%DESTINATION%/" >nul
)

::Remove exclude list
del ExcludeList.txt >nul 2>&1

echo.
echo Done. Check "%DESTINATION%" folder.
endlocal


:EXITBAT
echo Press any key to exit...
pause>nul
exit


:BOOTIMGNOTFOUND
echo.
echo BOOTIMG.EXE not found
goto EXITBAT

:SOURCENOTFOUND
echo %SOURCE% file not found
goto EXITBAT