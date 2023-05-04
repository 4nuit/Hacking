#!/usr/bin/env python3
import string, shlex, sys, itertools, os, random
from subprocess  import Popen, PIPE
from time import sleep

#cmd = 'perf stat -r 25 -x, -e instructions:u %s ' % sys.argv[1]
cmd = 'perf stat -x, -e instructions:u ./simple_packer '
#key = ["0" for x in range(38)]
key = "HackUTT{"

for _i in range(40):
    maximum = 0,0
    for c in 'abcdefghijklmnopqrstuvwxyz1234567890{}_':
        k = key + c
        for __ in range(0x10):
            try:
                s = Popen(cmd, stdin=PIPE, stdout=PIPE, stderr=PIPE, shell=True)
                s.stdin.write(bytes(k, "utf-8"))
                _, stdout = s.communicate(timeout=2)
                nb_instructions = int(stdout.decode('utf-8').split(',')[0])
            except Exception as e:
                print(e, ">", k)
            try:
                if b'orrect' in _:
                    print(f'[+] {k}')
            except:
                pass

            if nb_instructions > maximum[0]:
                print(k, nb_instructions)
                maximum = nb_instructions, c
            sleep(.01)

    print(maximum)
    key += maximum[1]

    print("key:", key)

