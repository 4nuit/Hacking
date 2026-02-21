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
- https://messervices.cyber.gouv.fr/guides/mecanismes-cryptographiques
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
- https://github.com/elliptic-shiho/crypto_misc/
- https://www.freecodecamp.org/news/openssl-command-cheatsheet-b441be1e8c4a/

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

- [Cryptsetup](https://wiki.archlinux.org/title/Dm-crypt/Device_encryption)
- [Cupp (interactive wordlist)](https://github.com/Mebus/cupp)
- [Cyberchef](https://gchq.github.io/CyberChef/)
- [Pycryptodome](https://pycryptodome.readthedocs.io/en/latest/src/api.html)
- [Sage Cell Server (Online)](https://sagecell.sagemath.org/)
- [Sympy (docs)](https://docs.sympy.org/latest/modules/polys/reference.html)
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

# using big endia
number = bytes_to_long(b"Testing bytes to long conversion")
assert(long_to_bytes(number) == bytes.fromhex(hex(number)[2:]))

# using little endian
number = int.from_bytes(b"Testing bytes to long conversion", "little")
signature = pow(number,d,n).to_bytes(256, "little")
```

## Private Key cryptography

- [symmetric cypto](./sym)
- https://en.wikipedia.org/wiki/Advanced_Encryption_Standard

## Public Key cryptography

- [asymmetric crypto](./asym)
- https://en.wikipedia.org/wiki/Euler's_theorem

## Hashs primitives

- [hashing](./hash)

## Key management

- [active_directory](../windows/active_directory)
- https://web.mit.edu/kerberos/			# Key Server (KDC)
- https://en.wikipedia.org/wiki/Public_key_infrastructure
- https://github.blog/2023-08-17-mtls-when-certificate-authentication-is-done-wrong/

```txt
When Alice wants to talk to Bob, she first contacts the key server. 
The key server sends Alice a new secret key  KAB plus the key KAB encrypted with Bob’s key KB . 
Both these messages are encrypted with KA , so only Alice can read them. 
Alice sends the message that is encrypted with Bob’s key, called the ticket, to Bob. 
Bob decrypts it and gets KAB, which is now a session key known only to Alice and Bob—and to the key server.
```

### ECC

- [elliptic_curves](./asym/elliptic_curves)
- https://en.wikipedia.org/wiki/Fermat%27s_little_theorem

### SSL

- https://crt.sh
- https://security.stackexchange.com/questions/20803/how-does-ssl-tls-work
