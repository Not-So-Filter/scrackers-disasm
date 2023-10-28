@echo off

IF EXIST scbuilt.bin move /Y scbuilt.bin scbuilt.prev.bin >NUL

set USEANSI=n
build_tools\asl -q -L -A -E -xx sonic.asm
build_tools\p2bin sonic.p scbuilt.bin -r 0x-0x

del sonic.p