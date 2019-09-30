#!/bin/bash
#GETFWINFO.BAT script for getting firmware details in one click by nutsey for GoPrawn.com
#getfwinfo.sh shell script for Linux by petesimon
#this script calls other .sh shell scripts one-by-one to get FW info

clear
echo "GETFWINFO script for Linux for 12058624 bytes firmware files"

pause () {
	echo
	read -n1 -t 10 -p "press the Enter key to continue"
	echo
}

echo Auto FWINFO script by nutsey v0.4.
echo
echo  "[====--------------------] 10%%"
bash ./scriptbin_read.sh
pause

clear
echo Auto FWINFO script by nutsey v0.4.
echo.
echo  [========----------------] 20%%
bash ./convertscriptbin.sh

# ...
