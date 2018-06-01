# httpd-php

HTTPD server with CGI support, based on Alpine Linux.

Port : tcp/80 (exposed)
Volume : /var/www/html (DocumentRoot)
Volume : /var/log/apache2 (Logs, auto rotate daily, keep one year)

You can choose the MPM.

You cah chose to activate CGI (disabled by default).

## Alpine Image

Based on Alpine:3.7 with packages installed via apk. 

This image is as light as possible.

## Parameters

DocumentRoot : /var/www/html (Volume), owner "apache.apache"

ENVIRONMENT VARS :

* HTTPD_ENABLE_CGI = true / other : Enable CGI if true

* HTTPD_MPM = prefork / worker / event

Default MPM is prefork.

If CGI is enabled, depending on MPM, CGI module is :
- event/worker : mod_cgid
- prefork : mod_cgi

CGI handler is called for files in ".cgi", ".sh", ".py".

Tested with #!/usr/bin/bash and #!/usr/bin/python



