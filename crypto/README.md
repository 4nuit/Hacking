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

### Guidelines : Programming

- https://github.com/veorq/cryptocoding

### Machines

- https://www.cryptomuseum.com/
- https://www.ciphermachinesandcryptology.com/

### Specs

- https://github.com/stamparm/cryptospecs/
- https://github.com/SideChannelMarvels/Deadpool

### Cheatsheets

- https://github.com/ashutosh1206/Crypton
- https://github.com/zademn/EverythingCrypto
- https://github.com/jvdsn/crypto-attacks
- https://github.com/oalieno/Crypto-Course
- https://github.com/elikaski/ECC_Attacks
- https://github.com/mimoo/RSA-and-LLL-attacks


```bash
# Sage 10.7
sage -c "import runpy; runpy.run_path('crypto-attacks/attacks/rsa/boneh_durfee.py', run_name='__main__')"
```

## Challenges

- https://www.mathraining.be/ #todo
- https://cryptopals.com #todo
- https://cryptohack.org

## Outils

- [Alpertron](https://www.alpertron.com.ar/ECM.HTM)
- [ASN.1 PEM/DER Decoder](https://lapo.it/asn1js/)
- [Cryptsetup](https://wiki.archlinux.org/title/Dm-crypt/Device_encryption)
- [Cupp (interactive wordlist)](https://github.com/Mebus/cupp)
- [Cyberchef](https://gchq.github.io/CyberChef/)
- [Dcode](https://www.dcode.fr/)
- [Gmpy2](https://gmpy2.readthedocs.io/en/latest/overview.html)
- [Hashes.com](https://hashes.com)
- [JWS - JWT lib in Node.js](https://www.npmjs.com/package/jws)
- [OpenSSL cheatsheet](https://www.freecodecamp.org/news/openssl-command-cheatsheet-b441be1e8c4a/)
- [Pkcrack](https://github.com/keyunluo/pkcrack)
- [Pycryptodome](https://pycryptodome.readthedocs.io/en/latest/src/api.html)
- [PyJWT](https://pyjwt.readthedocs.io/en/latest/)
- [RsaTool](https://github.com/ius/rsatool)
- [RsaCtfTool](https://github.com/Ganapati/RsaCtfTool)
- [Sage Cell Server (Online)](https://sagecell.sagemath.org/)
- [Sympy (docs)](https://docs.sympy.org/latest/modules/polys/reference.html)
- [Xortool](https://github.com/hellman/xortool)
- [Z3](https://theory.stanford.edu/~nikolaj/programmingz3.html)

```bash
# RSA
openssl asn1parse -in pub.pem
openssl <rsa|ec> -in pub.pem -text -noout

openssl genrsa -out priv.key 4096
openssl rsa -pubout -out public.key -in priv.key
openssl rsa -in priv.key -inform pem -out priv.der -outform der

openssl x509 -inform DER -in cert.der -text
openssl x509 -inform DER -in cert.der -pubkey -noout

openssl rsautl -decrypt -inkey key.pem -in file.enc -out file.dec
openssl pkeyutl -decrypt -inkey key.pem -in file.enc -out file.dec
```

```bash
# AES
openssl aes-256-cbc -d -iter 10 -pass pass:$(cat pass.txt) -in file.enc -out file.dec
openssl enc -d -aes-256-cbc -in file.enc -out file.dec -K "key" -iv "iv" 
```

## Hashs

- https://security.stackexchange.com/questions/211/how-to-securely-hash-passwords
- https://stackoverflow.com/questions/401656/secure-hash-and-salt-for-php-passwords
- https://cyber.gouv.fr/sites/default/files/2021/03/anssi-guide-selection_crypto-1.0.pdf
- https://github.com/someshkar/colabcat

### Hash length extension

- https://crypto.stackexchange.com/questions/3978/understanding-the-length-extension-attack
- https://tipi-hack.github.io/2018/04/01/quals-NDH-18-Wawacoin.html
- https://github.com/stephenbradshaw/hlextend

#### MD5

- https://web.archive.org/web/20120725115432/http://www.ghostsinthestack.org/article-22-exploitation-des-collisions-md5.html

#### Sha1

- https://malicioussha1.github.io/


## Public key encryption

- [Wiki - Public key crypto](https://en.wikipedia.org/wiki/Public-key_cryptography)
- https://vozec.fr/rsa/ 
- https://en.wikipedia.org/wiki/PKCS
- https://haltode.fr/algo/chiffrement/rsa.html
- https://0x90p0wned.wordpress.com/author/0x90p0wned/
- [Twenty Years of Attacks on the RSA Cryptosystem](https://crypto.stanford.edu/~dabo/pubs/papers/RSA-survey.pdf)
- [DSA,ElGamal, RSA-CRT - Zenk](https://repo.zenk-security.com/Cryptographie%20.%20Algorithmes%20.%20Steganographie/Cle%20Publique.pdf)
- [Shamir Secret Sharing](https://max.levch.in/post/724289457144070144/shamir-secret-sharing)

### Modular arithmetic

- https://learn-cyber.net/article/Modular-Arithmetic
- [Quadratic residues & Legendre's Symbol - Mathraining](https://www.mathraining.be/chapters/55?type=10)
- https://doc.sagemath.org/html/en/reference/rings_standard/sage/arith/misc.html#sage.arith.misc.CRT_basis

### Lattices

- https://cryptography101.ca/
- https://cryptohack.gitbook.io/cryptobook/lattices/
- https://vozec.fr/crypto-lattice/lattice-introduction/
- https://ur4ndom.dev/posts/2024-02-26-lattice-training/
- https://github.com/rkm0959/Inequality_Solving_with_CVP
- [A Gentle Tutorial for Lattice-Based Cryptanalysis](https://eprint.iacr.org/2023/032.pdf)
- https://latticehacks.cr.yp.to/slides-dan+nadia+tanja-20171228-latticehacks-16x9.pdf

### RSA

- [RSA with PyCrypto - gist](https://gist.github.com/YannBouyeron/f39893644f89dd676297cc3bc67eaedb)
- [The RSA and Rabin Cryptosystems - auckland.ac.nz](https://www.math.auckland.ac.nz/~sgal018/crypto-book/ch24.pdf)
- https://pycryptodome.readthedocs.io/en/latest/src/public_key/public_key.html
- https://github.com/jvdsn/crypto-attacks/blob/master/attacks/rsa/hastad_attack.py
- https://github.com/apoirrier/CTFs-writeups/blob/master/CSAWQual2021/crypto/RSAPopQuiz.md

#### Common factorisation

- http://www.factordb.com/
- https://www.alpertron.com.ar/ECM.HTM
- https://gitlab.inria.fr/cado-nfs/cado-nfs 

```py
import primefac
primefac.pollard_pm1(n)
```

OR

```py
import sympy
list(factorint(n))
```

```bash
./rsatool.py -n <N> -e <E> -d <D> -o key.pem
```

#### Padding Oracle

- https://github.com/Vozec/RSA-Padding-Oracle

#### Polynomial factorisation (Sage)

- https://ctftime.org/writeup/22977

#### Coppersmith Attacks (cf Lattices)

- https://github.com/defund/coppersmith # Generic implementation of Coppersmith's method for multivariate polynomials 
- https://github.com/mimoo/RSA-and-LLL-attacks
- https://vozec.fr/rsa/rsa-8-coppersmith-saves-you/
- https://github.com/oalieno/Crypto-Course/tree/master/RSA/Stereotyped
- https://github.com/oalieno/Crypto-Course/tree/master/RSA/Coppersmith-Short-Pad
- https://github.com/oalieno/Crypto-Course/tree/master/RSA/Known-High-Bits-of-p
- https://github.com/jvdsn/crypto-attacks/blob/master/shared/small_roots/coron.py
- https://github.com/jvdsn/crypto-attacks/blob/master/attacks/rsa/partial_key_exposure.py
- https://github.com/grocid/CTF/tree/master/CSAW/2016#still-broken-box-400-p

---

**Knowing high bits of p**:

```py
p_approx = ...
unknown_lsb_bits = ...
p_known = p_approx >> unknown_lsb_bits

F.<x> = PolynomialRing(Zmod(n))
f = (p_known << unknown_lsb_bits) + x
roots = f.small_roots(X=2 ** unknown_lsb_bits, beta=0.44, epsilon=1/32)

p = int((p_known << unknown_lsb_bits) + Integer(roots[0]))
```

---

---

**Knowing d % known_bits**

* If we know $$dp \equiv d \mod (p-1)$$ and $$dq \equiv d \mod (q-1)$$:

* $$e*d  = 1 [\phi]$$   =>    $$e * dp = 1 + k_p (p-1)$$ and be can bruteforce k to find p.

* Otherwise, $$ed = 1 + k(p-1)(q-1), \quad \text{i.e.} \quad s = p + q = n + 1 + \frac{1 - ed}{k}.$$

* Using $$d = d_0 + \Delta$$ (with $$d_0$$ the known LSBs),
  $$s = n + 1 + \frac{1 - e(d_0 + \Delta)}{k} = s_0 - \frac{e \Delta}{k},$$
  where
  $$s_0 = n + 1 + \frac{1 - e d_0}{k}$$
  is known.

* Knowing $$n = p \cdot q$$ and $$s = s_0 - \frac{e \Delta}{k}$$, we can write $$p$$ as the root of
  $$f(p, \Delta) = p^2 - s_0 p + n + \frac{e}{k} p \Delta \equiv 0 \pmod{n}.$$

* Completing the square:
  $$(p - \frac{s}{2})^2 = \frac{s^2}{4} - n = r^2 \quad \implies \quad p = \frac{s}{2} + r, ; q = \frac{s}{2} - r.$$

* With
  $$P : X \mapsto X - p_0$$
  over $$\mathbb{Z}/n\mathbb{Z}$$ (where $$p_0$$ are the known LSBs), **Coppersmith’s variant attack** (Boneh–Durfee, Blömer–May)[^1] finds small roots $$x_i \le N^{1/d}$$ over $$\mathbb{Z}$$, allowing recovery of
  $$p = p_0 + x_i.$$

* Let
  $$p = p_0 + x$$
  with unknown offset (x), and write
  $$P(X, \Delta) = f(p_0 + X, \Delta) = X^2 + L(\Delta) X + C(\Delta),$$
  where
  $$L(\Delta) = 2 p_0 - s_0 + \frac{e}{k} \Delta, \quad C(\Delta) = p_0^2 - s_0 p_0 + n + \frac{e}{k} p_0 \Delta.$$

* The small integer pair $$(X, \Delta)$$ satisfies
  $$P(X, \Delta) \equiv 0 \pmod{n}.$$

* Using **LLL** on a lattice built from monomials $$X^i \Delta^j n^\ell$$ produces a short vector vanishing at $$(x, \Delta)$$, yielding
  $$p = p_0 + x, \quad q = \frac{n}{p} \quad \text{or} \quad q = s - p.$$

* **Example** [^2][^3]: Starting with $$F: \mapsto X^2 + 6X + 352 \mod \mathbb{Z}/667\mathbb{Z}$$,  we seek the root 15, which satisfies $$f(15) \equiv 0 \mod 667$$ . We want $$x$$ such as $$f(x) = 0$$, with $$\left| x \right| \leq B$$.
After matrix reduction (from polynomial matrix $$M$$ to $$M'$$ with $$B = 20$$), we obtain the polynomial $$G: X \mapsto X^2 + 6X - 315$$, which has 15 as a root modulo 667. When evaluating at $$Bx$$, the root is preserved: $$G(Bx) = 400x^2 + 120x - 315$$. This transformation is crucial because it maps the solution in $$\mathbb{Z}/667\mathbb{Z}$$ to a polynomial in $$\mathbb{Z}$$ that we can work with, allowing us to find small coefficients while still having the root modulo $$667$$.


```py
X = var('X')
d0 = d % (2 ** known_bits)
P.<x> = PolynomialRing(Zmod(N))


def solve2pow(a, b, c, bits):
    if bits <= 0:
        return [0]
    a, b, c = map(ZZ, (a, b, c))
    v = min(a.valuation(2), b.valuation(2), c.valuation(2), bits)
    a >>= v
    b >>= v
    c >>= v
    roots = [r for r in (0, 1) if (a * r * r + b * r + c) % 2 == 0]
    mod = 2
    for _ in range(1, bits - v):
        nxt = []
        for r in roots:
            for d in (0, 1):
                cand = r + d * mod
                if (a * cand * cand + b * cand + c) % (mod << 1) == 0:
                    nxt.append(cand)
        roots = list(dict.fromkeys(nxt))
        if not roots:
            break
        mod <<= 1
    step = 1 << (bits - v)
    return [(r + i * step) % (1 << bits) for r in roots for i in range(1 << v)]

print('[ ] Thinking...')
for k in range(1, e + 1):
    a = k
    b = e * d0 - k * (N + 1) - 1
    c = k * N
    residues = solve2pow(a, b, c, known_bits)
    if not residues:
        continue
    print(k)
    for residue in residues:
        f = x * 2 ** known_bits + ZZ(residue)
        f = f.monic()
        roots = f.small_roots(X=2 ** (N.nbits() // 2 - known_bits), beta=0.3)

        if roots:
            x0 = roots[0]
            p = gcd(2 ** known_bits * x0 + ZZ(residue), N)
            print('[+] Found factorization!')
            print('p =', ZZ(p))
            print('q =', N / ZZ(p))
            break
```

[^1]: [Partial key exposure](https://github.com/jvdsn/crypto-attacks/blob/master/attacks/rsa/partial_key_exposure.py)
[^2]: [Maël H., Coppersmith (in a nutshell)](https://mega.nz/folder/EWtXyZZK#Kq4pRmBCecAUUx4j7pqgmw/file/1TNmTLiR)
[^3]: [Coppersmith Method and Related Applications - auckland.ac.nz](https://www.math.auckland.ac.nz/~sgal018/crypto-book/ch19.pdf)
---


#### Return Of Coppersmith Attack

Knowing $$N = (kM + 65537^a[M])(lM + 65537^b [M])$$ 

We use **Coppersmith**'s Method on $$f(x) =  x + ({M'}^{-1} [N]) * (65537^{a'} [M'])[n]$$, with $$\beta = 0.5$$, $$x=\frac{2*N^{\beta}}{M'}$$.

This produce $$p$$ if $$N \mod p = 0$$.

```bash
RsaCtfTool --isroca --publickey "examples/*.pub"
```

- https://gitlab.com/jix/neca
- https://ctftime.org/writeup/8805
- https://acmccs.github.io/papers/p1631-nemecA.pdf
- https://bitsdeep.com/posts/analysis-of-the-roca-vulnerability/

#### Corrupted key factorisation

- https://eprint.iacr.org/2020/1506.pdf
- https://0day.work/0ctf-2016-quals-writeups/
- https://blog.cryptohack.org/twitter-secrets
- http://mslc.ctf.su/wp/plaidctf-2014-rsa-writeup/
- https://connor-mccartney.github.io/cryptography/small-roots/corrupt-key-2-picoMini
- https://github.com/Jakobus0/FCSC-2020-write-ups/blob/master/corrumpere_write_up.md

```bash
# searching for ASN.1 02 82 01
DATA=$(tr -d '\n' < DECODE.pem)
PAD=$(( (4 - ${#DATA} % 4) % 4 ))
DATA="${DATA}$(printf '=%.0s' $(seq 1 $PAD))"
```

#### Side Channel, RSA-CRT & Bellcore attack

- https://4nuit.github.io/posts/rsa/
- https://4nuit.github.io/posts/smthg_wrong/
- https://vozec.fr/rsa/rsa-9-breaking-signature-shema/
- https://github.com/hoeg/BleichenbacherSignatureForger
- https://www.cosade.org/cosade19/cosade14/presentations/session2_b.pdf

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

- https://github.com/jvdsn/crypto-attacks/blob/master/attacks/rc4/fms.py

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
- https://github.com/oalieno/Crypto-Course/tree/master/Block-Cipher-Mode/Forbidden
- https://www.reversemode.com/2023/10/reversing-france-identite-new-french.html?m=1

### Square

- https://github.com/Vozec/AES-Square-Attack

### ZIP

- https://security.stackexchange.com/questions/204475/crack-password-protected-zip-file-with-pkcrack

### Hill Cipher

- https://github.com/t3rmin0x/CTF-Writeups/tree/master/DarkCTF/Crypto/Embrace%20the%20Climb#embrace-the-climb-

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

### OTP 

- https://github.com/derbenoo/otp_pwn
- https://learn-cyber.net/article/One-Time-Pad-the-Perfect-Cipher
- https://github.com/apoirrier/CTFs-writeups/blob/master/UTCTF2020/One%20True%20Problem.md

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

- [Sage (ECC)](https://doc.sagemath.org/html/en/reference/arithmetic_curves/sage/schemes/elliptic_curves/constructor.html)
- [Elliptic Curves Theory And Crypography](https://people.cs.nctu.edu.tw/~rjchen/ECC2012S/Elliptic%20Curves%20Number%20Theory%20And%20Cryptography%202n.pdf)
- https://github.com/elikaski/ECC_Attacks

### SSL

- https://crt.sh
- https://security.stackexchange.com/questions/20803/how-does-ssl-tls-work

## Cours: Cryptohack Starters

![](./images/warn.png)

Voir:

- `./elliptic_curves`

