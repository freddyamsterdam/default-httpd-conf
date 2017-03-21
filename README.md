# Default HTTPD configuration for Centos 7

## Prerequisites

### Install dependencies

You'll need Git, HTTPD and Varnish installed.

`yum install git httpd varnish -y`

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

`sed -i 's/example.com/{yourdomain}/g' sites-available/{yourdomain}.conf`

`sed -i 's/IP/{yourdomain}/g' sites-available/{youip}.conf`

### Enable the site

`ln -s sites-available/{yourdomain}.conf sites-enabled/{yourdomain}.conf`

### Restart apache

`service httpd restart`
