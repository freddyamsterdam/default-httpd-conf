#
# DOMAIN | PRODUCTION
#

# Redirect everything except Let's Encrypt Certificate renewal challenges to https://
<VirtualHost IP:80 >

  ServerName DOMAIN
  ServerAdmin EMAIL
  ServerAlias www.DOMAIN DOMAIN

  DocumentRoot /var/www/html/DOMAIN/production
  <Directory "/var/www/html/DOMAIN/production">
    AllowOverride AuthConfig FileInfo Indexes Limit Options=Indexes,Includes,IncludesNOEXEC,MultiViews,SymLinksIfOwnerMatch,FollowSymLinks,None
    Require all granted
  </Directory>

  #RedirectMatch permanent ^(?!/\.well-known/acme-challenge/).* https://www.DOMAIN$0

</VirtualHost>

# SSL and proxy to Varnish at :6081
#<VirtualHost IP:443 >
#
#  SSLEngine on
#  SSLCertificateFile /etc/letsencrypt/live/www.DOMAIN/cert.pem
#  SSLCertificateKeyFile /etc/letsencrypt/live/www.DOMAIN/privkey.pem
#  SSLCertificateChainFile /etc/letsencrypt/live/www.DOMAIN/chain.pem
#
#  ServerName www.DOMAIN
#  ServerAdmin EMAIL
#  ServerAlias www.DOMAIN DOMAIN
#
#  <Proxy *>
#    Require all granted
#  </Proxy>
#
#  ProxyRequests Off
#  ProxyPreserveHost On
#  ProxyPass / http://127.0.0.1:6081/
#  RequestHeader set X-Forwarded-Port "443"
#  RequestHeader set X-Forwarded-Proto "https"
#
#  RewriteEngine on
#  RewriteCond %{HTTP_HOST} !^www\.
#  RewriteRule ^ https://www.%{HTTP_HOST}%{REQUEST_URI} [R=301,L]
#
#</VirtualHost>

# Serve site
<VirtualHost 127.0.0.1:8080 >

  ServerName www.DOMAIN
  ServerAdmin EMAIL
  ServerAlias www.DOMAIN DOMAIN

  DocumentRoot /var/www/html/DOMAIN/production
  
  <Directory "/var/www/html/DOMAIN/production">
    AllowOverride AuthConfig FileInfo Indexes Limit Options=Indexes,Includes,IncludesNOEXEC,MultiViews,SymLinksIfOwnerMatch,FollowSymLinks,None
    Require all granted
  </Directory>

  php_flag opcache on

</VirtualHost>
