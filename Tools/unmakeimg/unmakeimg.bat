@echo off
:: unmakeimg.bat script by petesimon of www.goprawn.com forums
:: DRAG AND DROP A PHOENIXSUIT .img FILE ON THIS unmakeimg.bat SCRIPT FILE TO UNPACK IT

echo.
:: "%~1" allow processing long file names with spaces such as "long file name image.img"

echo processing file "%~1"
echo.
"%~dp0imgRePacker.exe" /2nd /log /skip "%~1"
echo.
echo done. look in %1.dump folder for new unpacked files
echo.
echo also see %1.log text file for more information
echo.
pause