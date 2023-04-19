# Quelques astuces en ctf

[Méthodes à suivre en CTF](https://blog.reinom.com/securitymethods/)

## Partager des fichiers (réseau privé)

```python
ip -br a ; mkdir secret && cd secret ; python3 -m http.server 8000

#accéder à l'ip de l'interfacehttp://192.168.xx.xx:8080/
```
