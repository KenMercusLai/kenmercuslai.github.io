---
title: 如何在Ubuntu 14.04上安装openDCIM 3
date: 2015-01-27
tags: [Ubuntu, Linux, openDCIM, Tutorial]
---

[English version link](/networking/opendcim-3-install-on-ubuntu-14.04/)

# openDCIM简介

openDCIM是一个免费且开源的数据中心（你也可以说“机房”这个名词=_=）基础网络管理软件。基础网络管理对于不同人有着不同的含义，所以我们也有很多商业收费应用来满足各个方面的需求。而openDCIM的首要目标是让我们的数据中心管理人员不用再使用excel表格或者word文件来管理和追踪所有数据中心的资产设备。


# 安装流程


## LAMP

作为网站的经典组合——LAMP，自然是安装的第一步。借助apt的神力，我们只需要一行命令即可搞定。

```bash
sudo apt-get install apache2 php5 mysql-server
```

当然，请一定使用对于你网络最快的源来进行安装。同通常的默认美国源对于很多人都是比较慢的。:-)


## 启用https

根据openDCIM文档，如果不启用https可能导致访问的时候进入重定向死循环。我们首先启用ssl。

```bash
sudo a2enmod ssl
```

我们需要创建用户认证的key与certificate文件。需要注意的是，我们需要把这两个文件放到网站目录之外来避免访问DCIM页面的用户通过某种方式进行下载。

这里我们在home目录中创建这两个文件。

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


## 设置认证

现在所有认证所需要的部分都已经完成了，只要进行相应的配置即可完成。

编辑ssl设置：

```bash
nano /etc/apache2/sites-available/default-ssl
```

在 ，这一部分中，添加如下这行：

```bash
ServerName example.com:443
```

上面的example.com请用你自己的域名或者服务器的IP地址来代替。最好和上面一步中common name的设置一样。找到下面三个设置，然后改为如下：

```bash
SSLEngine on
SSLCertificateFile ~/apache.crt
SSLCertificateKeyFile ~/apache.key
```


## 激活 Virtual Host

我们激活我们https网站的Virtual Host：

```bash
sudo a2ensite default-ssl
```

如果没有特殊的需求，所有的apache服务器配置到此结束。重启服务来让配置生效。

```bash
sudo service apache2 reload
```

启动如果无误（应该无误！），在浏览器中输入 [https://youraddress](https://youraddress)，你就能看到认证提示了。


## 启用用户认证

在登录opendcim时，我们希望至少有一个基本的用户认证。这里我们需要为系统创建至少一个用户。

```bash
touch /var/www/.htpasswd
htpasswd /var/www/.htpasswd Administrator
```

系统在这里会提示你为Administrator输入两次密码。


## 安装opendcim

从opendcim.com网站中下载最新版本。然后把解压后的文件都放到 `/var/www` 文件夹中。

```bash
cd /var/www/
cp db.inc.php-dist db.inc.php
vim db.inc.php
```

编辑db.inc.php中数据库的配置部分：

```bash
$dbhost = 'localhost';
$dbname = 'dcim';
$dbuser = 'dcim';
$dbpass = 'dcimpassword';
```

最后，我们再重启一次apache。一切搞定！

```bash
sudo service apache2 reload
```


