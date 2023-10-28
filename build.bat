@echo off

IF EXIST scbuilt.bin move /Y scbuilt.bin scbuilt.prev.bin >NUL
asm68k /k /p /o ow+,ae-,l. sonic.asm, scbuilt.bin, , sonic.lst > log.txt