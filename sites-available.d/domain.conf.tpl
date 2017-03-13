#
# dutchstrength.com | PRODUCTION
#

# Redirect everything except Let's Encrypt Certificate renewal challenges to https://
<VirtualHost 37.97.235.184:80 >

  ServerName www.dutchstrength.com
  ServerAdmin hi@freddydenoord.nl
  ServerAlias www.dutchstrength.com dutchstrength.com

  DocumentRoot /var/www/html/dutchstrength/production
  <Directory "/var/www/html/dutchstrength/production">
    AllowOverride AuthConfig FileInfo Indexes Limit Options=Indexes,Includes,IncludesNOEXEC,MultiViews,SymLinksIfOwnerMatch,FollowSymLinks,None
    Require all granted
  </Directory>

  RedirectMatch permanent ^(?!/\.well-known/acme-challenge/).* https://www.dutchstrength.com$0

</VirtualHost>

# SSL and proxy to Varnish at :6081
<VirtualHost 37.97.235.184:443 >

  SSLEngine on
  SSLCertificateFile /etc/letsencrypt/live/www.dutchstrength.com-0001/cert.pem
  SSLCertificateKeyFile /etc/letsencrypt/live/www.dutchstrength.com-0001/privkey.pem
  SSLCertificateChainFile /etc/letsencrypt/live/www.dutchstrength.com-0001/chain.pem

  ServerName www.dutchstrength.com
  ServerAdmin hi@freddydenoord.nl
  ServerAlias www.dutchstrength.com dutchstrength.com

  <Proxy *>
    Require all granted
  </Proxy>

  ProxyRequests Off
  ProxyPreserveHost On
  ProxyPass / http://127.0.0.1:6081/
  RequestHeader set X-Forwarded-Port "443"
  RequestHeader set X-Forwarded-Proto "https"

  RewriteEngine on
  RewriteCond %{HTTP_HOST} !^www\.
  RewriteRule ^ https://www.%{HTTP_HOST}%{REQUEST_URI} [R=301,L]

</VirtualHost>

# Serve site
<VirtualHost 127.0.0.1:8080 >

  ServerName www.dutchstrength.com
  ServerAdmin hi@freddydenoord.nl
  ServerAlias www.dutchstrength.com dutchstrength.com

  DocumentRoot /var/www/html/dutchstrength/production
  
  <Directory "/var/www/html/dutchstrength/production">
    AllowOverride AuthConfig FileInfo Indexes Limit Options=Indexes,Includes,IncludesNOEXEC,MultiViews,SymLinksIfOwnerMatch,FollowSymLinks,None
    Require all granted
  </Directory>

  php_flag opcache on

</VirtualHost>


#
# acceptance.dutchstrength.com | STAGING with Varnish
#

# Redirect everything except Let's Encrypt Certificate renewal challenges to https://
<VirtualHost 37.97.235.184:80 >

  ServerName acceptance.dutchstrength.com
  ServerAdmin hi@freddydenoord.nl

  DocumentRoot /var/www/html/dutchstrength/acceptance
  <Directory "/var/www/html/dutchstrength/acceptance">
    AllowOverride AuthConfig FileInfo Indexes Limit Options=Indexes,Includes,IncludesNOEXEC,MultiViews,SymLinksIfOwnerMatch,FollowSymLinks,None
    Require all granted
  </Directory>

  RedirectMatch permanent ^(?!/\.well-known/acme-challenge/).* https://acceptance.dutchstrength.com$0

</VirtualHost>

<VirtualHost 37.97.235.184:443 >

  SSLEngine on
  SSLCertificateFile /etc/letsencrypt/live/acceptance.dutchstrength.com/cert.pem
  SSLCertificateKeyFile /etc/letsencrypt/live/acceptance.dutchstrength.com/privkey.pem
  SSLCertificateChainFile /etc/letsencrypt/live/acceptance.dutchstrength.com/chain.pem

  ServerName acceptance.dutchstrength.com
  ServerAdmin hi@freddydenoord.nl
  
  <Proxy *>
    Require all granted
  </Proxy>

  ProxyRequests Off
  ProxyPreserveHost On
  ProxyPass / http://127.0.0.1:6081/
  RequestHeader set X-Forwarded-Port "443"
  RequestHeader set X-Forwarded-Proto "https"

</VirtualHost>


# Serve site
<VirtualHost 127.0.0.1:8080 >

  ServerName acceptance.dutchstrength.com
  ServerAdmin hi@freddydenoord.nl
  
  DocumentRoot /var/www/html/dutchstrength/acceptance

  <Directory "/var/www/html/dutchstrength/acceptance">
    AllowOverride AuthConfig FileInfo Indexes Limit Options=Indexes,Includes,IncludesNOEXEC,MultiViews,SymLinksIfOwnerMatch,FollowSymLinks,None
    Require all granted
  </Directory>

  php_flag opcache on

</VirtualHost>


#
# testing.dutchstrength.com | TESTING without Varnish
#

# Redirect everything except Let's Encrypt Certificate renewal challenges to https://
<VirtualHost 37.97.235.184:80 >

  ServerName testing.dutchstrength.com
  ServerAdmin hi@freddydenoord.nl

  DocumentRoot /var/www/html/dutchstrength/testing
  
  <Directory "/var/www/html/dutchstrength/testing">
    AllowOverride AuthConfig FileInfo Indexes Limit Options=Indexes,Includes,IncludesNOEXEC,MultiViews,SymLinksIfOwnerMatch,FollowSymLinks,None
    Require all granted
  </Directory>

  RedirectMatch permanent ^(?!/\.well-known/acme-challenge/).* https://testing.dutchstrength.com$0

</VirtualHost>

# Serve site
<VirtualHost 37.97.235.184:443 >

  SSLEngine on
  SSLCertificateFile /etc/letsencrypt/live/testing.dutchstrength.com/cert.pem
  SSLCertificateKeyFile /etc/letsencrypt/live/testing.dutchstrength.com/privkey.pem
  SSLCertificateChainFile /etc/letsencrypt/live/testing.dutchstrength.com/chain.pem

  ServerName testing.dutchstrength.com
  ServerAdmin hi@freddydenoord.nl

  DocumentRoot /var/www/html/dutchstrength/testing
  
  <Directory "/var/www/html/dutchstrength/testing">
    AllowOverride AuthConfig FileInfo Indexes Limit Options=Indexes,Includes,IncludesNOEXEC,MultiViews,SymLinksIfOwnerMatch,FollowSymLinks,None
    Require all granted
  </Directory>

  php_flag opcache off

</VirtualHost>
