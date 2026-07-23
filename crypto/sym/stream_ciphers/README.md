## Documentation

- https://fr.wikipedia.org/wiki/Chiffrement_de_flux
- https://www.okta.com/identity-101/stream-cipher/
- https://www.geeksforgeeks.org/computer-networks/stream-ciphers/

### Substitution cipher

#### Monoalphabetic

- https://askubuntu.com/questions/1097761/changing-individual-letter-position-with-bash
- https://stackoverflow.com/questions/41535571/how-to-explain-the-str-maketrans-function-in-python-3-6
- https://stackoverflow.com/questions/3966820/bash-script-to-find-the-frequency-of-every-letter-in-a-file

```bash
# letters frequency
sed 's/\(.\)/\1\n/g' file | sort | uniq -c

# caesar
ROT-13 = tr 'n-za-mN-ZA-M' 'a-zA-Z'
```

```py
import string

alphabet = string.ascii_uppercase + string.ascii_lowercase + string.digits + "/="; encoded = ""; s = ""

# encode
s.translate(str.maketrans(alphabet, encoded))

# decode
s.translate(str.maketrans(encoded, alphabet))
```


#### Polyalphabetic

- https://en.wikipedia.org/wiki/Polyalphabetic_cipher
- https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher
- https://en.wikipedia.org/wiki/Playfair_cipher


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

- if **initialized**: -> see [break_rand.c](./break_rand.c): reinitializing with the same seed gives the same sequence of numbers
- otherwise: **seed=1**

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

### Poly1305 / Chacha20

- https://en.wikipedia.org/wiki/Salsa20
- https://crypto.stackexchange.com/questions/83629/forgery-attack-on-poly1305-when-the-key-and-nonce-reused
