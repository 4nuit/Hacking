## Doc Crypto

- https://eprint.iacr.org/
- https://www.schneier.com/
- https://affine.group/writeups
- https://en.wikipedia.org/wiki/Attack_model
- https://github.com/pFarb/awesome-crypto-papers/
- https://en.wikipedia.org/wiki/Padding_(cryptography)
- https://en.wikipedia.org/wiki/Outline_of_cryptography
- https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-78-5.pdf
- https://kirll0s.medium.com/cryptographic-attacks-breaking-security-beyond-the-algorithm-c40b6cb2fcee

## Courses

- https://www.crypto101.io/
- https://toc.cryptobook.us/
- https://cryptobook.nakov.com/
- https://joyofcryptography.com/
- https://crypto.stackexchange.com
- https://cryptohack.gitbook.io/cryptobook/

### Tutorials

- https://vozec.fr/rsa
- https://vozec.fr/aes
- https://vozec.fr/other
- http://theamazingking.com/
- https://github.com/oalieno/Crypto-Course/
- https://github.com/hadipourh/course-cryptanalysis


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

## Tools

- [Cryptsetup](https://wiki.archlinux.org/title/Dm-crypt/Device_encryption)
- [Cupp (interactive wordlist)](https://github.com/Mebus/cupp)
- [Cyberchef](https://gchq.github.io/CyberChef/)
- [Dcode](https://www.dcode.fr/)
- [Pycryptodome](https://pycryptodome.readthedocs.io/en/latest/src/api.html)
- [OpenSSL](https://docs.openssl.org/master/)
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

## Hashs primitives

- [hashing](./hash)


## Secret Key cryptography

- [symmetric cypto](./sym)
- https://en.wikipedia.org/wiki/Authenticated_encryption
- https://en.wikipedia.org/wiki/Advanced_Encryption_Standard
- https://www.ciphermachinesandcryptology.com/en/onetimepad.htm
- https://en.wikipedia.org/wiki/One-time_password

## Public Key cryptography

- [asymmetric crypto](./asym)
- [elliptic_curves](./asym/elliptic_curves)
- https://en.wikipedia.org/wiki/Digital_signature


## Key management

- [active_directory](../windows/active_directory)
- https://web.mit.edu/kerberos/
- https://en.wikipedia.org/wiki/Pre-shared_key
- https://en.wikipedia.org/wiki/Key_distribution
- https://en.wikipedia.org/wiki/Key_exchange
- https://en.wikipedia.org/wiki/Key-agreement_protocol
- https://en.wikipedia.org/wiki/Authentication_protocol
- https://en.wikipedia.org/wiki/Single_sign-on
- https://en.wikipedia.org/wiki/Public_key_infrastructure
- https://github.blog/2023-08-17-mtls-when-certificate-authentication-is-done-wrong/

```txt
When Alice wants to talk to Bob, she first contacts the key server. 
The key server sends Alice a new secret key  KAB plus the key KAB encrypted with Bob’s key KB . 
Both these messages are encrypted with KA , so only Alice can read them. 
Alice sends the message that is encrypted with Bob’s key, called the ticket, to Bob. 
Bob decrypts it and gets KAB, which is now a session key known only to Alice and Bob—and to the key server.
```

#### Post-Quantum Cryptography

What's replacing RSA/ECC for key exchange and signatures once a cryptographically-relevant quantum computer exists (Shor's algorithm breaks both integer factorization and discrete log, so all of RSA/DH/ECDH/ECDSA fall). NIST finalized the first PQC standards in August 2024:

- [FIPS 203 - ML-KEM](https://csrc.nist.gov/pubs/fips/203/final) (based on CRYSTALS-Kyber) - key encapsulation, replaces RSA/ECDH for key exchange
- [FIPS 204 - ML-DSA](https://csrc.nist.gov/pubs/fips/204/final) (based on CRYSTALS-Dilithium) - digital signatures, replaces RSA/ECDSA
- https://en.wikipedia.org/wiki/NTRUEncrypt
- https://csrc.nist.gov/projects/post-quantum-cryptography
- https://en.wikipedia.org/wiki/Post-quantum_cryptography
