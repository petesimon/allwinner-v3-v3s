::UNFEX.BAT full_img.fex unpacking script by nutsey (v3s version). Based on pack/unpack script by losber. Works with SFK tool (https://sourceforge.net/projects/swissfileknife/).
::Put full_img.fex file into folder containing this script if you want to extract files.
::Separate partition files will be extracted into UNFEX folder.
::Check GoPrawn.com for details.

@echo off

IF NOT EXIST "%~dp0UNFEX" md "%~dp0UNFEX" >nul 2>&1
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0" "262144" "%~dp0UNFEX\0-uboot.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x40000" "2818048" "%~dp0UNFEX\1-boot.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x2F0000" "4587520" "%~dp0UNFEX\2-system.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x750000" "524288" "%~dp0UNFEX\3-config.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x7D0000" "65536" "%~dp0UNFEX\4-blogo.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x7E0000" "65536" "%~dp0UNFEX\5-slogo.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x7F0000" "65536" "%~dp0UNFEX\6-env.img" "-yes" "-quiet"

