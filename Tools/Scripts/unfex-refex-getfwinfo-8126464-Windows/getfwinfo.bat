::GETFWINFO.BAT script for getting firmware details in one click by nutsey for GoPrawn.com
@echo off
setlocal
set v3size=12058624
set v3ssize=8388608
set fullfex=full_img.fex
if not exist full_img.fex GOTO FEXNOTFOUND
IF NOT EXIST "%~dp0sfk.exe" goto SFKNOTFOUND
echo Auto FWINFO script by nutsey v0.4.
echo.
echo  [====--------------------] 10%%
call "scriptbin_read.cmd"
cls
echo Auto FWINFO script by nutsey v0.4.
echo.
echo  [========----------------] 20%%
call "convertscriptbin.cmd"
cls
echo Auto FWINFO script by nutsey v0.4.
echo.
echo  [============------------] 40%%
FOR %%A IN (%fullfex%) DO set size=%%~zA
IF %size% EQU %v3size% (
call "unfex_v3.cmd"
echo SoC:  > fwinfo.tmp
echo    Allwinner V3 >> fwinfo.tmp
)
IF %size% EQU %v3ssize% (
call "unfex_v3s.cmd"
echo SoC:  > fwinfo.tmp
echo    Allwinner V3s >> fwinfo.tmp
)
cls
echo Auto FWINFO script by nutsey v0.4.
echo.
echo  [================--------] 60%%
call "squashfs_unmake.cmd"
cls
echo Auto FWINFO script by nutsey v0.4.
echo.
echo  [====================----] 80%%
call "fwinfo.cmd"
cls
echo Auto FWINFO script by nutsey v0.4.
echo.
echo  [========================] 100%%
echo.
echo Done!
echo.
cls
echo Auto FWINFO script by nutsey v0.4.
echo.
type FWINFO\fwinfo.txt
echo.
echo Files FWINFO.TXT, ON-LOGO.JPG and OFF-LOGO.JPG saved to FWINFO folder.
echo.
:PROMPT
echo Do you want to delete extracted temp files?
set INPUT=
set /P INPUT=(y/n): %=%
If /I "%INPUT%"=="y" goto yes 
If /I "%INPUT%"=="n" exit
echo Press "y" or "n" and hit Enter & GOTO PROMPT
:FEXNOTFOUND
echo FULL_IMG.FEX not found!
echo.
echo Put FULL_IMG.FEX file from your firmware backup to the scripts folder. Press any key to exit...
pause>nul
exit
:SFKNOTFOUND
echo SFK.EXE not found - Please download it from: https://sourceforge.net/projects/swissfileknife/
echo.
echo Press any key to exit...
pause>nul
exit
:YES
del "script.bin" >nul 2>&1
del "script.fex" >nul 2>&1
rd /S /Q UNFEX >nul 2>&1
rd /S /Q squashfs-root >nul 2>&1
echo Extracted file deleted. Press any key to exit...
pause>nul
exit
