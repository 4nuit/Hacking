## Doc Crypto

- https://cryptohack.gitbook.io/cryptobook/
- https://gotchas.salusa.dev/
- https://cryptobook.nakov.com/
- https://affine.group/writeups
- https://github.com/ashutosh1206/Crypton
- https://github.com/jvdsn/crypto-attacks

## Challenges

- https://www.mathraining.be/ #todo
- https://cryptopals.com #todo
- https://cryptohack.org

## Outils

- [Cryptsetup](https://wiki.archlinux.org/title/Dm-crypt/Device_encryption)
- [Xortool](https://github.com/hellman/xortool)
- [Hashes.com](https://hashes.com)
- [Dcode](https://www.dcode.fr/)
- [Cyberchef](https://gchq.github.io/CyberChef/) : Divers encodages/hashs et autres
- [Alpertron](https://www.alpertron.com.ar/ECM.HTM) : RSA (en + de `factordb` et `simpy`)
- [Pkcrack](https://github.com/keyunluo/pkcrack)

```bash
pip install xortool
```

- [cupp (interactive wordlist)](https://github.com/Mebus/cupp)
- [z3](https://theory.stanford.edu/~nikolaj/programmingz3.html)
- [OpenSSL cheatsheet](https://www.freecodecamp.org/news/openssl-command-cheatsheet-b441be1e8c4a/)

```bash
# RSA
openssl asn1parse -in pub.pem
openssl <rsa|ec> -in pub.pem -text -noout
openssl x509 -inform DER -in cert.der -text
openssl x509 -inform DER -in cert.der -pubkey -noout
```

```bash
# AES
openssl aes-256-cbc -d -iter 10 -pass pass:$(cat pass.txt) -in file.enc -out file.dec
openssl enc -d -aes-256-cbc -in file.enc -out file.dec -K "key" -iv "iv" 
```

- https://github.com/tna0y/Python-random-module-cracker
- [PyJWT](https://pyjwt.readthedocs.io/en/latest/)
- [JWS](https://www.npmjs.com/package/jws)
- [Gmpy2](https://gmpy2.readthedocs.io/en/latest/overview.html)
- [Pycryptodome](https://pycryptodome.readthedocs.io/en/latest/src/api.html), [RSA - Crypto](https://gist.github.com/YannBouyeron/f39893644f89dd676297cc3bc67eaedb)
- [Sage (ECC)](https://doc.sagemath.org/html/en/reference/arithmetic_curves/sage/schemes/elliptic_curves/constructor.html)
- [Sympy (docs)](https://docs.sympy.org/latest/modules/polys/reference.html)

## Cheatsheet

- https://github.com/zademn/EverythingCrypto
- https://github.com/jvdsn/crypto-attacks

## Hashs

- https://security.stackexchange.com/questions/211/how-to-securely-hash-passwords
- https://stackoverflow.com/questions/401656/secure-hash-and-salt-for-php-passwords
- https://cyber.gouv.fr/sites/default/files/2021/03/anssi-guide-selection_crypto-1.0.pdf
- https://github.com/someshkar/colabcat

### Hash length extension

- https://crypto.stackexchange.com/questions/3978/understanding-the-length-extension-attack
- https://tipi-hack.github.io/2018/04/01/quals-NDH-18-Wawacoin.html
- https://github.com/stephenbradshaw/hlextend

## Cle publique

- https://fr.wikipedia.org/wiki/Cryptographie_asym%C3%A9trique
- [RSA](https://crypto.stanford.edu/~dabo/pubs/papers/RSA-survey.pdf), https://haltode.fr/algo/chiffrement/rsa.html
https://vozec.fr/crypto-rsa/ , [Side Channel RSA - RSA CRT cf FCSC](https://www.cosade.org/cosade19/cosade14/presentations/session2_b.pdf), https://0x90p0wned.wordpress.com/author/0x90p0wned/
- [DSA,ElGamal, RSA-CRT - Zenk](https://repo.zenk-security.com/Cryptographie%20.%20Algorithmes%20.%20Steganographie/Cle%20Publique.pdf)
- [ROCA](https://ctftime.org/writeup/8805)
- [Shamir Secret Sharing](https://max.levch.in/post/724289457144070144/shamir-secret-sharing)

### Arithmétique modulaire (Corps finis), Algèbres booléenne et linéaire - en Code

- https://learn-cyber.net/article/Modular-Arithmetic
- https://αβγ.ελ/math-notes.pdf

### Tips RSA

#### Crypto.PublicKey

- https://pycryptodome.readthedocs.io/en/latest/src/public_key/public_key.html

#### Factor

- https://gitlab.inria.fr/cado-nfs/cado-nfs 

```py
import primefac
primefac.pollard_pm1(n)
```

```py
import sympy
list(factorint(n))
```

#### Polynomial factorisation (Sage)

- https://ctftime.org/writeup/22977

#### Padding Oracle

- https://github.com/Vozec/RSA-Padding-Oracle

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


### ECC

- https://www.bibmath.net/dico/index.php?action=affiche&quoi=./g/generateur.html
- https://youtu.be/NEVapv8c-SM?si=PQILRn0cpGuThOlI
- https://andrea.corbellini.name/2015/05/30/elliptic-curve-cryptography-ecdh-and-ecdsa/
- https://eprint.iacr.org/2020/1506.pdf


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

#### Padding ECB,CBC

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

#### Padding Oracle CBC

- https://www.cs.unm.edu/~crandall/secprivspring17/cbcpaddingoracle.pdf
- https://research.nccgroup.com/2021/02/17/cryptopals-exploiting-cbc-padding-oracles/
- https://blog.cloudflare.com/padding-oracles-and-the-decline-of-cbc-mode-ciphersuites/
- https://pypi.org/project/padding-oracle/
- https://github.com/mpgn/Padding-oracle-attack

### DES

- https://crack.sh/des_kpt/

#### Meet In the Middle

- https://www.geeksforgeeks.org/meet-in-the-middle/
- https://lo.calho.st/posts/double-des-meet-in-the-middle/
- https://cdn.comparitech.com/wp-content/uploads/2024/07/meetinthemiddle.pdf

**Stream Cipher Modes**

## Cle secrete - Flux (Stream cipher modes)

- https://fr.wikipedia.org/wiki/Chiffrement_de_flux
- https://fr.wikipedia.org/wiki/RC4
- https://thehackernews.com/2015/07/crack-rc4-encryption.html
- https://crypto.stackexchange.com/questions/83629/forgery-attack-on-poly1305-when-the-key-and-nonce-reused

```c
/* http://www.ouah.org/hacking-dict.html#rc4 */
while (length--) {
    x++; sx = state[x]; y += sx;
    sy = state[y]; state[y] = sx; state[x] = sy;
    *data++ ^= state[(sx+sy)&0xFF];
}
```

### AES - CTR, OFB, CFB

## Cle secrete - Auth modes

### CCM, OCB, GCM

### Square

- https://github.com/Vozec/AES-Square-Attack

### ZIP

- https://security.stackexchange.com/questions/204475/crack-password-protected-zip-file-with-pkcrack

### PRNG

- https://www.0x0ff.info/2014/prng-et-generateur-de-cle/

```c
rand()
```

- si **initialisée**: -> voir `break_rand.c`: réinitialiser avec la même seed donne la même suite de nombres

- sinon: **seed=1**

### LSFR

- https://www.youtube.com/watch?v=P90i0RrPcr8
- https://wftc.xyz/2020/01/crypto-rust/
- https://crypto.stackexchange.com/questions/66102/decrypting-ciphertext-with-partial-key-fragment-using-lfsr-and-berlekamp-massey?rq=1

### OTP 

- https://learn-cyber.net/article/One-Time-Pad-the-Perfect-Cipher
- https://github.com/derbenoo/otp_pwn

## Echange de clés

- https://github.blog/2023-08-17-mtls-when-certificate-authentication-is-done-wrong/

### Lattices et ECC

- https://ur4ndom.dev/posts/2024-02-26-lattice-training/
- https://vozec.fr/crypto-lattice/lattice-introduction/
- [Elliptic Curves](https://people.cs.nctu.edu.tw/~rjchen/ECC2012S/Elliptic%20Curves%20Number%20Theory%20And%20Cryptography%202n.pdf)
- https://eprint.iacr.org/2023/032.pdf
- https://latticehacks.cr.yp.to/slides-dan+nadia+tanja-20171228-latticehacks-16x9.pdf

### SSL

- https://crt.sh
- https://security.stackexchange.com/questions/20803/how-does-ssl-tls-work

## Cours: Cryptohack Starters

![](./images/warn.png)

Voir:

- `./elliptic_curves`

