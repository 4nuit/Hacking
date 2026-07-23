## Modular arithmetic, Algebra for Cryptography

### Rings

A **ring** is an algebraic structure containing two operations (addition and multiplication), where addition forms an abelian group, multiplication is associative, and the two operations are linked by distributivity.

The integers modulo `n` form a ring denoted `Z/nZ`. This ring is a **field** only if `n` is prime.

Rings are the basis of many constructions in cryptography, including in RSA (which uses the ring `Z/nZ` also denoted `F_n`) and in the construction of finite fields via polynomial rings.

**Reference:**
-https://www.bibmath.net/ressources/index.php?action=affiche&quoi=mathspe/cours/anneau.html


### Finite fields

A **finite field** (or Galois field) is a finite set in which the operations +, −, ×, ÷ (except by 0) can be performed, with the usual rules of algebra.

A finite field of cardinality `q = p^n` (with `p` prime, `n ≥ 1`) can be written:

```
GF(q) ≅ (Z/pZ)[X] / (P[X])
```

where `P(k)` is an irreducible polynomial of degree `n` over `Z/pZ`.

**Resources:**
- https://learn-cyber.net/article/Modular-Arithmetic
- https://fr.wikipedia.org/wiki/Corps_fini
- https://αβγ.ελ/math-notes.pdf

---

### RSA: Z/nZ

RSA uses modular arithmetic in the ring `Z/nZ`, where `n = p * q` with `p` and `q` prime.

This is not a field, but we work in the multiplicative group of units modulo `n`:
```
(Z/nZ)^*
```

---

### AES: GF(2^8)

- https://en.wikipedia.org/wiki/Finite_field_arithmetic#Rijndael's_(AES)_finite_field

AES relies on the finite field `GF(2^8)`, constructed as:

```
GF(2^8) ≅ F_2[x] / (P(x))
```

where `P(x)` is the irreducible polynomial of degree 8:
```
P: X -> X^8 + X^4 + X^3 + X + 1
```

All operations on bytes (addition, multiplication, inversion) are performed in this field.

- **Addition (XOR)**: `(1 + x + x² + x⁴ + x⁶) + (x⁷ + x + 1) = x⁷ + x⁶ + x⁴ + x²`
  - **Binary operation**: `0b01010111 ⊕ 0b10000011 = 0b11010100`
  - **Hexadecimal operation**: `0x57 ⊕ 0x83 = 0xD4`

- **Multiplication (+ Distributivity)**: `(x² + 1) * (x³ + x + 1) = (x⁵ + x³ + x²) + (x³ + x + 1) = x⁵ + x² + x + 1`
  - **Binary operation**: `0b00000101 * 0b00001011 = 0b00100111`
  - **Hexadecimal operation**: `0x05 * 0x0B = 0x27`

---

### ECDSA: F_p or F_{2^m}

ECDSA relies on elliptic curves defined over a finite field.

Depending on the case, we use:
- a prime field `F_p` (with large `p`),
- or a binary field `F_{2^m}` for lightweight implementations.

The points of the curve form a group used for digital signatures.
