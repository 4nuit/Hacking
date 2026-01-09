# PHP
 
```php
#https://onlinephp.io/
$a = 1;
var_dump("$a" === "".$a."");
var_dump("$a" === '$a');
```

## Type Juggling

- https://github.com/spaze/hashes
- https://web.archive.org/web/20240217231140/https://owasp.org/www-pdf-archive/PHPMagicTricks-TypeJuggling.pdf

## Bypass `disable_functions` and `open_basedir`

- https://github.com/TarlogicSecurity/Chankro

### CGI

- https://devco.re/blog/2024/06/06/security-alert-cve-2024-4577-php-cgi-argument-injection-vulnerability-en/
- https://github.com/BorelEnzo/FuckFastcgi

`Protection`:

- https://stackoverflow.com/questions/1271899/disable-php-in-directory-including-all-sub-directories-with-htaccess

```php
#.htaccess
php_flag engine off
```

## Bypass `preg_match(" | _/")`:

- https://ctftime.org/writeup/11535

## Bypass filters

### Php filters

- https://pwning.systems/posts/php_filter_var_shenanigans/
- https://www.synacktiv.com/publications/php-filters-chain-what-is-it-and-how-to-use-it.html

### Eval

- https://blog.csdn.net/xhy18634297976/article/details/123148026
- https://www.secjuice.com/php-rce-bypass-filters-sanitization-waf/
- https://www.defenxor.com/blog/writing-simple-php-non-alphanumeric-backdoor-to-evade-waf/

### Extract & RCE 

- https://borelenzo.github.io/stuff/2023/10/31/hidden-in-plain-sight.html

### Phar - File Uploade to RCE

- https://github.com/php/php-src/security/advisories/GHSA-jqcx-ccgc-xwhv
