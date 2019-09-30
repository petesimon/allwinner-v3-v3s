GETFWINFO v0.4 script. Instructions:
For full_img.fex 12910592 bytes in size from a Yi Discovery camera.

Put FULL_IMG.FEX from your firmware backup into the main script folder. 
Run GETFWINFO.BAT to get details about your Allwinner V3/V3s firmware. 

FWINFO.TXT file, boot and shutdown logo JPG files will be copied to FWINFO folder.

Check GoPrawn.com action cam discussion forum for more details.

Firmware structure for Yi Discovery camera.

"0" "262144" 0-uboot.img
"0x40000" "2883584" 1-boot.img
"0x300000" "8388608" 2-system.img
"0xB00000" "1048576" 3-config.img
"0xC00000" "131072" 4-blogo.img
"0xC20000" "131072" 5-slogo.img
"0xC40000" "65536" 6-env.img

FULL_IMG.FEX file size is 12910592 bytes. This is _larger_ than most other firmware files.

* If GETFWINFO.BAT does not work for you, then try to run these scripts directly
one-by-one and run the scripts in this order:

unfex.bat
scriptbin_read.bat
convertscriptbin.bat       -- you will need Java installed
squashfs_unmake.bat
fwinfo.bat

and the .cmd scripts may also not work for you.
