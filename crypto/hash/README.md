## Hashs

- https://security.stackexchange.com/questions/211/how-to-securely-hash-passwords
- https://stackoverflow.com/questions/401656/secure-hash-and-salt-for-php-passwords
- https://cyber.gouv.fr/sites/default/files/2021/03/anssi-guide-selection_crypto-1.0.pdf

### Password hashing

A general-purpose hash (MD5/SHA-family/SHA-3, all built for speed) is the **wrong** primitive for passwords - use a dedicated, deliberately slow/memory-hard KDF instead:

- [Argon2](https://en.wikipedia.org/wiki/Argon2) (OWASP's current default recommendation, `argon2id` variant)
- [bcrypt](https://en.wikipedia.org/wiki/Bcrypt), [scrypt](https://en.wikipedia.org/wiki/Scrypt) - older but still acceptable alternatives
- https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html

### Hash length extension

- https://crypto.stackexchange.com/questions/3978/understanding-the-length-extension-attack
- https://tipi-hack.github.io/2018/04/01/quals-NDH-18-Wawacoin.html
- https://github.com/stephenbradshaw/hlextend

**This isn't a "broken hash" problem**: any hash built on the [Merkle-Damgård construction](https://en.wikipedia.org/wiki/Merkle%E2%80%93Damg%C3%A5rd_construction) is vulnerable - that includes **MD5, SHA-1, and SHA-256/SHA-512** (all Merkle-Damgård). It has nothing to do with collision resistance being broken; it's a structural property of the construction (the hash is just the final internal state, so anyone can resume hashing from it without knowing the original message). **SHA-3/Keccak** uses a different construction (a sponge, [FIPS 202](https://csrc.nist.gov/pubs/fips/202/final)) and is *not* vulnerable to this attack.

#### MD4

- https://github.com/JorianWoltjer/Cryptopals/blob/master/set4/30.py

#### MD5

- https://web.archive.org/web/20120725115432/http://www.ghostsinthestack.org/article-22-exploitation-des-collisions-md5.html

#### Sha1

- https://malicioussha1.github.io/
- https://github.com/JorianWoltjer/Cryptopals/blob/master/set4/29.py


### Authenticated encryption

- https://en.wikipedia.org/wiki/Message_authentication_code
- https://en.wikipedia.org/wiki/CBC-MAC
- https://en.wikipedia.org/wiki/HMAC
