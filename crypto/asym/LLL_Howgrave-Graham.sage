from sage.all import *
from Crypto.Util.number import *

p = getPrime(512)
q = getPrime(512)

n = p * q

x = ZZ(randint(0, 2**75))
y = ZZ(randint(0, 2**75))

a = ZZ(randint(0, 2**300))
c = p - (a*x)

b = ZZ(randint(0, 2**300))
d = q - (b*y)


print(f"{n=}")

print(f"{a=}")
print(f"{b=}")
print(f"{c=}")
print(f"{d=}")

assert (a*x + c)*(b*y + d) == n

print("Howgrave Graham")

# a*x + c == 0  (mod p)

"""
f = x + c/a  # Must be monic
t = c/a
t,x = polygens(ZZ, "t,x")


f^1 = t + x
f^2 = t^2 + 2*t*x + x^2
f^3 = t^3 + 3*t^2*x + 3*t*x^2 + x^3
f^4 = t^4 + 4*t^3*x + 6*t^2*x^2 + 4*t*x^3 + x^4
"""

t = c*inverse_mod(a, n) % n
X = 2**75  # Used for weighting in LLL
M = matrix(ZZ, [
    [n, 0, 0],
    [t, X, 0],
    [t^2, 2*t*X, X^2],
])
M = M.LLL()

# Solve small polynomial over integers
x_ = polygen(ZZ, "x")
row = M[0]
g = sum(row[j]//X^j*x_^j for j in range(len(row)))
for root, _ in g.roots():
    print(root)
    assert root == x
    assert p == a*x+c
