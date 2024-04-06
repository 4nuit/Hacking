## Doc Maths

- https://cpge-paradise.com/sites.php
- https://learn-cyber.net/article/Modular-Arithmetic
- https://αβγ.ελ/math-notes.pdf

## Doc Crypto

- https://gotchas.salusa.dev/
- https://medium.com/dataseries/a-crash-course-in-everything-cryptographic-50daa0fda482
- https://cryptobook.nakov.com/
- https://www.youtube.com/@meichlseder
- https://www.nassiben.com/video-based-crypta

## Challenges

- https://www.mathraining.be/ #à faire
- https://cryptopals.com # à faire
- https://cryptohack.org

## Outils

- [Xortool](https://github.com/hellman/xortool)
- [Hashes.com](https://hashes.com)
- [Dcode](https://www.dcode.fr/)
- [Cyberchef](https://gchq.github.io/CyberChef/) : Divers encodages/hashs et autres
- [Alpertron](https://www.alpertron.com.ar/ECM.HTM) : RSA (en + de `factordb` et `simpy`)

```bash
pip install xortool
```

- [cupp (interactive wordlist)](https://github.com/Mebus/cupp)
- [z3](https://theory.stanford.edu/~nikolaj/programmingz3.html)
- [OpenSSL cheatsheet](https://www.freecodecamp.org/news/openssl-command-cheatsheet-b441be1e8c4a/)

```bash
openssl asn1parse -in pub.pem
openssl <rsa|ec> -in pub.pem -text -noout
openssl aes-256-cbc -d -iter 10 -pass pass:$(cat pass.txt) -in file.enc -out file.dec
```

- https://github.com/tna0y/Python-random-module-cracker
- [PyJWT](https://pyjwt.readthedocs.io/en/latest/)
- [JWS](https://www.npmjs.com/package/jws)


- [Gmpy2](https://gmpy2.readthedocs.io/en/latest/overview.html)
- [Pycryptodome](https://pycryptodome.readthedocs.io/en/latest/src/api.html), [RSA - Crypto](https://gist.github.com/YannBouyeron/f39893644f89dd676297cc3bc67eaedb)
- [Sage (ECC)](https://doc.sagemath.org/html/en/reference/arithmetic_curves/sage/schemes/elliptic_curves/constructor.html)
- [Sympy (docs)](https://docs.sympy.org/latest/modules/polys/reference.html)


## Hashs

- https://security.stackexchange.com/questions/211/how-to-securely-hash-passwords
- https://stackoverflow.com/questions/401656/secure-hash-and-salt-for-php-passwords
- https://github.com/someshkar/colabcat

## Cle publique

- https://fr.wikipedia.org/wiki/Cryptographie_asym%C3%A9trique

- [RSA](https://crypto.stanford.edu/~dabo/pubs/papers/RSA-survey.pdf), https://haltode.fr/algo/chiffrement/rsa.html
https://vozec.fr/crypto-rsa/ , [Side Channel RSA - RSA CRT cf FCSC](https://www.cosade.org/cosade19/cosade14/presentations/session2_b.pdf), https://0x90p0wned.wordpress.com/author/0x90p0wned/

- [DSA,ElGamal, RSA-CRT - Zenk](https://repo.zenk-security.com/Cryptographie%20.%20Algorithmes%20.%20Steganographie/Cle%20Publique.pdf)

- [ROCA](https://ctftime.org/writeup/8805)

- [Shamir Secret Sharing](https://max.levch.in/post/724289457144070144/shamir-secret-sharing)

### Tips RSA

- [Crypto.PublicKey: import_key](https://pycryptodome.readthedocs.io/en/latest/src/public_key/public_key.html)

```py
import primefac
primefac.pollard_pm1(n)
```

```py
import sympy
list(factorint(n))
```

#### ROCA

- https://ctftime.org/writeup/8805

### GPG

```bash
gpg --gen-keys
gpg --list-leys
gpg --export -a "mail.com" > public.key
gpg -d file.pgp
```

### JWT

- https://superuser.com/questions/1419155/generating-jwt-rs256-signature-with-openssl
- https://github.com/ticarpi/jwt_tool/wiki

## Cle secrete - Blocs (padding modes)

- https://fr.wikipedia.org/wiki/Cryptographie_sym%C3%A9trique

- https://fr.wikipedia.org/wiki/Chiffrement_par_bloc

- [AES](https://braincoke.fr/blog/2020/08/the-aes-encryption-algorithm-explained/#encryption-algorithm-overview), https>

- https://stackoverflow.com/questions/1220751/how-to-choose-an-aes-encryption-mode-cbc-ecb-ctr-ocb-cfb
- [Block cipher modes of operation](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation)

- [Padding Oracle](https://en.wikipedia.org/wiki/Padding_oracle_attack)

**Padding modes**

### ECB

#### Oracle classique

- https://crypto.stackexchange.com/questions/42891/chosen-plaintext-attack-on-aes-in-ecb-mode
- https://security.stackexchange.com/questions/271007/aes-ecb-cookie-bypass

```python
#ECB Padding
def oracle(input):
	bloc = input.encode().hex(); print(bloc)
	r = requests.get(url+bloc).json()
 	r2 = split_string(r["ciphertext"]); print(r2);return r2

known = ""
while "}" not in known:
	target = oracle("A"*(63-len(known)))[3]
	for s in string.printable:
		brute = oracle( ("A"*(63-len(known))+known+s))
		if brute[3] == target: ##AAAAAAAAAcrypto|{ == AAAAAAAAAcrypto{ p3n6u1 ?
			known +=s; print("[+]Flag = ",known)
			break
```

#### Padding Oracle ECB

- https://crypto.stackexchange.com/questions/71365/why-does-a-padding-block-exist-for-ecb-and-cbc-modes
- https://www.di-mgt.com.au/cryptopad.html
- https://book-of-gehn.github.io/articles/2018/07/01/Cut-and-Paste-ECB-Blocks.html

### CBC

#### Bit Flipping 

- https://crypto.stackexchange.com/questions/66085/bit-flipping-attack-on-cbc-mode

```python
#CBC - Bit Flipping
def split_string(input):
	return [input[i:i+16] for i in range(0, len(input), 16)]

def stringxor(a, b):
	return bytes(x ^ y for x, y in zip(a, b))

def flip(bloc,true,false):
	mask = stringxor(true.encode(), false.encode()); print("Mask: ",mask)
	assert(stringxor(true.encode(), mask) == false.encode())
	mask += bytes([0] * (16 - len(mask)))
	bloc_faked = stringxor(bloc, mask) #fake previous bloc -> CBC(Bi + Pi)  = Bi+1 
	return bloc_faked
```

#### Padding Oracle

- https://www.cs.unm.edu/~crandall/secprivspring17/cbcpaddingoracle.pdf
- https://research.nccgroup.com/2021/02/17/cryptopals-exploiting-cbc-padding-oracles/
- https://blog.cloudflare.com/padding-oracles-and-the-decline-of-cbc-mode-ciphersuites/
- https://pypi.org/project/padding-oracle/

**Stream Cipher Modes**

## Cle secrete - Flux (Stream cipher modes)

- https://fr.wikipedia.org/wiki/Chiffrement_de_flux

- https://fr.wikipedia.org/wiki/RC4

- https://thehackernews.com/2015/07/crack-rc4-encryption.html

- https://crypto.stackexchange.com/questions/83629/forgery-attack-on-poly1305-when-the-key-and-nonce-reused

### AES - CTR, OFB, CFB

## Cle secret - Authentication modes

### CCM, OCB, GCM

### PRNG

- https://www.0x0ff.info/2014/prng-et-generateur-de-cle/

```c
rand()
```

- si **initialisée**: -> voir `break_rand.c`: réinitialiser avec la même seed donne la même suite de nombres

- sinon: **seed=1**

### LSFR

- https://www.youtube.com/watch?v=P90i0RrPcr8

### OTP 

- https://learn-cyber.net/article/One-Time-Pad-the-Perfect-Cipher
- https://github.com/derbenoo/otp_pwn

### Hash length extension

- https://crypto.stackexchange.com/questions/3978/understanding-the-length-extension-attack
- https://tipi-hack.github.io/2018/04/01/quals-NDH-18-Wawacoin.html
- https://github.com/stephenbradshaw/hlextend

### Lattices et ECC

- https://vozec.fr/crypto-lattice/lattice-introduction/
- [Elliptic Curves](https://people.cs.nctu.edu.tw/~rjchen/ECC2012S/Elliptic%20Curves%20Number%20Theory%20And%20Cryptography%202n.pdf)

- https://eprint.iacr.org/2023/032.pdf
- https://latticehacks.cr.yp.to/slides-dan+nadia+tanja-20171228-latticehacks-16x9.pdf

## Cheatsheet

- https://github.com/zademn/EverythingCrypto
- https://github.com/jvdsn/crypto-attacks


## Cours: Cryptohack Starters

![](./warn.png)

Voir:

- `./elliptic_curves`

