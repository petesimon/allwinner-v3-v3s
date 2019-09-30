::MAKEIMG.BAT Script by nutsey. Based on pack/unpack script by losber. Works with imgRePacker tool by RedScorpio.
::Put full_img.fex file into goprawn.img.dump folder before running this script.
::IMG file produced by the script can be flashed with PhoenixSuit tool.
::Check GoPrawn.com for details.
@echo off
"%~dp0imgRePacker" "goprawn.img.dump"
echo Firmware image file goprawn.img created. Press any key to exit.
pause>nul
exit
