#!/bin/sh

function pause {
    read -n1 -rs
}

echo Converting binary "script.bin" hardware description data to readable text...

which java > /dev/null

if [ $? -ne 0 ]; then
    echo Java executable not installed or not found. Please download Java from https://www.java.com
else

java -jar unscript.jar script.bin 2>/dev/null > script.fex

echo done

fi

pause
