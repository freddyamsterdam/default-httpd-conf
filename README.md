# Default HTTPD configuration for Centos 7

## Prerequisites

### Install dependencies

You'll need Git, HTTPD, mod_ssl, Varnish and Certbot installed.

`yum install git httpd mod_ssl varnish certbot -y`

Make sure the Centos 7 firewall will allow http and https connections

`firewall-cmd --zone=public --permanent --add-service=http`

`firewall-cmd --zone=public --permanent --add-service=https`

`service firewalld restart`

If you have SELinux installed, you will need to allow HTTPD to use proxy. Use the -P flag for persistence:

`setsebool -P httpd_can_network_connect 1`

Start httpd and varnish services and register them to auto start on reboot:

`service httpd start`

`systemctl enable httpd`

`service varnish start`

`systemctl enable varnish`

### Deploy key

To be to clone this repository, you'll need to add an SSH key to your server. Please also add this deploy key under Settings > Deploy Keys.

## Do it bro(sephine), do it.

### Clone git repo into httpd configuration directory

First of all, change into the HTTPD directory:

`cd /etc/httpd`

As `/etc/httpd` is not an empty directory, a standard `git clone` will not work, so use the steps below to "clone" our repo:

`git init`

`git remote add origin git@github.com:freddyamsterdam/default-httpd-conf.git`

`git pull origin master`

Alternatively, you could `git clone` into and empty directy and use `mv` to move the repository into the `/etc/httpd`. It is up to you. In my opinion, the method above works best.

### Customise configuration

Before we proceed, in the following segments, you will need to replace {yourdomain} and {yourip} with.. well whatever, you got it. The assumption is your are still in `etc/httpd`.

Make a copy of the default configuration template:

`cp sites-available/domain.conf.tpl sites-available/{yourdomain}.conf`

Replace IP and www.example.com with your server's public ip address and your domain:

`sed -i 's/www.example.com/{yourdomain}/g' sites-available/{yourdomain}.conf`

`sed -i 's/IP/{yourdomain}/g' sites-available/{youip}.conf`

### Enable custom configuration

Create a symbolic link to the actual configuration file in `sites-enabled`:

`ln -s sites-available/{yourdomain}.conf sites-enabled/{yourdomain}.conf`

Remove default SSL configuration:

`rm conf.d/ssl.conf`

Restart HTTPD:

`service httpd restart`


