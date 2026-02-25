## Doc - Asymmetric / Public key cryptography

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


## Tools

- [Alpertron - factorisation using ECM](https://www.alpertron.com.ar/ECM.HTM)
- [ASN.1 PEM/DER Decoder](https://lapo.it/asn1js/)
- [Gmpy2](https://gmpy2.readthedocs.io/en/latest/overview.html)
- [RsaTool](https://github.com/ius/rsatool)
- [RsaCtfTool](https://github.com/Ganapati/RsaCtfTool)
- https://github.com/maple3142/lll_cvp
- https://github.com/elikaski/ECC_Attacks


## Lattices

- https://thelatticeclub.com/
- https://cryptography101.ca/
- https://cryptohack.gitbook.io/cryptobook/lattices/
- https://vozec.fr/crypto-lattice/lattice-introduction/
- https://ur4ndom.dev/posts/2024-02-26-lattice-training/
- https://github.com/rkm0959/Inequality_Solving_with_CVP
- [A Gentle Tutorial for Lattice-Based Cryptanalysis](https://eprint.iacr.org/2023/032.pdf)
- https://latticehacks.cr.yp.to/slides-dan+nadia+tanja-20171228-latticehacks-16x9.pdf

## Shamir Secret Sharing

- https://en.wikipedia.org/wiki/Shamir%27s_secret_sharing
- https://vozec.fr/other/explanation--attack-on-shamirs-shared-secret/
- https://conduition.io/cryptography/shamir-resharing/

## RSA

- [RSA with PyCrypto - gist](https://gist.github.com/YannBouyeron/f39893644f89dd676297cc3bc67eaedb)
- [PyCryptoDome - Public Key](https://pycryptodome.readthedocs.io/en/latest/src/public_key/public_key.html)
- [The RSA and Rabin Cryptosystems - auckland.ac.nz](https://www.math.auckland.ac.nz/~sgal018/crypto-book/ch24.pdf)
- https://0x90p0wned.wordpress.com/author/0x90p0wned/
- https://github.com/apoirrier/CTFs-writeups/blob/master/CSAWQual2021/crypto/RSAPopQuiz.md

### Common factorisation

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

### Padding Oracle

- https://en.wikipedia.org/wiki/PKCS_1
- https://github.com/Vozec/RSA-Padding-Oracle
- https://github.com/maximmasiutin/rsa-bleichenbacher-signature

### Polynomial factorisation (Sage)

- https://ctftime.org/writeup/22977
- https://github.com/Z-nZzz/Writeups/tree/main/404/PRSA
- https://bitsdeep.com/posts/fcsc-2021-write-ups-for-the-crypto-challenges/#rsa-destroyer

### Coppersmith Attacks (cf Lattices)

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
            p = ZZ(p)
            q = N / ZZ(p)
            break
```

---

### Return Of Coppersmith Attack

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

### Corrupted key factorisation

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

### Side Channel - Fault Attack on RSA-CRT using DFA (Differential Fault Analysis)

- https://4nuit.github.io/posts/rsa/
- https://4nuit.github.io/posts/smthg_wrong/
- https://vozec.fr/rsa/rsa-9-breaking-signature-shema/
- https://coastalwhite.github.io/intro-power-analysis/rsa.html
- https://www.cosade.org/cosade19/cosade14/presentations/session2_b.pdf


## ECC

- [Sage (ECC)](https://doc.sagemath.org/html/en/reference/arithmetic_curves/sage/schemes/elliptic_curves/constructor.html)
- [Elliptic Curves Theory And Crypography](https://people.cs.nctu.edu.tw/~rjchen/ECC2012S/Elliptic%20Curves%20Number%20Theory%20And%20Cryptography%202n.pdf)
- https://github.com/elikaski/ECC_Attacks
- https://andrea.corbellini.name/2015/05/30/elliptic-curve-cryptography-ecdh-and-ecdsa/

### Discrete log

- https://vozec.fr/other/ecc-diffie-hellman/
- https://ctf-wiki.mahaloz.re/crypto/asymmetric/discrete-log/ecc/

### Side Channel - Fault Attack on ElGamal

- https://staff.fim.uni-passau.de/kreuzer/papers/ElGamal_FaultAttack-preprint.pdf

```bash
gpg --gen-keys
gpg --list-leys
gpg --export -a "mail.com" > public.key
gpg -d file.pgp
```
