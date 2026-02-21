## LAMP Server

- https://blog.orange.tw/posts/2024-08-confusion-attacks-en/
- https://www.digitalocean.com/community/tutorials/how-to-install-lamp-stack-on-ubuntu
- https://wiki.archlinux.org/title/Apache_HTTP_Server
- https://wiki.archlinux.org/title/MariaDB
- https://www.noip.com/ #free dns
- https://certbot.eff.org/instructions #free ssl

### Securing LAMP stack

- https://www.linode.com/docs/guides/securing-your-lamp-stack/
- https://github.com/CISOfy/lynis
- https://www.cgsecurity.org/Articles/apache.html
- https://www.cgsecurity.org/Articles/mysql.html
- https://www.cgsecurity.org/Articles/php_limites_du_safemode/index.html

```bash
pacman -S apache php-apache certbot-apache
sudo chown -R http:http /srv/http
```

```bash
# /etc/httpd/conf/httpd.conf
DocumentRoot "/srv/http"
Listen 8000
#Include conf/extra/httpd-userdir.conf
Include conf/vhosts/domainname1.dom
#LoadModule mpm_event_module modules/mod_mpm_event.so
LoadModule mpm_prefork_module modules/mod_mpm_prefork.so
LoadModule php_module modules/libphp.so
AddHandler php-script .php
...
<IfModule unixd_module>
User http
Group http
</IfModule>
<Files ".ht*">
    Require all denied
</Files>

ServerTokens Prod
ServerSignature Off
```

`mariadb-secure-installation`

```bash
# /etc/php/php.ini
[PHP]
extension = mysqlnd.so
extension = pdo.so
extension = pdo_mysql.so

safe_mode = On
expose_php = Off
max_execution_ime = 30
memory_limit = 8M
magic_quotes_gpc = Off
display_errors = Off

disable_functions = exec,system,popen,proc_open,passthru,fsockopen,ftp_connect,ftp_ssl_connect,dl_open,mail
enable_dl = Off
allow_url_fopen = Off
file_uploads = Off

[SQL]
sql.safe_mode = On
```

```bash
# or iptables
sudo ufw enable
sudo ufw allow 8000/tcp
```

```bash
ngrok tcp 8000
sudo systemctl restart httpd
```
