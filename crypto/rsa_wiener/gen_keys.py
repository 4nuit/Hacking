from Crypto.PublicKey import RSA
from Crypto.Util.number import isPrime
#from ??????? import attack
from gmpy2 import isqrt

def sqrt(n):
        return int(isqrt(n))

## Créer la clé publique pour le challenge

"""
# https://0x90p0wned.wordpress.com/author/0x90p0wned/
n = "??????????????????????????????"
e = "??????????????????????????????"

pub_key = RSA.construct((n, e))
with open('id_rsa.pub','w') as f:
        f.write(pub_key.export_key(format='OpenSSH').decode())
"""

## Importer pub_key sous le format OpenSSH

f = open("id_rsa.pub","r")
key = RSA.import_key(f.read())

print("Recovered (n,e) from id_rsa.pub:")

n = key.n; print("n =", n)
e = key.e; print("e =", e)

##  Implementer cette partie

"""
d,phi = attack(e,n)
p = f(phi,n)
q = f(n,p)
priv_key = RSA.construct((n, e, d, p, q))
with open('id_rsa','w') as g:
        g.write(priv_key.export_key().decode())
"""
