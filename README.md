# Default HTTPD configuration for Centos 7, using Varnish and SSL

Setting up HTTPD can be a pain in the sphincter at the best of times. When using Varnish and SSL, the proverbial tends to hit the fan. For this reason, I have set up this repository to help speed up the process, thusly avoiding premature hair loss, accelerated aging and an almost certain perilous death.


## 1 Prerequisites

### 1.1 Relax

Yo, I see you. And I got you. Take it easy, yeah? Light the old fire place and prop your feet up. This should be a right laugh, mate.

### 1.2 Sudo

You will need to be logged in as a sudoer, presumably `root`. Run `su` or `sudo -i` and fill in the correspoding password on prompt.

### 1.3 Install dependencies

You will need Git, HTTPD, mod_ssl, Varnish and Certbot installed.

`yum install git httpd mod_ssl varnish certbot -y`

Open up ports 80 and 443 using the Centos 7 Firewall.

`firewall-cmd --zone=public --permanent --add-service=http`

`firewall-cmd --zone=public --permanent --add-service=https`

`service firewalld restart`

Our HTTPD configuration files assume that Varnish uses port 8080 for the backend and that Varnish itself is listening on port 6081. These are the default Varnish settings, but it can save you a lot of frustation by taking the time to verify these settings in `/etc/varnish/default.vcl` and `/etc/varnish/varnish.params`. Make changes where necessary.

### 1.4 Set permissions

If you have SELinux installed, you will need to modify some settings in order for this to work. If you are unsure as to whether or not you have SELinux installed, simply run:

`yum list installed *selinux*`

If you see `Error: No matching Packages to list`, skip to **1.5 Start and register services**. Otherwise, perform the following steps:

1. Allow HTTPD to use proxy, use the -P flag for persistence:

  `setsebool -P httpd_can_network_connect 1`

2. Allow HTTPD to write to `/var/www/`

  `chcon -t httpd_sys_rw_content_t /var/www/ -R`

3. Make sure HTTPD owns `/var/www/`

  `chown -R apache:apache /var/www`

### 1.5 Start and register services

Start httpd and varnish services and register them to auto start on reboot:

`service httpd start`

`systemctl enable httpd`

`service varnish start`

`systemctl enable varnish`

### 1.6 Deploy key

To be to clone this repository, you'll need to add an SSH key to your server's SSH agent. Please refer to this article for more information:

https://help.github.com/articles/connecting-to-github-with-ssh/


## 2 Do it bro(sephine), do it.

### 2.1 Clone git repo into httpd configuration directory

First of all, change into the HTTPD directory by running `cd /etc/httpd`. Keep in mind that `/etc/httpd` is not an empty directory. For this reason a standard `git clone` will not work, so use the steps below to "clone" our repo:

`git init`

`git remote add origin git@github.com:freddyamsterdam/default-httpd-conf.git`

`git pull origin master`


Alternatively, you could `git clone` into and empty directy and use `mv` to move the repository into the `/etc/httpd`. It is up to you. In my opinion, the method above works best.

### 2.2 Customise configuration

Before we proceed, in the following segments, you will need to replace {yourdomain} and {yourip} with.. well whatever, you got it. The assumption is your are still in `etc/httpd`.

First off, set the correct IP address in the main HTTPD configuration file

`sed -i 's/IP/{yourip}/g' conf/httpd.conf`

Make a copy of the default configuration template:

`cp sites-available/domain.conf.tpl sites-available/{yourdomain}.conf`

Replace `IP` and `example.com` with your server's public ip address and your domain:

`sed -i 's/example.com/{yourdomain}/g' sites-available/{yourdomain}.conf`

`sed -i 's/IP/{yourip}/g' sites-available/{yourip}.conf`

Now create a directory for your web site:

`mkdir /var/www/html/{yourdomain}`

### 2.3 Enable custom configuration

Create a symbolic link to the actual configuration file in `sites-enabled`:

`ln -s sites-available/{yourdomain}.conf sites-enabled/{yourdomain}.conf`

Remove default SSL configuration (very important):

`rm conf.d/ssl.conf`

Restart HTTPD:

`service httpd restart`

### 2.4 Finishing touches

Assuming you have already modified your DNS zonefile to point to your servers public IP address and that your DNS has resolved, you can get a free SSL certificate:

`certbot certonly --webroot -w /var/www/html/{yourdomain} -d {yourdomain}`

Providing everything goes well, please uncomment line 18 in `sites-available/{yourdomain}.conf`, and then uncomment entire virtual host block which listens to port 433.

Restart HTTPD to allow your changes to take effect:

`service httpd restart`

Set up a cronjob to attempt to renew your certbot certificates every days.

`echo "0 0 * * * root certbot renew" >> /etc/crontab`

Run a test to make sure the renewal process actually works

`certbot renew --dry-run`

## 3 Done and dusted

Double click the icon of your favourite web browse and pop over to your domain to verify that it works on both http and https.

Cheers
