::SCRIPTBIN_READ Get hardware configuration file of the camera.
::Works with SFK tool (https://sourceforge.net/projects/swissfileknife/).
::Check GoPrawn.com for details.

@echo off
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x32000" "36272" "%~dp0script.bin" "-yes" "-quiet"

