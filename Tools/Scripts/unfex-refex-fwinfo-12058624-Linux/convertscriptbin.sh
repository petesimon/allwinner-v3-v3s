#!/bin/bash
#convertscriptbin.sh script for Linux by petesimon of GoPrawn.com forums
#based on convertscriptbin.bat
#for converting script.bin hardware info, binary data, to script.fex text
#we can later open script.fex file and read it
#Java JRE needs to be installed such as 'openjdk-11-jre'

clear

pause () {
	echo
	read -t 20 -n1 -p "press the Enter key to continue"
	echo
}

echo
echo "Converting binary file 'script.bin' hardware description data to readable text file 'script.fex'"
echo

if [ -z "$(which java)" ]; then
    echo "No java found. Install a Java JRE package first"
    echo exiting ...
    pause
    exit 1
fi

if [ ! -f unscript.jar ]; then
    echo "unscript.jar file not found."
    echo exiting ...
    pause
    exit 1
fi

if [ -f script.fex ]; then
    echo "script.fex file found. renaming it to script.fex.old"
    mv -T --backup=numbered script.fex script.fex.old
fi

if [ ! -f script.bin ]; then
    echo "script.bin file not found. Run 'bash scriptbin_read.sh' first"
    echo exiting ...
    pause
    exit 1
  else
    java -jar unscript.jar script.bin 2>NUL | more > script.fex
    awk 'sub("$", "\r")' script.fex > script.txt
    echo "Done. Look for a new 'script.fex' file and open it in a text editor."
    echo "Also, a 'script.txt' file was made as a DOS/Windows compatible text file."
fi

exit 0
