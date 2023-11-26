# Wiener Attack - @Night (4nuit)

Le but de ce challenge est de reconstruire la clé privée à l'aide de l'attaque de Wiener.

Le challenger doit :

- d'abord lire la clé publique, 

- utiliser les fractions continues pour trouver d et phi (en bruteforçant)

- résoudre une équation du second degré connaissant alors n et phi

- se connecter au docker pour lire `flag.txt` 

## Setup

```bash
docker-compose up
```

```bash
ngrok tcp 22
ssh -p 1???? dockeruser@?.tcp.eu.ngrok.io
```

## Challenge

```bash
python gen_keys.py
```

## Solution

```bash
python sol.py
```

## Nettoyage

```bash
./clean.sh
```
