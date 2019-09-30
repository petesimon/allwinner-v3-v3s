GETFWINFO v0.4 script. Instructions:

Modified by Petesimon with help from MissingNo, SamWilson98 and nutsey
on GoPrawn forums, for 8126464 bytes full_img.fex

Put FULL_IMG.FEX from your firmware backup into the main script folder. 
Run GETFWINFO.BAT to get details about your Allwinner V3/V3s firmware. 

* If GETFWINFO.BAT does not work for you, then try to run these scripts directly
and in this order:

unfex.bat
scriptbin_read.bat
convertscriptbin.bat       -- you will need Java installed
squashfs_unmake.bat
fwinfo.bat

and last getfwinfo.bat 

The .cmd scripts may or may not work for you.

FWINFO.TXT file, boot and shutdown logo JPG files will be copied to FWINFO folder.

Firmware files' structures for various 'small' 8MB firmware:

8 MB firmware structure (V3 chip) "v1":
0x000000 - 03FFFF u-boot (script.bin starts from 032000)
0x040000 - 29FFFF boot (kernel)
0x2A0000 - 75FFFF system (mounted as read-only squashfs)
0x760000 - 7DFFFF config (/data)
0x7E0000 - 7EFFFF boot/shutdown logo (jpeg)
0x7F0000 - 7FFFFF env (u-boot params)

8 MB firmware structure (V3 chip) "v2":
0x000000 - 03FFFF u-boot (script.bin starts from 032000)
0x040000 - 29FFFF boot (kernel)
0x2A0000 - 74FFFF system (mounted as read-only squashfs)
0x750000 - 7CFFFF config (/data)
0x7D0000 - 7DFFFF boot logo (jpeg)
0x7E0000 - 7EFFFF shutdown logo (jpeg)
0x7F0000 - 7FFFFF env (u-boot params)

8 MB firmware structure (V3s chip) "v1":
0x000000 - 03FFFF u-boot (script.bin starts from 032000)
0x040000 - 2DFFFF boot (kernel)
0x2E0000 - 74FFFF system (mounted as read-only squashfs)
0x750000 - 7CFFFF config (/data)
0x7D0000 - 7DFFFF boot logo (jpeg)
0x7E0000 - 7EFFFF shutdown logo (jpeg)
0x7F0000 - 7FFFFF env (u-boot params)

8 MB firmware structure (V3s chip) "v2":
0x000000 - 03FFFF u-boot (script.bin starts from 032000)
0x040000 - 2EFFFF boot (kernel)
0x2F0000 - 74FFFF system (mounted as read-only squashfs)
0x750000 - 7CFFFF config (/data)
0x7D0000 - 7DFFFF boot logo (jpeg)
0x7E0000 - 7EFFFF shutdown logo (jpeg)
0x7F0000 - 7FFFFF env (u-boot params)

------

code in UNFEX.BAT has been changed to the following for 8126464 bytes full_img.fex :
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0" "262144" "%~dp0UNFEX\0-uboot.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x40000" "2621440" "%~dp0UNFEX\1-boot.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x2C0000" "4718592" "%~dp0UNFEX\2-system.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x740000" "327680" "%~dp0UNFEX\3-config.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x790000" "65536" "%~dp0UNFEX\4-blogo.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x7A0000" "65536" "%~dp0UNFEX\5-slogo.img" "-yes" "-quiet"
"%~dp0sfk" "partcopy" "%~dp0full_img.fex" "0x7B0000" "65536" "%~dp0UNFEX\6-env.img" "-yes" "-quiet"

-------

in REFEX.BAT and SQUASHFS_MAKE.BAT every instance of 6488064 has been changed to 4718592 for 2-system.img

-------

in JP2IMG.BAT, every instance of 131072 has been changed to 65536 for 4-blogo.img and 5-slogo.img

-------

Check www.GoPrawn.com action cam discussion forum online for more details.

Link:

https://www.goprawn.com/forum/allwinner-cams/25-allwinner-v3-s-imx179-s-ov4689-and-gc2023-action-cameras
