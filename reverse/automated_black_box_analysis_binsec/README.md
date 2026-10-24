# Reverse engineering a simple 

We provide the simple crackme: `chall` (the source code is provided in `chall.c`).
We aim to see how Xyntia and Binsec can be used to help reverse engineering. 

A docker image with [Binsec](https://hub.docker.com/r/binsec/binsec) and [Xyntia](https://binsec.github.io/releases/xyntia/2025/05/05/xyntia-0.2.0) installed is provided. 
```
$ docker load -i hackademint.tar.gz
$ docker run -it hackademint
```

## Xyntia

Xyntia aims to simplify complex expressions. For instance, the `encode` and `op` 
functions include expressions obfuscated with MBA encoding using [Tigress](https://tigress.wtf/).
We aim to understand how the encoding is performed and if it is easily inversible ? 

### I. Deobfuscation of the op function

We start with the `op` function. It includes a MBA expression we want to simplify. 
To do so, you can run Xyntia as follows: 
```
$ cat op.ini # you must fill the <<TODO>> with the good addresses and output
starting from <<TODO>>  # start address

explore all

hook <<TODO>> with  # end address
    sample 100 <<TODO>> # register to synthesize
    halt
end

$ xyntia -time 1 -bin chall -config op.ini 
```

Is it working ? Yes but it is still a bit hard to read. This is because Binsec did not 
detect the good inputs for the expression. The real inputs are dil and sil 
(i.e., the least significant bytes of the rdi and rsi registers). 

To get a clean output you can use:
```
$ cat op.ini
starting from <<TODO>> # start address

dil<8> := nondet as x
sil<8> := nondet as y

explore all

hook <<TODO>> with # end address 
    sample 100 <<TODO>> # output to synthesize
    halt
end

$ xyntia -time 1 -bin chall -config op.ini 
```

### II. Deobfuscation of the encode function
Do it yourself ;-)


## Binsec

We know that the encoding is easily inversible. 
We can now try to run Binsec and retrieve the flag automatically.

First things first, the binary is not complete, it is a dynamically linked one.
```console
$ file chall
chall: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=ae5b19b084a83af9ae7acfcf0847f1e2b37a1db2, for GNU/Linux 3.2.0, not stripped
```

Thus, we will generate a snapshot of its memory process after its dependencies are loaded.
To do so, we will use the script `make_coredump.sh` that comes with Binsec.
```console
$ make_coredump.sh core.snapshot ./chall > /dev/null
```
The script use GDB to run the program up to the begining of the function `main` and make
a copy of the register and memory state to the file `core.snapshot`.

We then need to write an SE script to instruct Binsec what to do.
The syntax will sound familiar to you, indeed Xyntia sampling is built on top of the Binsec SE.  
```console
$ cat crackme.ini
starting from core

replace <fgets> (ptr, size, _) by
  for i<64> in 0 to size - 1 do
    @[ptr + i] := stdin[i]
  end
  return
end

stdout_pos<64> := 0
replace <puts> (str) by
  while @[str] <> 0 do
    stdout[stdout_pos] := @[str]
    str := str + 1
    stdout_pos := stdout_pos + 1
  end
  return
end

reach <puts> (str) such that @[str, 10] <> "You failed"
                   then print c string stdin

cut at <puts>
```

Here, we stub `fgets` and `puts` to handle IO operations.
The first one fill the buffer with the content of the symbolic
array `stdin[]`, the second copy the content of the string
to the symbolic array `stdout[]`.

Then, we ask Binsec to find a way to reach the victory condition,
i.e. when `puts` is called with another thing than `You failed`.
We then print the content of `stdin` as an ascii string.

We can now run Binsec with the following command.
```console
$ binsec -sse -sse-script crackme.ini -sse-depth 100000 core.snapshot
[sse:result] Path 1 reached address 0x7ffff7c80e50 (<puts>) (0 to go)
[sse:result] C string stdin : "hum...YouF0undMe!Next-step=BetterObfuscation;-)"
```
Here we are, we solved this simple challenge.

Would you be able to solve the FCSC 2019 [`vault`](https://hackropole.fr/fr/challenges/reverse/fcsc2019-reverse-vault/) challenge?
