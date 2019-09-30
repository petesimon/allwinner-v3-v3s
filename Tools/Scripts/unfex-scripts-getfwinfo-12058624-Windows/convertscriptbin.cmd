@echo off

where java.exe > NUL

IF %ERRORLEVEL% GTR 0 (echo Java executable not installed or not found. Please download Java from https://www.java.com ) ELSE (goto javaokay)
pause
exit /b

:javaokay

java -jar unscript.jar script.bin 2>NUL| more > script.fex

