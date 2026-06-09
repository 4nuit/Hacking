## Web - README

- [client](./client)
- [server](./server)
- https://gf.dev/learn/
- https://cyber.gouv.fr/publications/securiser-un-site-web
- https://en.wikipedia.org/wiki/Portable_character_set

### Cheatsheets

- https://websecblog.com/cheatsheet/
- https://book.hacktricks.xyz/welcome/readme
- https://github.com/swisskyrepo/PayloadsAllTheThings
- https://github.com/w181496/Web-CTF-Cheatsheet

## HTTP requests

- https://developer.mozilla.org/en-US/docs/Web/HTTP
- https://www.w3schools.com/tags/ref_httpmethods.asp
- https://www.geeksforgeeks.org/php/difference-between-http-get-and-post-methods/

```txt
- POST requests are never cached
- POST requests have no restrictions on data length
- POST is a little safer than GET because the parameters are not stored in browser history or in web server logs (by default)
```

### Curl

- https://curl.se/docs/httpscripting.html
- https://everything.curl.dev/http/post/postvspost.html


```txt
-d/--data-... = Content-Type: application/x-www-form-urlencoded
-F/--form-... = Content-Type: multipart/form-data


# avoid escaping special chars

--data-raw
--form-string
```

### Devtools

- https://firefox-source-docs.mozilla.org/devtools-user/    # ff`Network->Right Click -> Edit & Resend`
- https://github.com/jaredwilli/devtools-cheatsheet         #chrome

### Extensions

- https://portswigger.net/burp/documentation/desktop/external-browser-config/certificate # Installing burp certificate for any browser with foxyproxy (intercepting https)

#### Firefox

- [Hacktools](https://addons.mozilla.org/fr/firefox/addon/hacktools/)
- [Wappalyzer](https://addons.mozilla.org/fr/firefox/addon/wappalyzer/) (**Techno discovery** : Java -> /actuator; /metrics)
- [FoxyProxy](https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/) (Forwarding to **Burp Suite** (port 8080))
- [Retire.js](https://addons.mozilla.org/fr/firefox/addon/retire-js/)
- [Shodan](https://addons.mozilla.org/en-US/firefox/addon/shodan-addon/)

#### Chrome (only)

- [Shodan](https://chromewebstore.google.com/detail/shodan/jjalcfnidlmpjhdfepjhjbhnhkbgleap)
- [Tempmail](https://chromewebstore.google.com/detail/temp-mail-disposable-temp/inojafojbhdpnehkhhfjalgjjobnhomj)
- https://github.com/trufflesecurity/Trufflehog-Chrome-Extension

#### Any browser

- https://github.com/davtur19/DotGit, [git-dumper](https://github.com/arthaud/git-dumper) once a repo is detected
- https://github.com/RetireJS/retire.js
- https://github.com/tomnomnom/wappalyzer
- https://github.com/kevin-mizu/domloggerpp
- https://github.com/ElSicarius/findalllinks
- https://github.com/foxyproxy/browser-extension

#### Burp

- [Bypass WAF](https://portswigger.net/bappstore/ae2611da3bbc4687953a1f4ba6a4e04c)
- [Hackvertor](https://github.com/hackvertor/hackvertor)
- [JWT](https://portswigger.net/bappstore/f923cbf91698420890354c1d8958fee6)
- [JWT Editor](https://portswigger.net/bappstore/26aaa5ded2f74beea19e2ed8345a93dd)
- [Param Miner](https://github.com/portswigger/param-miner)
- https://github.com/snoopysecurity/awesome-burp-extensions

## Challenges

- https://portswigger.net/web-security/
- https://alert.zeyu2001.com/
- https://github.com/Learn-by-doing/xss
- https://github.com/Learn-by-doing/sql-injection
- https://www.nzeros.me/2023/08/07/securinetsminictf2k22/

### Unsecure website in Docker containers

- https://devdocs.io/
- https://docs.docker.com/samples/react/
