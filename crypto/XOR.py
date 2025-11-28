from itertools import cycle

cipher = ...
key = "FLAG{"

cipher = bytes.fromhex(cipher)
cipher = [b for b in cipher]
key = [ord(c) for c in key]

plain_key = [ t[0]^t[1] for t in zip(cipher,key)]
key = [chr(x) for x in plain_key]

for i in range(len(key),len(cipher)):
        plain_key.append(plain_key[i%len(key)])

plain = [t[0]^t[1] for t in zip(cipher,plain_key)]
plain = [chr(x) for x in plain]
print(''.join(plain))
