from Crypto.PublicKey import RSA
from Crypto.Util.number import isPrime
from owiener import attack
from gmpy2 import isqrt

def sqrt(n):
        return int(isqrt(n))

f = open("id_rsa.pub","r")
key = RSA.import_key(f.read())

n = key.n
e = key.e

"""
Modifier la fin de `owiener.py`

return dg // g, phi
"""

d,phi = attack(e,n)
p = (sqrt(n*n - 2*n*(phi+1) + (phi-1)**2) + n - phi + 1)//2
q = n//p
priv_key = RSA.construct((n, e, d, p, q))
with open('id_rsa','w') as g:
	g.write(priv_key.export_key().decode())

