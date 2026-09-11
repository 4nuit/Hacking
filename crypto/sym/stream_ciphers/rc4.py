from Crypto.Cipher import ARC4
from Crypto.Hash import SHA256, HMAC
from Crypto.Random import get_random_bytes
import base64

""" Toy functions to play against a modified KSA"""

def reverse_ksa(key: bytes) -> list[int]:
    """Reversed Key Schedule Algorithm"""
    S = list(range(256))
    j = 0
    keylen = len(key)

    for i in range(255, -1, -1):
        j = (j + S[i] + key[i % keylen]) % 256
        S[i], S[j] = S[j], S[i]
    return S


def invert_table(S: list[int]) -> list[int]:
    Sinv = [0] * 256
    for i, v in enumerate(S):
        Sinv[v] = i
    return Sinv


def decrypt_rksa(cipher: bytes, token_hex: str) -> bytes:
    key = bytes.fromhex(token_hex)
    S = reverse_ksa(key)
    Sinv = invert_table(S)
    return bytes(Sinv[b] for b in cipher)


"""Standard RC4 with KSA and PRGA"""

def ksa(key: bytes) -> list[int]:
    """Key Schedule Algorithm"""
    S = list(range(256))
    j = 0
    keylen = len(key)
    for i in range(256):
        j = (j + S[i] + key[i % keylen]) % 256
        S[i], S[j] = S[j], S[i]

    return S


def prga(state: list[int]):
    """Pseudo Random Generator Algorithm"""
    i = 0
    j = 0
    while True:
        i = (i + 1) % 256
        j = (j + state[i]) % 256
        state[i], state[j] = state[j], state[i]
        yield state[(state[i] + state[j]) % 256]


def rc4_crypt(key: bytes, data: bytes) -> bytes:
    """Standard RC4 encrypt/decrypt using the PRGA keystream."""
    S = ksa(key)
    keystream = prga(S)
    return bytes(b ^ next(keystream) for b in data)


if __name__ == "__main__":
    key = b'Very long and confidential key'
    nonce = get_random_bytes(16)
    tempkey = HMAC.new(key, nonce, digestmod=SHA256).digest()
    cipher = ARC4.new(tempkey)
    msg = b'Open the pod bay doors, HAL'
    c1 = nonce + cipher.encrypt(msg)
    c2 = nonce + rc4_crypt(tempkey,msg)
    assert(c1 == c2)
