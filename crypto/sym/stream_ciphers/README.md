## Documentation

- https://fr.wikipedia.org/wiki/Chiffrement_de_flux
- https://www.okta.com/identity-101/stream-cipher/
- https://www.geeksforgeeks.org/computer-networks/stream-ciphers/
- https://en.wikipedia.org/wiki/Related-key_attack


## Classical / Old Cryptography

### Substitution cipher

#### Monoalphabetic

- https://askubuntu.com/questions/1097761/changing-individual-letter-position-with-bash
- https://stackoverflow.com/questions/41535571/how-to-explain-the-str-maketrans-function-in-python-3-6
- https://stackoverflow.com/questions/3966820/bash-script-to-find-the-frequency-of-every-letter-in-a-file

```bash
# caesar
ROT-13(){
    tr 'n-za-mN-ZA-M' 'a-zA-Z'
}

# frequency analysis
< file sed 's/\(.\)/\1\n/g' | sort | uniq -c
```

```py
import string

alphabet = string.ascii_uppercase + string.ascii_lowercase + string.digits + "/="; encoded = ""; s = ""

s.translate(str.maketrans(alphabet, encoded)) # encoded
s.translate(str.maketrans(encoded, alphabet)) # decoded
```

#### Polybius Square

- https://en.wikipedia.org/wiki/Polybius_square
- https://rosettacode.org/wiki/ADFGVX_cipher
- https://en.wikipedia.org/wiki/ADFGVX_cipher

#### Transposition

- https://en.wikipedia.org/wiki/Transposition_cipher
- https://en.wikipedia.org/wiki/Rail_fence_cipher

#### Polyalphabetic

- https://en.wikipedia.org/wiki/Polyalphabetic_cipher
- https://vixepti.fr/crypto/2025/11/14/vigenere-cipher.html
- https://en.wikipedia.org/wiki/Kasiski_examination
- https://en.wikipedia.org/wiki/Index_of_coincidence
- https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher#Frequency_analysis 
- https://en.wikipedia.org/wiki/Enigma_machine

```python
# Kasiski examination

from sympy import divisors
from collections import Counter

repeated = "..."
possible_key_lengths = divisors(sum(c.isalnum() for c in repeated))

# Frequency analysis

cipher = "".join(filter(lambda c: c.isalpha() and c.isascii(), cipher))
for key_length in possible_key_lengths[1:-1]:
    possible_key = ""

    for i in range(key_length):
        stream = cipher[i::key_length]
        letter, count = Counter(stream).most_common(1)[0]
        possible_key += letter
    
    print("".join([chr(ord(e) - (ord('e')-ord('a'))) for e in possible_key]))
```


## One Time Pad

- https://github.com/derbenoo/otp_pwn
- https://en.wikipedia.org/wiki/One-time_pad
- https://learn-cyber.net/article/One-Time-Pad-the-Perfect-Cipher
- https://github.com/apoirrier/CTFs-writeups/blob/master/UTCTF2020/One%20True%20Problem.md


## Pseudo-Random Generators

- https://en.wikipedia.org/wiki/One-time_password
- https://defeo.lu/in420/Bit%20twiddling%20et%20LFSR
- https://www.0x0ff.info/2014/prng-et-generateur-de-cle/
- https://en.wikipedia.org/wiki/Cryptographically_secure_pseudorandom_number_generator
- https://www.schutzwerk.com/en/43/posts/attacking_a_random_number_generator/
- https://github.com/jvdsn/crypto-attacks/blob/master/attacks/mersenne_twister/state_recovery.py/

### RC4

- https://en.wikipedia.org/wiki/RC4
- https://en.wikipedia.org/wiki/Wired_Equivalent_Privacy
- https://github.com/jvdsn/crypto-attacks/blob/master/attacks/rc4/fms.py

### ZipCrypto

- https://en.wikipedia.org/wiki/Cyclic_redundancy_check
- [A Known Plaintext Attack on the PKZIP
Stream Cipher (Biham & Kocher) - springer.com](https://link.springer.com/content/pdf/10.1007/3-540-60590-8_12.pdf)
- https://www.acceis.fr/cracking-encrypted-archives-pkzip-zip-zipcrypto-winzip-zip-aes-7-zip-rar/
- https://security.stackexchange.com/questions/204475/crack-password-protected-zip-file-with-pkcrack
- https://github.com/kimci86/bkcrack

```bash
7z l -slt file.zip
#Encrypted = +
#Method = ZipCrypto

bkcrack -C file.zip -c inside_known.txt -p plain.txt
```

### Mersenne Twister

- https://en.wikipedia.org/wiki/Mersenne_Twister
- https://github.com/kmyk/mersenne-twister-predictor

#### C


- if **initialized**: see [break_rand.c](./break_rand.c): reinitializing with the same seed gives the same sequence of numbers
- otherwise set **seed=1**
- https://man7.org/linux/man-pages/man3/srand.3.html
- https://man7.org/linux/man-pages/man3/random.3.html

#### Python

- https://jia.je/ctf-writeups/misc/pyrand.html
- https://stackered.com/blog/python-random-prediction/
- https://github.com/tna0y/Python-random-module-cracker
- https://docs.python.org/3.14/library/random.html#module-random

#### Php

- https://www.openwall.com/php_mt_seed/
- https://blog.lexfo.fr/php-mt-rand-prediction.html
- https://www.php.net/manual/en/function.mt-rand.php


### LSFR

- https://www.youtube.com/watch?v=P90i0RrPcr8
- https://wftc.xyz/2020/01/crypto-rust/
- https://crypto.stackexchange.com/questions/66102/decrypting-ciphertext-with-partial-key-fragment-using-lfsr-and-berlekamp-massey?rq=1
- https://github.com/thewhiteninja/lfsr-berlekamp-massey
- https://github.com/oalieno/Crypto-Course/tree/master/LFSR

#### A5

- https://en.wikipedia.org/wiki/A5/1
- https://cryptome.org/0001/gsm-a5-files.htm
- [A Practical-Time Attack on the A5/3 Cryptosystem Used in Third Generation GSM Telephony - eprint.iacr.org](https://eprint.iacr.org/2010/013)

#### Chacha20-Poly1305

- https://en.wikipedia.org/wiki/Salsa20
- https://crypto.stackexchange.com/questions/83629/forgery-attack-on-poly1305-when-the-key-and-nonce-reused
