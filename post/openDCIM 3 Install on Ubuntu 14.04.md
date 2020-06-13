---
title: openDCIM 3 Install on Ubuntu 14.04
date: 2016-03-03
tags: [Linux, Ubuntu, openDCIM]
---

[中文版链接]([https://kenmlai.me/cn/posts/%E5%A6%82%E4%BD%95%E5%9C%A8Ubuntu-14.04%E4%B8%8A%E5%AE%89%E8%A3%85openDCIM-3/](https://kenmlai.me/cn/posts/如何在Ubuntu-14.04上安装openDCIM-3/))

# What is openDCIM

openDCIM is a free web-based Data Center Infrastructure Management application. DCIM means many different things to many different people, and there is a multitude of commercial applications available.

The number one goal for openDCIM is to eliminate the excuse for anybody to ever track their data center inventory using a spreadsheet or word processing document again.


# installation


## Install Apache, PHP, MySQL

Thanks to apt, This step is incredibly easy.

```bash
sudo apt-get install apache2 php5 mysql-server
```

Please choose a fast source server for yourself, or the wait time would be long. 🙂


## Enable https

First, we have to enable SSL.

```bash
sudo a2enmod ssl
```

We need to create key and certificate for user authentication. Please remind that we should put those files out of web folder to prevent downloading from browser. I simply put them in the home folder.

```bash
$ cd ~
$ openssl genrsa -out ca.key 1024
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:US
State or Province Name (full name) [Some-State]:New York
Locality Name (eg, city) []:NYC
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Awesome Inc
Organizational Unit Name (eg, section) []:Dept of Merriment
Common Name (e.g. server FQDN or YOUR name) []:example.com
Email Address []:webmaster@awesomeinc.com
$ openssl req -new -key ca.key -out ca.csr
$ openssl x509 -req -days 365 -in ca.csr -signkey ca.key -out ca.crt
```


## Set Up the Certificate

Now we have all of the required components of the finished certificate.The next thing to do is to set up the virtual hosts to display the new certificate. Open up the SSL config file:

```bash
nano /etc/apache2/sites-available/default-ssl
```

Within the section that begins with, quickly make the following changes. Add a line to your server name right below the Server Admin email:

```bash
ServerName example.com:443
```

Replace example.com with your DNS approved domain name or server IP address (it should be the same as the common name on the certificate). Find the following three lines, and make sure that they match the extensions below:

```bash
SSLEngine on
SSLCertificateFile ~/apache.crt
SSLCertificateKeyFile ~/apache.key
```

Save and Exit out of the file.


## Activate the New Virtual Host

Before the website that will come on the 443 port can be activated, we need to enable that Virtual Host:

```bash
sudo a2ensite default-ssl
```

You are all set. Restarting your Apache server will reload it with all of your changes in place.

```bash
sudo service apache2 reload
```

In your browser, type [https://youraddress](https://youraddress), and you will be able to see the new certificate.


## Enable user authentication

You have protected the openDCIM web directory with a requirement for Basic authentication, with the lines already added in your Apache configuration file above.
 Now, to create at least on user, do:

```bash
touch /var/www/.htpasswd
htpasswd /var/www/.htpasswd Administrator
```

You will be asked for a password for user “Administrator” twice.


## Install opendcim

Download the latest version of openDCIM from opendcim.com and then put all extracted files into `/var/www` folder

```bash
cd /var/www/
cp db.inc.php-dist db.inc.php
vim db.inc.php
```

Edit the following lines, to reflect your settings of database host (in this example localhost), database name (dcim), and credentials that you assigned when creating the database:

```bash
$dbhost = 'localhost';
$dbname = 'dcim';
$dbuser = 'dcim';
$dbpass = 'dcimpassword';
```

Finally, restart Apache one last time:

```bash
sudo service apache2 reload
```
