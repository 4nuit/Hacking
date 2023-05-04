# Cryptohack Starters

On aura besoin de `Sage`:

```bash
sudo apt install sagemath
```

Voir : https://fr.wikipedia.org/wiki/Courbe_elliptique pour les définitions.

Des points sont présents sur une courbe elliptique d’équation $$(E) : y2 = x3 + ax + b[p]$$ (équation de Weierstrass)

## Point Negation

On se sert de 2 propriétés pour trouver Q tel que `P + Q = 0` (inverse de P pour `+`):

- E est un groupe **cyclique**
- L’**ordre** de (E) , k, est un nombre **non premier**

```python
from Crypto.Util.number import long_to_bytes
from sage.all import *

p = 9739
a = 497
b = 1768

K = GF(p)
E = EllipticCurve([K(a), K(b)])

P = E(8045,6936)

k = E.order() #premier
h = (k + 1) // -1 #inverse de k dans E (modulo -1)

Q = P * h; print(Q) #-P
```

## Point Addition
