## Doc

https://www.youtube.com/@meichlseder

- https://cryptobook.nakov.com/

- [RSA](https://crypto.stanford.edu/~dabo/pubs/papers/RSA-survey.pdf), 
 https://vozec.fr/crypto-rsa/ , [Side Channel RSA - RSA CRT cf FCSC](https://www.cosade.org/cosade19/cosade14/presentations/session2_b.pdf)

- [DSA,ElGamal, RSA-CRT](https://repo.zenk-security.com/Cryptographie%20.%20Algorithmes%20.%20Steganographie/Cle%20Publique.pdf)

- [Shamir Secret Sharing](https://max.levch.in/post/724289457144070144/shamir-secret-sharing)

- [AES](https://braincoke.fr/blog/2020/08/the-aes-encryption-algorithm-explained/#encryption-algorithm-overview), https://vozec.fr/crypto-aes/ , https://braincoke.fr/blog/2020/08/the-aes-encryption-algorithm-explained/

	- https://stackoverflow.com/questions/1220751/how-to-choose-an-aes-encryption-mode-cbc-ecb-ctr-ocb-cfb

	- https://crypto.stackexchange.com/questions/66085/bit-flipping-attack-on-cbc-mode

	- https://research.nccgroup.com/2021/02/17/cryptopals-exploiting-cbc-padding-oracles/

- https://vozec.fr/crypto-lattice/lattice-introduction/

- [Elliptic Curves](https://people.cs.nctu.edu.tw/~rjchen/ECC2012S/Elliptic%20Curves%20Number%20Theory%20And%20Cryptography%202n.pdf)

## Cheatsheet

- https://github.com/zademn/EverythingCrypto
- https://github.com/jvdsn/crypto-attacks

## Outils

- [z3](https://theory.stanford.edu/~nikolaj/programmingz3.html)
- [OpenSSL cheatsheet](https://www.freecodecamp.org/news/openssl-command-cheatsheet-b441be1e8c4a/)

https://www.login-securite.com/2021/10/29/sthackwriteup-forensic-docker-layer/
```bash
# AES-CBC
openssl aes-256-cbc -d -iter 10 -pass pass:$(cat /pass.txt) -in flag.enc -out flag.dec
```

```
# Base64 & digest - JWT
echo <b64(header).b64(payload)> | openssl dgst -sha256 -mac HMAC -macopt:hexkey:$(cat key.pem | xxd -p | tr -d "\\n")
```

- [Hashes.com](https://hashes.com)
- [Dcode](https://www.dcode.fr/)
- [Cyberchef](https://gchq.github.io/CyberChef/) : Divers encodages/hashs et autres
- [Alpertron](https://www.alpertron.com.ar/ECM.HTM) : RSA (en + de `factordb` et `simpy`)

- https://github.com/tna0y/Python-random-module-cracker

- [Gmpy2](https://gmpy2.readthedocs.io/en/latest/overview.html)
- [Pycryptodome](https://pycryptodome.readthedocs.io/en/latest/src/api.html)
- [Sage (ECC)](https://doc.sagemath.org/html/en/reference/arithmetic_curves/sage/schemes/elliptic_curves/constructor.html)
- [Sympy (docs)](https://docs.sympy.org/latest/modules/polys/reference.html)

## Cours: Cryptohack Starters

![](./warn.png)

Voir:

- `./elliptic_curves`

