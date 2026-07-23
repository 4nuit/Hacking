#!/bin/sh

if [ $# == 1 ]
then
        gcc -m32 -fno-stack-protector -o makeshellcode $1 makeshellcode.c
        ./makeshellcode
        ./makeshellcode > shellcode.h
        gcc -m32 -fno-stack-protector -o testshellcode testshellcode.c
        ./testshellcode
else
        echo Utilisation : ./doall \<programme.s\>
fi
