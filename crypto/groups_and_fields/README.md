## arithmétique modulaire, Algèbre pour la Cryptographie

### Anneaux

Un **anneau** est une structure algébrique contenant deux opérations (addition et multiplication), où l’addition forme un groupe abélien, la multiplication est associative, et les deux opérations sont liées par la distributivité.

Les entiers modulo `n` forment un anneau noté `Z/nZ`. Cet anneau est un **corps** uniquement si `n` est premier.

Les anneaux sont à la base de nombreuses constructions en cryptographie, y compris dans RSA (qui utilise l'anneau `Z/nZ` aussi noté `F_n`) et dans la construction des corps finis via des anneaux de polynômes.

**Référence :**
-https://www.bibmath.net/ressources/index.php?action=affiche&quoi=mathspe/cours/anneau.html


### Corps finis

Un **corps fini** (ou corps de Galois) est un ensemble fini dans lequel on peut effectuer les opérations +, −, ×, ÷ (sauf par 0), avec les règles usuelles de l’algèbre.

Un corps fini de cardinal `q = p^n` (avec `p` premier, `n ≥ 1`) peut s’écrire :

```
GF(q) ≅ (Z/pZ)[X] / (P[X])
```

où `P(k)` est un polynôme irréductible de degré `n` sur `Z/pZ`.

**Ressources :**
- https://learn-cyber.net/article/Modular-Arithmetic
- https://fr.wikipedia.org/wiki/Corps_fini
- https://αβγ.ελ/math-notes.pdf

---

### RSA : Z/nZ

RSA utilise l’arithmétique modulaire dans l’anneau `Z/nZ`, où `n = p * q` avec `p` et `q` premiers.

Ce n’est pas un corps, mais on travaille dans le groupe multiplicatif des inversibles modulo `n` :
```
(Z/nZ)^*
```

---

### AES : GF(2^8)

- https://en.wikipedia.org/wiki/Finite_field_arithmetic#Rijndael's_(AES)_finite_field

AES repose sur le corps fini `GF(2^8)`, construit comme :

```
GF(2^8) ≅ F_2[x] / (P(x))
```

où `P(x)` est le polynôme irréductible de degré 8:
```
P: X -> X^8 + X^4 + X^3 + X + 1
```

Toutes les opérations sur les octets (addition, multiplication, inversion) sont faites dans ce corps.

- **Addition (XOR)**: `(1 + x + x² + x⁴ + x⁶) + (x⁷ + x + 1) = x⁷ + x⁶ + x⁴ + x²`
  - **Binary operation**: `0b01010111 ⊕ 0b10000011 = 0b11010100`
  - **Hexadecimal operation**: `0x57 ⊕ 0x83 = 0xD4`

- **Multiplication (+ Distributivity)**: `(x² + 1) * (x³ + x + 1) = (x⁵ + x³ + x²) + (x³ + x + 1) = x⁵ + x² + x + 1`
  - **Binary operation**: `0b00000101 * 0b00001011 = 0b00100111`
  - **Hexadecimal operation**: `0x05 * 0x0B = 0x27`

---

### ECDSA : F_p ou F_{2^m}

ECDSA repose sur des courbes elliptiques définies sur un corps fini.

On utilise selon les cas :
- un corps premier `F_p` (avec `p` grand),
- ou un corps binaire `F_{2^m}` pour des implémentations légères.

Les points de la courbe forment un groupe utilisé pour la signature numérique.
