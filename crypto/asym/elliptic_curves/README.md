# Cryptohack Starters

- https://vozec.fr/other/ecc-diffie-hellman/

You will need `Sage`:

```bash
sudo apt install sagemath
```

See: https://fr.wikipedia.org/wiki/Courbe_elliptique for definitions.

`E(Fp) is an abelian group`:
These groups are generally denoted additively, meaning the group law is written G + H for two points G, H of E(Fp), and "exponentiation" is instead written as a multiplication: kG = ±(G + G + ... + G), for k in Z.

Points lie on an elliptic curve with equation $$(E) : y2 = x3 + ax + b[p]$$ (Weierstrass equation)

## Point Negation

We use 2 properties to find Q such that `P + Q = 0` (inverse of P for `+`):

- E is a **cyclic** group
- The **order** of (E), k, is a **prime** number

```python
from Crypto.Util.number import long_to_bytes
from sage.all import *

p = 9739
a = 497
b = 1768

K = GF(p)
E = EllipticCurve([K(a), K(b)])

P = E(8045,6936)

k = E.order() # prime, and P has order k (E cyclic of prime order)

# k*P = O (the identity), so (k-1)*P = k*P - P = O - P = -P
h = k - 1

Q = P * h; print(Q) # -P

# equivalent direct forms (Sage overloads point negation):
assert Q == -P == E(P[0], -P[1])
```

## Point Addition

For two distinct points `P=(x1,y1)`, `Q=(x2,y2)` on `(E): y^2 = x^3 + ax + b [p]`, with `P != Q` and `P != -Q` (otherwise `P+Q = O`, the identity):

```
lambda = (y2 - y1) / (x2 - x1)  [p]   # slope of the line (P,Q)
x3 = lambda^2 - x1 - x2         [p]
y3 = lambda*(x1 - x3) - y1      [p]
```

```python
def point_add(P, Q, a, p):
    x1, y1 = P
    x2, y2 = Q
    lam = (y2 - y1) * pow(x2 - x1, -1, p) % p
    x3 = (lam*lam - x1 - x2) % p
    y3 = (lam*(x1 - x3) - y1) % p
    return (x3, y3)
```

(case `P == Q` intentionally not handled here - see Point Doubling below, different formula since `x2-x1` would vanish)

## Point Doubling

Special case `P == Q` (tangent to the curve instead of a secant):

```
lambda = (3*x1^2 + a) / (2*y1)  [p]
x3 = lambda^2 - 2*x1            [p]
y3 = lambda*(x1 - x3) - y1      [p]
```

```python
def point_double(P, a, p):
    x1, y1 = P
    lam = (3*x1*x1 + a) * pow(2*y1, -1, p) % p
    x3 = (lam*lam - 2*x1) % p
    y3 = (lam*(x1 - x3) - y1) % p
    return (x3, y3)
```

In practice, `sage`/`pycryptodome` already do this (`P + Q`, `2*P`) - useful to know how to implement it by hand for challenges that provide a custom implementation (often intentionally buggy, cf. Weak/Invalid curve attacks below).

## Scalar Multiplication

`kP` (= `P` added `k` times) is efficiently computed in `O(log k)` via double-and-add, never via `k` successive additions:

```python
def scalar_mult(k, P, a, p):
    result = None  # None = point at infinity O
    addend = P
    while k:
        if k & 1:
            result = point_add(result, addend, a, p) if result else addend
        addend = point_double(addend, a, p)
        k >>= 1
    return result
```

## ECDH (Elliptic Curve Diffie-Hellman)

- https://en.wikipedia.org/wiki/Elliptic-curve_Diffie%E2%80%93Hellman

Alice (`d_A`, private key) and Bob (`d_B`) share a public generator point `G`:

```
Alice publishes:  Q_A = d_A * G
Bob publishes:    Q_B = d_B * G
Shared secret: d_A * Q_B = d_A * d_B * G = d_B * Q_A
```

Breaking this (recovering `d_A` from `Q_A` and `G`) = solving the discrete logarithm on the curve (ECDLP) - see Fermat/Euler above for the RSA equivalent.

## ECDSA (signature)

- https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm
- https://www.secg.org/sec1-v2.pdf # reference standard (SEC 1)

```
Signature of m with private key d, generator G of order n:
  k <- unique random value in [1, n-1]           # !! nonce, see SROP/PS3-style reuse below
  (x1, y1) = k*G
  r = x1 mod n
  s = k^-1 * (H(m) + r*d) mod n
  signature = (r, s)

Verification with public key Q = d*G:
  u1 = H(m)*s^-1 mod n ; u2 = r*s^-1 mod n
  (x1, y1) = u1*G + u2*Q
  valid iff r == x1 mod n
```

**Nonce reuse = total private key leak** (same flaw as RSA-CRT/DSA): if `k` is reused (or biased/predictable, cf. PS3 ECDSA constant `k`) between 2 signatures, `d` can be recovered by simple algebra from `(r,s1,H(m1))` and `(r,s2,H(m2))`.

## Weak-curve & invalid-curve attacks

Before trusting an ECC implementation:

- **Invalid curve attack**: if the code that receives a point doesn't verify that it actually belongs to the expected curve (`y^2 == x^3+ax+b mod p`), an attacker can send a valid point on a *different* curve (same `p`, `a`, but different `b`) chosen to have a small/smooth-order subgroup - the server's response (e.g. an ECDH secret) then leaks the private secret modulo this small order, which can be recombined via CRT by repeating the attack with several small orders. https://research.nccgroup.com/2021/09/17/invalid-curve-attacks-a-practical-approach/
- **Twist security**: even if the points are valid on the correct curve, a non-constant-time implementation can leak information via the "twist" (a twin curve sharing `p`,`a`,`b` with a different order) if it doesn't reject off-curve points early enough.
- **Weak/backdoored curves**: small subgroups, low embedding degree (MOV attack, reducing the DLP to an easier finite field), non-verifiable parameters (cf. Dual_EC_DRBG). Reference for "safe" curves: https://safecurves.cr.yp.to/
- **Timing side-channel**: the naive `scalar_mult` above is *not* constant-time (the `if k & 1` branch leaks the bits of `k` via timing) - avoid this in a real implementation outside of a CTF challenge.