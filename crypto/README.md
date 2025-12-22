## Doc Crypto

- https://www.schneier.com/
- https://www.crypto101.io/
- https://toc.cryptobook.us/
- http://theamazingking.com/
- https://joyofcryptography.com/
- https://cryptobook.nakov.com/
- https://affine.group/writeups
- https://cryptohack.gitbook.io/cryptobook/
- https://github.com/pFarb/awesome-crypto-papers/
- https://github.com/hadipourh/course-cryptanalysis
- https://en.wikipedia.org/wiki/Padding_(cryptography)
- https://en.wikipedia.org/wiki/Power_analysis
- https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-78-5.pdf
- https://kirll0s.medium.com/cryptographic-attacks-breaking-security-beyond-the-algorithm-c40b6cb2fcee

### Guidelines : Programming

- [Crypto right answers](https://gist.github.com/tqbf/be58d2d39690c3b366ad)
- [Crypto wrong answers](https://gist.github.com/paragonie-scott/e9319254c8ecbad4f227)
- https://gotchas.salusa.dev/
- https://github.com/veorq/cryptocoding
- https://loup-vaillant.fr/articles/rolling-your-own-crypto
- https://github.com/samuel-lucas6/Cryptography-Guidelines
- https://cyber.gouv.fr/publications/recommandations-de-securite-relatives-tls

### Machines

- https://www.cryptomuseum.com/
- https://www.ciphermachinesandcryptology.com/

### Specs

- https://github.com/stamparm/cryptospecs/

### Cheatsheets

- https://github.com/ashutosh1206/Crypton
- https://github.com/zademn/EverythingCrypto
- https://github.com/jvdsn/crypto-attacks
- https://github.com/oalieno/Crypto-Course
- https://github.com/maple3142/lll_cvp
- https://github.com/elikaski/ECC_Attacks
- https://github.com/elliptic-shiho/crypto_misc/
- https://github.com/SideChannelMarvels/Deadpool
- https://github.com/simple-crypto/SCALib

```bash
# Sage 10.7
sage -c "import runpy; runpy.run_path('crypto-attacks/attacks/rsa/boneh_durfee.py', run_name='__main__')"

# Python 3.13 (Sage + Python)
export PYTHONPATH=~/.pyenv/versions/hacking/lib/python3.13/site-packages
sage solve.sage
```

## Challenges

- https://www.mathraining.be/ #todo
- https://cryptopals.com #todo
- https://cryptohack.org

## Outils

- [Alpertron - factorisation using ECM](https://www.alpertron.com.ar/ECM.HTM)
- [ASN.1 PEM/DER Decoder](https://lapo.it/asn1js/)
- [Colabcat - cracking hashes, Google Colab](https://github.com/someshkar/colabcat)
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

```py
from Crypto.Util.number import long_to_bytes, bytes_to_long

number = bytes_to_long(b"Testing bytes to long conversion")
assert(long_to_bytes(number) == bytes.fromhex(hex(number)[2:]))
```

## Hashs

- https://security.stackexchange.com/questions/211/how-to-securely-hash-passwords
- https://stackoverflow.com/questions/401656/secure-hash-and-salt-for-php-passwords
- https://cyber.gouv.fr/sites/default/files/2021/03/anssi-guide-selection_crypto-1.0.pdf

### Hash length extension

- https://crypto.stackexchange.com/questions/3978/understanding-the-length-extension-attack
- https://tipi-hack.github.io/2018/04/01/quals-NDH-18-Wawacoin.html
- https://github.com/stephenbradshaw/hlextend

#### MD4

- https://github.com/JorianWoltjer/Cryptopals/blob/master/set4/30.py

#### MD5

- https://web.archive.org/web/20120725115432/http://www.ghostsinthestack.org/article-22-exploitation-des-collisions-md5.html

#### Sha1

- https://malicioussha1.github.io/
- https://github.com/JorianWoltjer/Cryptopals/blob/master/set4/29.py


### Authenticated encryption

- https://en.wikipedia.org/wiki/Message_authentication_code
- https://en.wikipedia.org/wiki/CBC-MAC
- https://en.wikipedia.org/wiki/HMAC

    
## Public key encryption

- [Wiki - Public key crypto](https://en.wikipedia.org/wiki/Public-key_cryptography)
- https://en.wikipedia.org/wiki/PKCS
- https://haltode.fr/algo/chiffrement/rsa.html
- [Twenty Years of Attacks on the RSA Cryptosystem](https://crypto.stanford.edu/~dabo/pubs/papers/RSA-survey.pdf)
- [DSA,ElGamal, RSA-CRT - Zenk](https://repo.zenk-security.com/Cryptographie%20.%20Algorithmes%20.%20Steganographie/Cle%20Publique.pdf)


### Modular arithmetic

- https://learn-cyber.net/article/Modular-Arithmetic
- [Quadratic residues & Legendre's Symbol - Mathraining](https://www.mathraining.be/chapters/55?type=10)
- https://en.wikipedia.org/wiki/Chinese_remainder_theorem#General_case
- https://www.geeksforgeeks.org/dsa/fast-exponention-using-bit-manipulation/

#### Sage builtins: CRT & Nth-root

- https://doc.sagemath.org/html/en/reference/rings_standard/sage/arith/misc.html#sage.arith.misc.CRT_basis
- https://doc.sagemath.org/html/en/reference/finite_rings/sage/rings/finite_rings/integer_mod.html#sage.rings.finite_rings.integer_mod.IntegerMod_abstract.nth_root

### Lattices

- https://thelatticeclub.com/
- https://cryptography101.ca/
- https://cryptohack.gitbook.io/cryptobook/lattices/
- https://vozec.fr/crypto-lattice/lattice-introduction/
- https://ur4ndom.dev/posts/2024-02-26-lattice-training/
- https://github.com/rkm0959/Inequality_Solving_with_CVP
- [A Gentle Tutorial for Lattice-Based Cryptanalysis](https://eprint.iacr.org/2023/032.pdf)
- https://latticehacks.cr.yp.to/slides-dan+nadia+tanja-20171228-latticehacks-16x9.pdf

### Shamir Secret Sharing

- https://en.wikipedia.org/wiki/Shamir%27s_secret_sharing
- https://vozec.fr/other/explanation--attack-on-shamirs-shared-secret/
- https://conduition.io/cryptography/shamir-resharing/

### RSA

- [RSA with PyCrypto - gist](https://gist.github.com/YannBouyeron/f39893644f89dd676297cc3bc67eaedb)
- [PyCryptoDome - Public Key](https://pycryptodome.readthedocs.io/en/latest/src/public_key/public_key.html)
- [The RSA and Rabin Cryptosystems - auckland.ac.nz](https://www.math.auckland.ac.nz/~sgal018/crypto-book/ch24.pdf)
- https://0x90p0wned.wordpress.com/author/0x90p0wned/
- https://github.com/apoirrier/CTFs-writeups/blob/master/CSAWQual2021/crypto/RSAPopQuiz.md

#### Common factorisation

- http://www.factordb.com/
- https://github.com/bbuhrow/yafu
- https://www.alpertron.com.ar/ECM.HTM
- https://gitlab.inria.fr/cado-nfs/cado-nfs 
- https://github.com/y011d4/factor-from-random-known-bits
- https://blog.nikost.dev/posts/root-me-ctf20k-crypto/#rsa-customer-service

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

- https://en.wikipedia.org/wiki/PKCS_1
- https://github.com/Vozec/RSA-Padding-Oracle
- https://github.com/maximmasiutin/rsa-bleichenbacher-signature

#### Polynomial factorisation (Sage)

- https://ctftime.org/writeup/22977
- https://github.com/Z-nZzz/Writeups/tree/main/404/PRSA
- https://bitsdeep.com/posts/fcsc-2021-write-ups-for-the-crypto-challenges/#rsa-destroyer

#### Coppersmith Attacks (cf Lattices)

- https://github.com/defund/coppersmith # Generic implementation of Coppersmith's method for multivariate polynomials
- https://github.com/keeganryan/flatter
- https://github.com/keeganryan/cuso	# //
- https://vozec.fr/rsa/rsa-8-coppersmith-saves-you/
- [Coppersmith Method and Related Applications - auckland.ac.nz](https://www.math.auckland.ac.nz/~sgal018/crypto-book/ch19.pdf)
- https://github.com/oalieno/Crypto-Course/tree/master/RSA/Stereotyped
- https://github.com/oalieno/Crypto-Course/tree/master/RSA/Coppersmith-Short-Pad
- https://github.com/oalieno/Crypto-Course/tree/master/RSA/Known-High-Bits-of-p
- https://github.com/jvdsn/crypto-attacks/blob/master/shared/small_roots/coron.py
- https://github.com/jvdsn/crypto-attacks/blob/master/attacks/rsa/partial_key_exposure.py
- https://github.com/grocid/CTF/tree/master/CSAW/2016#still-broken-box-400-p

---

**Knowing high bits of p**:

```py
# Univariate
from Crypto.Util.number import isPrime

N = ...
p_appox = ...
unknown_lsb_bits = ...

p_known = (p_approx >> unknown_lsb_bits) << unknown_lsb_bits
F.<x> = PolynomialRing(Zmod(N))
f = p_known + x
roots = f.small_roots(X=2 ** lbits, beta=0.44, epsilon=1/32)

p = int(p_known + Integer(roots[0])); print(p)
assert(isPrime(p))
q = N//p
assert(N == p*q)
```

```py
# Bivariate
# Install https://github.com/keeganryan/flatter.git
# pacman -S gmp mpfr openblas eigen fplll
# src/problems/qr_factorization/CMakeLists.txt:find_package(Eigen3 3.3...<6 REQUIRED NO_MODULE)

from Crypto.Util.number import isPrime

p, q = random_prime(2^512), random_prime(2^512)
N = p*q
print("N =", N)
B = 270
a, b = random_prime(2^300), randint(0, 2^300)
x, y = randint(0, 2^B), randint(0, 2^B)
c, d = p - (a*x),  q - (b*y)

load('https://raw.githubusercontent.com/Connor-McCartney/coppersmith/refs/heads/main/coppersmith.sage')
PR.<X, Y> = PolynomialRing(Zmod(N), 2)
f = (a*X + c) * (b*Y + d)
assert f(X=x, Y=y) == 0
roots= bivariate(f, implementation='shift_polynomials', bounds=(2**B, 2**B), m=2)

assert((x,y) == roots)
p_recov = c + a*roots[0]
q_recov = d + b*roots[1]
assert(isPrime(p_recov))
assert(p==p_recov); assert(q==q_recov)
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

```py
N = ...
d = ...

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

- [Recovering cryptographic keys from partial information, by example](https://eprint.iacr.org/2020/1506.pdf)
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

#### Side Channel - Fault Attack on RSA-CRT using DFA (Differential Fault Analysis)

- https://4nuit.github.io/posts/rsa/
- https://4nuit.github.io/posts/smthg_wrong/
- https://vozec.fr/rsa/rsa-9-breaking-signature-shema/
- https://coastalwhite.github.io/intro-power-analysis/rsa.html
- https://www.cosade.org/cosade19/cosade14/presentations/session2_b.pdf

### ECC

- [Sage (ECC)](https://doc.sagemath.org/html/en/reference/arithmetic_curves/sage/schemes/elliptic_curves/constructor.html)
- [Elliptic Curves Theory And Crypography](https://people.cs.nctu.edu.tw/~rjchen/ECC2012S/Elliptic%20Curves%20Number%20Theory%20And%20Cryptography%202n.pdf)
- https://github.com/elikaski/ECC_Attacks
- https://andrea.corbellini.name/2015/05/30/elliptic-curve-cryptography-ecdh-and-ecdsa/

#### Discrete log

- https://vozec.fr/other/ecc-diffie-hellman/
- https://ctf-wiki.mahaloz.re/crypto/asymmetric/discrete-log/ecc/

#### Side Channel - Fault Attack on ElGamal

- https://staff.fim.uni-passau.de/kreuzer/papers/ElGamal_FaultAttack-preprint.pdf

```bash
gpg --gen-keys
gpg --list-leys
gpg --export -a "mail.com" > public.key
gpg -d file.pgp
```


## Private Key encryption - Stream ciphers

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


## Private Key encryption - Block Ciphers

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

#### ECB Oracle

- https://crypto.stackexchange.com/questions/42891/chosen-plaintext-attack-on-aes-in-ecb-mode
- https://security.stackexchange.com/questions/271007/aes-ecb-cookie-bypass

```python
#ECB
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

- https://www.di-mgt.com.au/cryptopad.html
- https://en.wikipedia.org/wiki/Padding_(cryptography)#PKCS#5_and_PKCS#7
- https://book-of-gehn.github.io/articles/2018/07/01/Cut-and-Paste-ECB-Blocks.html
- https://crypto.stackexchange.com/questions/71365/why-does-a-padding-block-exist-for-ecb-and-cbc-modes

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

- https://github.com/mpgn/Padding-oracle-attack
- https://www.cs.unm.edu/~crandall/secprivspring17/cbcpaddingoracle.pdf
- https://research.nccgroup.com/2021/02/17/cryptopals-exploiting-cbc-padding-oracles/
- https://blog.cloudflare.com/padding-oracles-and-the-decline-of-cbc-mode-ciphersuites/

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

![elliptic_curves](./elliptic_curves)

### SSL

- https://crt.sh
- https://security.stackexchange.com/questions/20803/how-does-ssl-tls-work

## Cours: Cryptohack Starters

![](./images/warn.png)

Voir:

- `./elliptic_curves`

