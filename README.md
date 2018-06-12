# httpd-php

HTTPD server with CGI support, based on Alpine Linux. 

Images based on CentOS 7.5 are also provided.
- httpd-cgi:centos : with CentOS packages (httpd-2.4.6)
- httpd-cgi:centos-latest : with IUS packages (httpd-2.4.33+)

Port : tcp/80 (exposed)
Volume : /var/www/html (DocumentRoot)
Volume : /var/log/apache2 (Logs, auto rotate daily, keep one year)

You can choose the MPM.

You cah chose to activate CGI (disabled by default).

## Alpine Image

Based on Alpine:3.7 with packages installed via apk. 

Another image based on Alpine:edge is also provided.

This image is as light as possible.

## CentOS Image

Based on CentOS:7.5:1804 with packages installed via yum repos base & updates. 

This image is as light as possible.

## CentOS-latest Image

Based on CentOS:7.5.1804 with packages installed via yum repos base, updates, and HTTPD from IUS to provide the latest HTTPD version. 

This image is as light as possible.

## Parameters

DocumentRoot : /var/www/html (Volume), owner "apache.apache"

ENVIRONMENT VARS :

* HTTPD_ENABLE_CGI = true / other : Enable CGI if true / Disable if other

Default is true, CGI is enabled.

* HTTPD_MPM = prefork / worker / event

Default MPM is event.

If CGI is enabled, depending on MPM, CGI module is :
- event/worker : mod_cgid
- prefork : mod_cgi

CGI handler is called for files in ".cgi", ".sh", ".py".

Tested with #!/usr/bin/bash and #!/usr/bin/python



