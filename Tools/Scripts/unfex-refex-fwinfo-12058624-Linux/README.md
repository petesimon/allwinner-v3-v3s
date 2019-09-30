GETFWINFO v0.4 script. UNFEX-REFEX scripts pack.
Written as a .sh (bash shell) scripts and modified
to work in Linux.

I need help porting the Windows .bat/.cmd files to bash
.sh scripts. Contact me here in Github, or via email
petesimon (@) yahoo.com or in Facebook http://fb.com/psvangorp .
Also, I am user 'petesimon' in Goprawn forums.

These scripts for Allwinner V3(s) full_img.fex, 12058624 bytes size.
Java runtime is needed for the convertscriptbin script.
Package 'squashfs-tools' is needed for squashfs_make and squashfs_unmake scripts.
Choose another Java JRE package if 'openjdk-11-jre' isn't available.
Install those packages using this command in a Terminal window:

      sudo apt-get install openjdk-11-jre squashfs-tools -y

Instructions:

Open a Terminal application window. Change to the this scripts folder.

Put a FULL_IMG.FEX file from your firmware backup into the same folder. 

Run 'bash ./unfex.sh' to create separate 0/1/2/3/4/5/6 partition img files.

Run 'bash ./squashfs_unmake.sh' to extract data from 2-system.img partition file.

Run 'bash ./scriptbin_read.sh' to create script.bin hardware description file.

Run 'bash ./convertscriptbin.sh' to get script.fex readable text.

Run 'bash ./fwinfo.sh' to get firmware info. Look in a FWINFO folder. Open 'fwinfo.txt' file.

Run 'bash ./refex.sh' to create a FULL_IMG.FEX file from 0/1/2/3/4/5/6 img files.
-- POSSIBLY BROKEN -- please give feedback in the 'Issues' page.

Run 'bash ./squashfs_make.sh' to create a 2-system.img file from data in 'squashfs-root' folder. -- BROKEN. -- it will be fixed in a later update. --

* ... WORK IN PROGRESS ... *
Run 'bash ./getfwinfo.sh' get details about your Allwinner V3/V3s firmware. 

FWINFO.TXT file, boot and shutdown logo JPG files will be copied to FWINFO folder.

Look inside the new 'FWINFO' folder.

Check GoPrawn.com action cam discussion forum for more details.

Thanks for sharing!

