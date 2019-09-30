::REPACK_BOOTIMG.BAT script by BNDias.

@echo off

::Set source folder and destination file
set SOURCE=boot-root
set DESTINATION=1-boot.img
set DESTSIZE=1835008

::Change working directory
set ROOT=%~dp0
cd "%ROOT%"

echo UNPACK_BOOTIMG.BAT script by BNDias for GoPrawn.com
echo.

if not exist bootimg.exe goto BOOTIMGNOTFOUND
if not exist "%~dp0sfk.exe" goto SFKNOTFOUND
if not exist "%SOURCE%" goto SOURCENOTFOUND

if exist "%DESTINATION%" (
    if exist "%DESTINATION%.bak"  del /F "%DESTINATION%.bak"
    for %%A in ("%~dp0%DESTINATION%") do  set FILENAME=%%~nxA
    ren "%DESTINATION%" "!FILENAME!.bak">nul
    echo Existing %DESTINATION% file renamed to %DESTINATION%.bak
    echo.
)

setlocal EnableDelayedExpansion

::Set exclude list (not extracted files/folders)
if exist ExcludeList.txt del ExcludeList.txt >nul 2>&1
for %%f in (*) do  echo "%%f" >> ExcludeList.txt
for /D %%d in (*) do  echo "%%d" >> ExcludeList.txt
echo "%DESTINATION%" >> ExcludeList.txt
echo "ExcludeList.txt" >> ExcludeList.txt

::Copy source content to root folder
xcopy %SOURCE% . /e /v /r /y /i /k >nul

echo Repacking %source%...
echo ==================================================
bootimg --repack-bootimg
echo ==================================================

::Rename BOOT-NEW.IMG to destination filename
if "%DESTINATION%" NEQ "boot-new.img" (
    ren boot-new.img "%DESTINATION%" >nul
)

::Remove source content from root folder
for %%f in (*) do (
    find "%%f" ExcludeList.txt >nul
    if !ERRORLEVEL! == 1  del "%%f" >nul 2>&1
)
for /D %%d in (*) do (
    find "%%d" ExcludeList.txt >nul
    if !ERRORLEVEL! == 1  del "%%d" >nul 2>&1
)

::Remove exclude list
del ExcludeList.txt >nul 2>&1

for %%A in ("%DESTINATION%") do set size=%%~zA
if %size% GTR %DESTSIZE% goto BADFILESIZE
if %size% LSS %DESTSIZE% (
    if not exist rootdummy.bin GOTO DUMMYNOTFOUND
    copy /b "%DESTINATION%"+"rootdummy.bin" "boot.tmp" >nul 2>&1
    sfk "partcopy" "boot.tmp" "0" "%DESTSIZE%" "%DESTINATION%" "-yes" "-quiet"
    del "boot.tmp" >nul 2>&1
)

echo.
echo Done. Check "%DESTINATION%" file.
endlocal


:EXITBAT
echo Press any key to exit...
pause>nul
exit


:BOOTIMGNOTFOUND
echo.
echo BOOTIMG.EXE not found
goto EXITBAT

:SFKNOTFOUND
echo SFK.EXE not found - Please download it from: https://sourceforge.net/projects/swissfileknife/
goto EXITBAT

:SOURCENOTFOUND
echo %SOURCE% folder not found
goto EXITBAT

:BADFILESIZE
echo Error! The size of "%DESTINATION%" file exceeds %DESTSIZE% bytes.
del /F "%DESTINATION%">nul
goto EXITBAT

:DUMMYNOTFOUND
echo ROOTDUMMY.BIN file not found
del /F "%DESTINATION%">nul
goto EXITBAT