## arithmétique modulaire, Algèbre pour la Cryptographie

### Anneaux

Un **anneau** est une structure algébrique contenant deux opérations (addition et multiplication), où l’addition forme un groupe abélien, la multiplication est associative, et les deux opérations sont liées par la distributivité.

Les entiers modulo `n` forment un anneau noté `Z/nZ`. Cet anneau est un **corps** uniquement si `n` est premier.

Les anneaux sont à la base de nombreuses constructions en cryptographie, y compris dans RSA (qui utilise l'anneau `Z/nZ`) et dans la construction des corps finis via des anneaux de polynômes.

**Référence :**
-https://www.bibmath.net/ressources/index.php?action=affiche&quoi=mathspe/cours/anneau.html


### Corps finis

Un **corps fini** (ou corps de Galois) est un ensemble fini dans lequel on peut effectuer les opérations +, −, ×, ÷ (sauf par 0), avec les règles usuelles de l’algèbre.

Un corps fini de cardinal `q = p^n` (avec `p` premier, `n ≥ 1`) peut s’écrire :

```
F_q ≅ (Z/pZ)[k] / (P(k))
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

AES repose sur le corps fini `GF(2^8)`, construit comme :

```
GF(2^8) ≅ F_2[x] / (P(x))
```

où `P(x)` est un polynôme irréductible de degré 8, par exemple :
```
x^8 + x^4 + x^3 + x + 1
```

Toutes les opérations sur les octets (addition, multiplication, inversion) sont faites dans ce corps.


**Référence :**
https://www-fourier.ujf-grenoble.fr/~parisse/giac/doc/fr/cascmd_fr/cascmd_fr461.html

---

### ECDSA : F_p ou F_{2^m}

ECDSA repose sur des courbes elliptiques définies sur un corps fini.

On utilise selon les cas :
- un corps premier `F_p` (avec `p` grand),
- ou un corps binaire `F_{2^m}` pour des implémentations légères.

Les points de la courbe forment un groupe utilisé pour la signature numérique.
