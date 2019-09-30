GETFWINFO v0.4 script. Instructions:
For full_img.fex 7798784 bytes in size from dirt cheap V3 and V3s cameras.

Modified by Petesimon with help from MissingNo and SamWilson98 on GoPrawn forums.

Put FULL_IMG.FEX from your firmware backup into the main script folder. 
Run GETFWINFO.BAT to get details about your Allwinner V3/V3s firmware. 

* If GETFWINFO.BAT does not work for you, then try to run these scripts directly
and in this order:

unfex.bat
scriptbin_read.bat
convertscriptbin.bat       -- you will need Java installed
squashfs_unmake.bat
fwinfo.bat
getfwinfo.bat              -- this must be last

but the .cmd scripts may also not work for you.

FWINFO.TXT file, boot and shutdown logo JPG files will be copied to FWINFO folder.

Firmware files' structures for 'small' 8MB firmware:

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

offsets in the UNFEX.BAT file have been changed to the following:
      "0" "262144"
"0x40000" "1835008"
"0x200000" "4980736"
"0x6C0000" "524288"
"0x740000" "65536"
"0x750000" "65536"
"0x760000" "65536"

every instance of 6488064 has been changed to 4980736 in REFEX.BAT and SQUASHFS_MAKE.BAT files.

-------

in JP2IMG.BAT, every instance of 131072 has been changed to 65536

-------

Check www.GoPrawn.com action cam discussion forum for more details.

Link:

https://www.goprawn.com/forum/allwinner-cams/25-allwinner-v3-s-imx179-s-ov4689-and-gc2023-action-cameras?p=121#post121
