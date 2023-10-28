@echo off

echo Checking Built ROM with Original ROM...
IF EXIST scbuilt.bin ( fc /b scbuilt.bin sc.bin 
)else echo scbuilt.bin does not exist.

pause
