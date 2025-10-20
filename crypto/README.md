## Doc Crypto

- https://www.schneier.com/
- https://www.crypto101.io/
- https://toc.cryptobook.us/
- http://theamazingking.com/
- https://joyofcryptography.com/
- https://cryptohack.gitbook.io/cryptobook/
- https://gotchas.salusa.dev/
- https://cryptobook.nakov.com/
- https://affine.group/writeups
- https://thelatticeclub.com/
- https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-78-5.pdf
- https://cyber.gouv.fr/publications/recommandations-de-securite-relatives-tls

### Specs

- https://github.com/stamparm/cryptospecs/
- https://github.com/SideChannelMarvels/Deadpool

### Cheatsheets

- https://github.com/ashutosh1206/Crypton
- https://github.com/zademn/EverythingCrypto
- https://github.com/jvdsn/crypto-attacks
- https://github.com/elikaski/ECC_Attacks
- https://github.com/mimoo/RSA-and-LLL-attacks

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
- [RsaCtfTool](https://github.com/Ganapati/RsaCtfTool)
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

## Hashs

- https://security.stackexchange.com/questions/211/how-to-securely-hash-passwords
- https://stackoverflow.com/questions/401656/secure-hash-and-salt-for-php-passwords
- https://cyber.gouv.fr/sites/default/files/2021/03/anssi-guide-selection_crypto-1.0.pdf
- https://github.com/someshkar/colabcat

### Hash length extension

- https://crypto.stackexchange.com/questions/3978/understanding-the-length-extension-attack
- https://tipi-hack.github.io/2018/04/01/quals-NDH-18-Wawacoin.html
- https://github.com/stephenbradshaw/hlextend


## Public key encryption

- [Wiki - Public key crypto](https://en.wikipedia.org/wiki/Public-key_cryptography)
- https://vozec.fr/rsa/ 
- https://en.wikipedia.org/wiki/PKCS
- https://haltode.fr/algo/chiffrement/rsa.html
- https://0x90p0wned.wordpress.com/author/0x90p0wned/
- [Twenty Years of Attacks on the RSA Cryptosystem](https://crypto.stanford.edu/~dabo/pubs/papers/RSA-survey.pdf)
- [DSA,ElGamal, RSA-CRT - Zenk](https://repo.zenk-security.com/Cryptographie%20.%20Algorithmes%20.%20Steganographie/Cle%20Publique.pdf)
- [Shamir Secret Sharing](https://max.levch.in/post/724289457144070144/shamir-secret-sharing)

### RSA

- https://pycryptodome.readthedocs.io/en/latest/src/public_key/public_key.html

#### Common factorisation

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

#### Coppersmith & ROCA

- https://github.com/mimoo/RSA-and-LLL-attacks
- https://vozec.fr/rsa/rsa-8-coppersmith-saves-you/
- https://ctftime.org/writeup/8805

```py
# Using Sage's small roots
def coppersmith(msg,c,n,e,eps=1/20):
	def get_limit(msg):
		spl = msg.split('\x00')
		x = max(len(spl[0]),1)
		x_2 = 1
		while(x_2 < x):
			x_2 *= 2
		y = max(len(spl[-1]),1)
		return x_2,y

	a,b = get_limit(msg)
	msg = int(msg.encode("utf-8").hex(), 16)

	P.<x> = PolynomialRing(Zmod(n))
	f = (msg + (a^b)*x)^e - c
	f = f.monic()
	return f.small_roots(epsilon=eps)
```

#### Side Channel, RSA-CRT & Bellcore attack

- https://www.cosade.org/cosade19/cosade14/presentations/session2_b.pdf
- https://4nuit.github.io/posts/rsa/
- https://4nuit.github.io/posts/smthg_wrong/

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
- https://andrea.corbellini.name/2015/05/30/elliptic-curve-cryptography-ecdh-and-ecdsa/
- https://eprint.iacr.org/2020/1506.pdf
- https://github.com/elikaski/ECC_Attacks


## Private Key encryption - Block Ciphers

- [Wiki chiffrement symetrique](https://fr.wikipedia.org/wiki/Cryptographie_sym%C3%A9trique)
- [Wiki Chiffrement_par_bloc](https://fr.wikipedia.org/wiki/Chiffrement_par_bloc)
- https://braincoke.fr/blog/2020/08/the-aes-encryption-algorithm-explained/#encryption-algorithm-overview
- https://stackoverflow.com/questions/1220751/how-to-choose-an-aes-encryption-mode-cbc-ecb-ctr-ocb-cfb
- https://vozec.fr/aes/analyse-lineaire-aes/

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

### Padding modes attacks

- [Wiki - Block cipher modes of operation](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation)
- [Wiki - Padding Oracle](https://en.wikipedia.org/wiki/Padding_oracle_attack)

#### ECB Oracle

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


#### CBC Bit Flipping 

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

#### CBC Padding Oracle

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

## Private Key encryption - Stream cipher modes

- https://fr.wikipedia.org/wiki/Chiffrement_de_flux
- https://fr.wikipedia.org/wiki/RC4
- https://thehackernews.com/2015/07/crack-rc4-encryption.html
- https://crypto.stackexchange.com/questions/83629/forgery-attack-on-poly1305-when-the-key-and-nonce-reused

### RC4

#### KSA (Key Schedule Algorithm)

```py
def generate_substitution_table(key: bytes) -> list[int]:
    # table initiale 0..255
    S = list(range(256))
    j = 0
    keylen = len(key)

    for i in range(255, -1, -1):  # descend de 255 à 0
        j = (j + S[i] + key[i % keylen]) % 256
        S[i], S[j] = S[j], S[i]
    return S

def invert_table(S: list[int]) -> list[int]:
    Sinv = [0] * 256
    for i, v in enumerate(S):
        Sinv[v] = i
    return Sinv

S = generate_substitution_table(key)
Sinv = invert_table(S)

state_array = bytes(Sinv[b] for b in cipher)
```

#### PRGA (Pseudo Random Generation Algorithm)

```py
def prga(state_array: bytes) -> bytes:
	i,j = 0,0
	while True:
	i = (i + 1) % 256
	j = (j + S[i]) % 256
	S[i], S[j] = S[j], S[i]  # swap
	K = S[(S[i] + S[j]) % 256]
	return K
	
keystream = prga(state_array)
```

### AES - CTR, OFB, CFB

- [English ascii frequence table](http://www.fitaly.com/board/domper3/posts/136.html)
- https://github.com/SpiderLabs/cribdrag
- https://github.com/JorianWoltjer/Cryptopals
- https://github.com/ThomasHabets/xor-analyze
- https://crypto.stackexchange.com/questions/2249/how-does-one-attack-a-two-time-pad-i-e-one-time-pad-with-key-reuse/2250#2250

## Secret Key - Authentication modes

### CCM, OCB, GCM

- https://frereit.de/aes_gcm/

### Square

- https://github.com/Vozec/AES-Square-Attack

### ZIP

- https://security.stackexchange.com/questions/204475/crack-password-protected-zip-file-with-pkcrack

### PRNG

- https://www.0x0ff.info/2014/prng-et-generateur-de-cle/
- https://blog.lexfo.fr/php-mt-rand-prediction.html, https://www.openwall.com/php_mt_seed/

```c
rand()
```

- si **initialisée**: -> voir `break_rand.c`: réinitialiser avec la même seed donne la même suite de nombres

- sinon: **seed=1**

### LSFR

- https://www.youtube.com/watch?v=P90i0RrPcr8
- https://wftc.xyz/2020/01/crypto-rust/
- https://crypto.stackexchange.com/questions/66102/decrypting-ciphertext-with-partial-key-fragment-using-lfsr-and-berlekamp-massey?rq=1
- https://github.com/thewhiteninja/lfsr-berlekamp-massey
- https://github.com/oalieno/Crypto-Course/tree/master/LFSR

### OTP 

- https://learn-cyber.net/article/One-Time-Pad-the-Perfect-Cipher
- https://github.com/derbenoo/otp_pwn

## Key management

- [active_directory](../active_directory)
- https://web.mit.edu/kerberos/			# Key Server (KDC)
- https://en.wikipedia.org/wiki/Public_key_infrastructure

```txt
When Alice wants to talk to Bob, she first contacts the key server. 
The key server sends Alice a new secret key  KAB plus the key KAB encrypted with Bob’s key KB . 
Both these messages are encrypted with KA , so only Alice can read them. 
Alice sends the message that is encrypted with Bob’s key, called the ticket, to Bob. 
Bob decrypts it and gets KAB, which is now a session key known only to Alice and Bob—and to the key server.
```

## Key negotiation

- https://github.blog/2023-08-17-mtls-when-certificate-authentication-is-done-wrong/

### ECC

- [Elliptic Curves Theory And Crypography](https://people.cs.nctu.edu.tw/~rjchen/ECC2012S/Elliptic%20Curves%20Number%20Theory%20And%20Cryptography%202n.pdf)
- https://github.com/elikaski/ECC_Attacks

### Lattices

- https://github.com/mimoo/RSA-and-LLL-attacks
- https://ur4ndom.dev/posts/2024-02-26-lattice-training/
- https://vozec.fr/crypto-lattice/lattice-introduction/
- [A Gentle Tutorial for Lattice-Based Cryptanalysis](https://eprint.iacr.org/2023/032.pdf)
- https://latticehacks.cr.yp.to/slides-dan+nadia+tanja-20171228-latticehacks-16x9.pdf


### SSL

- https://crt.sh
- https://security.stackexchange.com/questions/20803/how-does-ssl-tls-work

## Cours: Cryptohack Starters

![](./images/warn.png)

Voir:

- `./elliptic_curves`

