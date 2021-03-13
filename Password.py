from __future__ import print_function
import zipfile
from threading import Thread
import optparse
from math import pow
import sys
 
class Password_cracker:
 
    arr = [' ', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',]
 
    def __init__(self, zipfilename, beg=0, end=None):
        self.maxval = len(self.arr)
        self.beg = beg
        print("beg={}".format(self.beg))
        self.end = end
        self.zfile = zipfile.ZipFile(zipfilename)
        self.log = open("debug.txt", "w");
 
    def findpassword(self):
        i = self.beg
        while self.end == None or i != self.end:
            password = self.int2password(i)
            print("test i={0}, password \"{1}\"".format(i,password),
                  file=self.log)
            self.challengepassword(password)
            i += 1
 
    def int2char(self, i):
        return self.arr[i]
 
    def int2password(self, i):
        password = ""
        while i != 0:
            c = self.int2char(i % self.maxval)
            password += c
            i = i / self.maxval
        return password
 
    def challengepassword(self, password):
        try:
            self.zfile.extractall(pwd=password)
            print("correct password is \"{}\"".format(password),
                  file=self.log)
            exit(0)
        except Exception(e):
            return
 
 
if __name__ == "__main__":
    print(sys.argv)
    if len(sys.argv) < 2 or len(sys.argv) > 3:
        print("Usage: crackit.py passwordfile <password beg>")
        exit(1)
    passwordfile = sys.argv[1]
    beg = 0
    if len(sys.argv) == 3:
        beg = int(sys.argv[2])
    print("beg={}".format(beg))
    password_cracker = Password_cracker(passwordfile, beg=beg)
    password_cracker.findpassword()
