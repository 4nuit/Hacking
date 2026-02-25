# Doc - Symmetric / Private key cryptography

## Tools

- [Cyberchef](https://gchq.github.io/CyberChef/)
- [Dcode](https://www.dcode.fr/)
- [Xortool](https://github.com/hellman/xortool)
- https://github.com/simple-crypto/SCALib
- https://github.com/SideChannelMarvels/Deadpool


## Block Ciphers

- [Wiki chiffrement symetrique](https://fr.wikipedia.org/wiki/Cryptographie_sym%C3%A9trique)
- [Wiki Chiffrement_par_bloc](https://fr.wikipedia.org/wiki/Chiffrement_par_bloc)
- https://en.wikipedia.org/wiki/Ciphertext_indistinguishability
- https://crypto.stackexchange.com/questions/26689/easy-explanation-of-ind-security-notions
- https://braincoke.fr/blog/2020/08/the-aes-encryption-algorithm-explained/#encryption-algorithm-overview
- https://stackoverflow.com/questions/1220751/how-to-choose-an-aes-encryption-mode-cbc-ecb-ctr-ocb-cfb

### Single Sign On (SSO)

- https://en.wikipedia.org/wiki/Single_sign-on
- https://en.wikipedia.org/wiki/Ticket_Granting_Ticket

### Key Derivation Functions

- https://en.wikipedia.org/wiki/PBKDF2
- https://en.wikipedia.org/wiki/Key_derivation_function

### Key Schedule (ex Rounds)

- https://en.wikipedia.org/wiki/Key_schedule
- https://en.wikipedia.org/wiki/RC4
- https://en.wikipedia.org/wiki/AES_key_schedule

### Padding Oracle - Block Cipher modes: ECB, CBC, IGE

- [Wiki - Block cipher modes of operation](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation)
- [Wiki - Padding Oracle](https://en.wikipedia.org/wiki/Padding_oracle_attack)
- https://www.di-mgt.com.au/cryptopad.html
- https://dylanpindur.com/blog/padding-oracles-an-animated-primer/
- https://en.wikipedia.org/wiki/Padding_(cryptography)#PKCS#5_and_PKCS#7
- https://book-of-gehn.github.io/articles/2018/07/01/Cut-and-Paste-ECB-Blocks.html
- https://crypto.stackexchange.com/questions/71365/why-does-a-padding-block-exist-for-ecb-and-cbc-modes

```python
from Crypto.Util.Padding import pad

def pkcs7(msg: bytes, blocksize):
	pad = blocksize - (len(msg) % blocksize)
	return msg + bytes([pad])*pad

assert(pkcs7(b"True",16) == pad(b"True",16))
```

#### ECB Oracle

- https://crypto.stackexchange.com/questions/42891/chosen-plaintext-attack-on-aes-in-ecb-mode
- https://security.stackexchange.com/questions/271007/aes-ecb-cookie-bypass

```python
#ECB

BLOCK = 16

def blocks(ct: bytes):
	return [ct[i:i+BLOCK] for i in range(0, len(ct), BLOCK)]

def oracle(input):
	bloc = input.encode().hex(); print(bloc)
	r = requests.get(url + bloc).json()
 	return r["ciphertext"]
```

```py
while not recovered.endswith(b"}"):
	pad_len = 15 - (len(recovered) % 16)
	align = b"A"*pad_len
	ctx15 = (align + recovered)[-15:]   # last 15 bytes before the unknown

	found = False
	for g in range(256):
		probe = ctx15 + bytes([g])      # 16 bytes

		payload = probe + align
		ct = blocks(oracle(payload))

		target_idx = probe_idx + 1 + (len(recovered) // 16)
		if ct[probe_idx] == ct[target_idx]:
			recovered += bytes([g])
			print(recovered)
			found = True
			break
```

#### CBC Bit Flipping 

- https://crypto.stackexchange.com/questions/66085/bit-flipping-attack-on-cbc-mode

```python
#CBC - Bit Flipping
def blocks(input):
	return [input[i:i+16] for i in range(0, len(input), 16)]

def stringxor(a, b):
	return bytes(x ^ y for x, y in zip(a, b))

def flip(bloc,true,false):
	mask = stringxor(true.encode(), false.encode()); print("Mask: ",mask)
	assert(stringxor(true.encode(), mask) == false.encode())
	mask += bytes([0] * (16 - len(mask)))
	bloc_faked = stringxor(bloc, mask) #fake previous bloc -> CBC(Bi + Pi)  = Bi+1 
	return bloc_faked
	
ct2 = flip(blocks(ct)[n-1], pad(b"True", 16).decode(), pad(b"False", 16).decode())
```

#### CBC Padding Oracle

- https://github.com/mpgn/Padding-oracle-attack
- https://www.cs.unm.edu/~crandall/secprivspring17/cbcpaddingoracle.pdf
- https://www.nccgroup.com/research-blog/cryptopals-exploiting-cbc-padding-oracles/
- https://blog.cloudflare.com/padding-oracles-and-the-decline-of-cbc-mode-ciphersuites/

```py
def recover_block(io, prev_block, block):
	recovered = bytearray(BLOCK)
	intermediate = bytearray(BLOCK)

	for pad in range(1, BLOCK+1):
		for guess in range(256):
			crafted = bytearray(BLOCK)

			for i in range(1, pad):
				crafted[-i] = intermediate[-i] ^ pad

			crafted[-pad] = guess

			ct = bytes(crafted) + block

			if oracle(io, ct):
				intermediate[-pad] = guess ^ pad
				recovered[-pad] = intermediate[-pad] ^ prev_block[-pad]
				print(f"Recovered byte: {recovered[-pad]:02x}")
				break

	return bytes(recovered)

recovered = b""

for i in range(1, len(blocks)):
	print(f"Recovering block {i}...")
	p = recover_block(io, blocks[i-1], blocks[i])
	recovered += p
```

#### IGE Padding Oracle

- https://mgp25.com/blog/2015/06/21/AESIGE/
- https://github.com/jvdsn/crypto-attacks/blob/master/attacks/ige/padding_oracle.py

### Block Cipher modes: CCM, OCB, GCM

#### GCM forbidden attack

- https://frereit.de/aes_gcm/
- https://github.com/oalieno/Crypto-Course/tree/master/Block-Cipher-Mode/Forbidden
- https://www.reversemode.com/2023/10/reversing-france-identite-new-french.html?m=1

### DES

- https://crack.sh/des_kpt/

#### Meet In the Middle

- https://www.geeksforgeeks.org/meet-in-the-middle/
- https://lo.calho.st/posts/double-des-meet-in-the-middle/
- https://cdn.comparitech.com/wp-content/uploads/2024/07/meetinthemiddle.pdf

### Hill Cipher

- https://blog.nikost.dev/posts/root-me-ctf20k-crypto/#silent-hint
- https://github.com/t3rmin0x/CTF-Writeups/tree/master/DarkCTF/Crypto/Embrace%20the%20Climb#embrace-the-climb-


### Block Cipher modes: CTR

#### CTR (acting like a stream cipher mode)

- [English ascii frequence table](http://www.fitaly.com/board/domper3/posts/136.html)
- https://github.com/SpiderLabs/cribdrag
- https://github.com/ThomasHabets/xor-analyze
- https://github.com/JorianWoltjer/Cryptopals/blob/master/set3/19.py
- https://crypto.stackexchange.com/questions/2249/how-does-one-attack-a-two-time-pad-i-e-one-time-pad-with-key-reuse/2250#2250


## Linear and Differential Cryptanalysis

### FEAL

- https://vozec.fr/other/feal-cipher/

### AES

- https://vozec.fr/aes/analyse-lineaire-aes/
- https://github.com/Vozec/AES-Square-Attack
- https://github.com/Vozec/AES-DFA
- https://www.researchgate.net/publication/2646816_The_block_cipher_Square
- https://blog.quarkslab.com/differential-fault-analysis-on-white-box-aes-implementations.html

### Side channel - CPA & DPA

- https://coastalwhite.github.io/intro-power-analysis/aes.html
- https://crypto.stackexchange.com/questions/42571/why-are-side-channel-attacks-such-as-spa-dpa-cpa-based-on-the-aes-subbytes-rout

#### Correlation Power Analysis

- https://scalib.readthedocs.io/
- [Correlation Power Analysis with a Leakage Model](https://link.springer.com/content/pdf/10.1007/978-3-540-28632-5_2.pdf)
- https://coastalwhite.github.io/intro-power-analysis/aes/automate.html

#### Differential Power Analysis

- https://github.com/nvietsang/dpa-on-aes
- https://github.com/ibamba/Side-Channel-DPA-and-CPA-attacks-on-AES/


## Stream ciphers

- https://fr.wikipedia.org/wiki/Chiffrement_de_flux
- https://crypto.stackexchange.com/questions/83629/forgery-attack-on-poly1305-when-the-key-and-nonce-reused

### Substitution cipher

- https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher
- https://en.wikipedia.org/wiki/Playfair_cipher
- https://askubuntu.com/questions/1097761/changing-individual-letter-position-with-bash

### OTP 

- https://github.com/derbenoo/otp_pwn
- https://learn-cyber.net/article/One-Time-Pad-the-Perfect-Cipher
- https://github.com/apoirrier/CTFs-writeups/blob/master/UTCTF2020/One%20True%20Problem.md

### ZIP

- https://security.stackexchange.com/questions/204475/crack-password-protected-zip-file-with-pkcrack

```bash
7z l -slt file.zip
#Encrypted = +
#Method = ZipCrypto

bkcrack -C file.zip -c inside_known.txt -p plain.txt
```

### RC4

- https://en.wikipedia.org/wiki/RC4
- https://thehackernews.com/2015/07/crack-rc4-encryption.html
- https://github.com/jvdsn/crypto-attacks/blob/master/attacks/rc4/fms.py

### PRNG

- https://www.0x0ff.info/2014/prng-et-generateur-de-cle/
- https://www.schutzwerk.com/en/43/posts/attacking_a_random_number_generator/
- https://github.com/jvdsn/crypto-attacks/blob/master/attacks/mersenne_twister/state_recovery.py/

#### C

```c
rand()
```

- si **initialisée**: -> voir [break_rand.c](./break_rand.c): réinitialiser avec la même seed donne la même suite de nombres
- sinon: **seed=1**

#### Python

- https://github.com/kmyk/mersenne-twister-predictor
- https://github.com/tna0y/Python-random-module-cracker

#### Php

- https://www.openwall.com/php_mt_seed/
- https://blog.lexfo.fr/php-mt-rand-prediction.html

### LSFR

- https://www.youtube.com/watch?v=P90i0RrPcr8
- https://wftc.xyz/2020/01/crypto-rust/
- https://crypto.stackexchange.com/questions/66102/decrypting-ciphertext-with-partial-key-fragment-using-lfsr-and-berlekamp-massey?rq=1
- https://github.com/thewhiteninja/lfsr-berlekamp-massey
- https://github.com/oalieno/Crypto-Course/tree/master/LFSR
