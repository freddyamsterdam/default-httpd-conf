# Default HTTPD configuration for Centos 7

## Prerequisites

### Install dependencies
You'll need Git, HTTPD and Varnish installed.

`yum install git httpd varnish -y`

### Deploy key
To be to clone this repository, you'll need to add an SSH key to your server. Please also add this deploy key under Settings > Deploy Keys.

## Apply config

`cd /etc/httpd`

`git init`

`git remote add origin git@github.com:freddyamsterdam/default-httpd-conf.git`

`git pull origin master`
