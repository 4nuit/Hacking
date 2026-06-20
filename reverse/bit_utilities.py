# https://rosettacode.org/wiki/Bitwise_operations#Python
import zlib

def get_bit(i: signed_integer, x: bit):
	return (i >> x) & 1

def get_masked_value(i: signed_integer, x: bit):
	return i & (1 << x)

def signed2unsigned(i: unsigned_integer, n: bits):
	"""
	# 2^n - j , j = -i > 0
	convert_positive = (1 << n ) + i
	# avoid overflow for positive unsigned integers
	return convert_positive % (1 << n)
	"""
	return i & ((1 << n) - 1)

# prefer using hex values
assert(5 == get_masked_value(5,2) + get_masked_value(5,1) + get_masked_value(5,0) == 4*get_bit(5,2) + 2*get_bit(5,1) + 1*get_bit(5,0) == 0b101)
assert((signed2unsigned(-12,8) + 12) % (1<<8) == 0)

##### SHIFTS #####

def rol_n(i: signed_integer, r: rotations, n: bits):
	i = signed2unsigned(i, n); r = r % n
	mask = (1 << n) - 1
	num1 = (i << r) & mask
	num2 = (i >> (n - r)) & mask
	return num1 | num2

def ror_n(i: signed_integer, r: rotations, n: bits):
	i = signed2unsigned(i, n); r = r % n
	mask = (1 << n) - 1
	num1 = (i >> r) & mask
	num2 = (i << (n - r)) & mask
	return num1 | num2

##### CRC32 #####

def create_table():
    a = []
    for i in range(256):
        k = i
        for j in range(8):
            if k & 1:
                k ^= 0x1db710640
            k >>= 1
        a.append(k)
    return a

def crc_update(buf, crc):
    crc ^= 0xffffffff
    for k in buf:
        crc = (crc >> 8) ^ crc_table[(crc & 0xff) ^ k]
    return crc ^ 0xffffffff


def CRC32(s):
	return hex(zlib.crc32(s.encode()))

string = "The quick brown fox jumps over the lazy dog"
crc_table = create_table()
enc1 = hex(crc_update(string.encode(), 0))
enc2 = CRC32(string)

assert(enc1 == enc2)
