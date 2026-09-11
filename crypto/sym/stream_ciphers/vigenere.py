#!/usr/bin/python

import argparse, string

def vigenere(msg, key, decrypt = False):
    msg = list(msg); key = list(key)
    ki = 0

    for i in range(len(msg)):
        if msg[i].isalpha() and msg[i] in string.printable:
            k = ord(key[ki % len(key)].lower()) - ord('a')

            if decrypt:
                k = -k

            if 'a' <= msg[i] <= 'z':
                msg[i] = chr( ((ord(msg[i]) - ord('a')) + k) % 26 + ord('a'))

            if 'A' <= msg[i] <= 'Z':
                msg[i] = chr( ((ord(msg[i]) - ord('A')) + k) % 26 + ord('A'))

            ki += 1

        else:
            pass

    return "".join(msg)

def caesar(msg):
    key = []
    for i in range(len(msg)):
        key.append("n" if msg[i].islower() else "N")
    return vigenere(msg, key)


test = "do you like pasta OR NOT?"; key = "catrulez"

assert test == vigenere(vigenere(test,key),key,decrypt = True)
assert test == caesar(caesar(test))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog='vigenere (bellaso) tool', usage='%(prog)s [caesar] [vigenere encryption] [vigenere decrypt]')

    parser.add_argument('--caesar', help='encrypt/decrypt using caesar')
    parser.add_argument('-e','--vige', help='encrypt using vigenere')
    parser.add_argument('-d','--vigd', help='decrypt using vigenere')
    parser.add_argument('-k','--key', required=False, help='vigenere key')

    args = parser.parse_args()
    if args.caesar:
        print(caesar(args.caesar))

    if (args.vige or args.vigd) and not args.key:
        parser.error("--key is required for --vige/--vigd")

    if args.vige is not None:
        print(vigenere(args.vige, args.key, decrypt=False))

    if args.vigd is not None:
        print(vigenere(args.vigd, args.key, decrypt=True))
