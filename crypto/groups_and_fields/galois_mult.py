def gf_multiply(a, b, modulus=0x11B):
    """Multiply two numbers in GF(2^8) and reduce modulo an irreducible polynomial (AES modulus: x^8 + x^4 + x^3 + x + 1)"""
    result = 0
    while b > 0:
        if b & 1:  # If the lowest bit of b is set
            result ^= a  # XOR with a
        a <<= 1  # Multiply a by x
        if a & 0x100:  # If a is greater than 0xFF, reduce modulo the irreducible polynomial
            a ^= modulus
        b >>= 1  # Shift b to the right
    return result

# Define the values for the multiplication (x^2 + 1) * (x^3 + x + 1)
a = 0x05  # x^2 + 1 in binary is 00000101
b = 0x0B  # x^3 + x + 1

# Perform multiplication in GF(2^8)
gf_multiply_result = gf_multiply(a, b)
print(f"Result in GF(2^8): {gf_multiply_result}")
print(f"Hexadecimal result: {hex(gf_multiply_result)}")
