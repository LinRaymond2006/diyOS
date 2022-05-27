@echo off
REM this file runs the system
REM use "run" command to run the emulator
REM qemu-system-i386 -drive format=raw,file=./build/HD.img
powershell sudo bochs -f ./.run/bochsrc.bxrc