Allwinner V3 firmware treatment scripts pack v170411, updated 20170424.
These scripts are for full_img.fex 12058624 bytes size.

UNFEX/REFEX scripts instructions:  ================================================================

Unpacking of full_img.fex:
   1. Copy full_img.fex file into folder containing UNFEX.BAT file.
   2. Run UNFEX.BAT script.
   3. Partition files will be extracted to /UNFEX folder. 

Packing partition files into full_img.fex:
   1. Run REFEX.BAT file to pack partition files from /UNFEX folder.
   2. Partition files will be packed into full_img.fex file. Any existing full_img.fex file will be renamed to full_img.fex.bak

To pack any other partition files into full_img.fex put them into /UNFEX folder before running the
script. You must have proper undamaged files suitable for you camera in /UNFEX folder in order to
run this script and to pack working FEX file.


GETFWINFO script instructions:  ===================================================================

Put FULL_IMG.FEX into the main script folder. Run GETFWINFO.BAT to get details about your Allwinner 
V3 firmware. FWINFO.TXT file as well as boot and shutdown logo JPG files will be copied to FWINFO 
folder.


FWINFO script instructions:  ======================================================================

Same as the script above, but allows running step-by-step in manual mode.

Make sure you've done the following before running the script:
1. Put FULL_IMG.FEX into the main script folder.
2. Run SCRIPTBIN_READ.BAT to read SCRIPT.BIN file from FEX. 
3. Run UNFEX.BAT to unpack FEX file to UNFEX folder.
3. Run SQUASHFS_UNMAKE.BAT to unpack 2-SYSTEM.BIN.
4. Run CONVERTSCRIPTBIN.BAT to get SCRIPT.FEX file.
5. Run FWINFO.BAT.


JPG2IMG script instructions:  =====================================================================

Before running the script, put desired blogo.jpg (boot logo) and slogo.jpg (shutdown logo) files to
UNFEX folder.
After running the script, JPG files will be converted to 4-blogo.img and 5-slogo.img files so you
can integrate into full_img.fex by running REFEX script. Original IMG files will be renamed to BAK.

Note: Each JPEG file size should not exceed 131072 bytes and picture resolution must be 320x240 or
220x176 pixels (you can find out your camera LCD resolution by running GETFWINFO script).


SCRIPTBIN scripts instructions:  ==================================================================

Get hardware configuration file of the camera:
   1. Copy full_img.fex file into folder containing SCRIPTBIN_READ.BAT file.
   2. Run SCRIPTBIN_READ.BAT script.
   3. script.bin file will be extracted to current folder.
   Alternatively, the file can be extracted from UNFEX/0-uboot.img. In the presence of both files,
   the user is prompted so the user can choose the source of the script.bin file.

Set hardware configuration file of the camera:
   1. Copy full_img.fex and script.bin files into folder containing SCRIPTBIN_WRITE.BAT file.
   2. Run SCRIPTBIN_WRITE.BAT script.
   3. A new full_img.fex file will be created into current folder.
   Alternatively, the file can be writed to UNFEX/0-uboot.img. In the presence of both files, the
   user is prompted so the user can choose the destination of the script.bin file.

script.bin file contains hardware configuration and memory timings that are passed by uboot to the
kernel.


SQUASHFS scripts instructions:  ===================================================================

Run SQUASHFS_UNMAKE.BAT to 2-system.img file located in UNFEX folder. Unpacked file can be fount in
'squashfs-root' folder. 
Run SQUASHFS_MAKE.BAT to compile files from 'squashfs-root' folder into 2-system.img file.


REPACK/UNPACK_BOOTIMG scripts instructions:  ======================================================

Unpacking of 1-boot.img:
   1. Make sure 1-boot.img file is located in UNFEX folder.
   2. Run UNPACK_BOOTIMG script.
   3. Files will be extracted to /BOOT-ROOT folder.

Packing files into 1-boot.img:
   1. Run REPACK_BOOTIMG.BAT file to pack files from /BOOT-ROOT folder.
   2. Files will be packed into 1-boot.img file. Any existing 1-boot.img file will be renamed to 
      1-boot.img.bak


ConvertScriptBin tool script instructions:  =======================================================

1. get script.bin data from camera
2. put script.bin file and convertscriptbin.bat and unscript.jar together in the same folder
3. run convertscriptbin.bat
4. read contents of text file "script.fex"

Note: Java runtime environment from https://www.java.com must be installed


===================================================================================================

Firmware structure:
   000000 - 03FFFF  u-boot (script.bin starts from 032000)
   040000 - 2FFFFF  boot (kernel)
   300000 - 92FFFF  system (mounted as read-only squashfs; contains lib, res, ...)
   930000 - B2FFFF  config (/data)
   B30000 - B4FFFF  boot logo (jpeg)
   B50000 - B6FFFF  shutdown logo (jpeg)
   B70000 - B7FFFF  env (u-boot params) 


===================================================================================================

Check GoPrawn.com action cam discussion forum for more details.
