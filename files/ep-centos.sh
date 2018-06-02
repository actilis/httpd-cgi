#!/bin/bash

# MPM (if MPM=event is specified, use it, else use "prefork" as default)
case "${HTTPD_MPM:=event}" in
   prefork) ;;
   worker)  sed -i -e '/LoadModule mpm_worker/s,^#,,' \
                   -e '/LoadModule mpm_prefork/s,^,#,' \
		    /etc/httpd/conf.modules.d/00-mpm.conf
            ;;
   event)   sed -i -e '/LoadModule mpm_event/s,^#,,' \
                   -e '/LoadModule mpm_prefork/s,^,#,' \
		    /etc/httpd/conf.modules.d/00-mpm.conf
            ;;
   *)       echo "Err: MPM should be 'event' or 'prefork', not '$MPM'"
            exit 1
esac


# Make Apache tuning on default httpd.conf
sed -i -e '/LoadModule slotmem_shm_module/s/^#//' /etc/httpd/conf.modules.d/00-base.conf

sed -i -e '/Options Indexes FollowSymLinks *$/s/$/ ExecCGI/' \
       -e '/ErrorLog .logs.error_log./s,logs/error_log,|/usr/sbin/rotatelogs -l -f -c /var/log/httpd/error-%m%d.log 86400,' \
       -e '/CustomLog .logs.access_log. combined/s,logs/access_log,|/usr/sbin/rotatelogs -l -f -c /var/log/httpd/access-%m%d.log 86400,' \
       /etc/httpd/conf/httpd.conf

# Activate CGI if HTTPD_ENABLE_CGI is true
if [ "${HTTPD_ENABLE_CGI:=true}" == true ] ; then  
   sed -i -e '/LoadModule cgi/s,#,,' \
       /etc/httpd/conf.modules.d/01-cgi.conf \

   sed -i -e '/index\.html$/s,$, index.sh index.cgi,' \
          -e '/AddHandler.*cgi-script.*cgi/s,#,,' \
          -e '/AddHandler.*cgi-script.*cgi/s,$, .sh .py,' \
          /etc/httpd/conf/httpd.conf
fi


#mkdir -p /run/apache2
cat <<DONE > /etc/supervisord.conf
[supervisord]
user=root
nodaemon=true              ; (start in foreground if true;default false)
logfile=/var/log/supervisord.log  ; (main log file;default $CWD/supervisord.log)
logfile_maxbytes=50MB       ; (max main logfile bytes b4 rotation;default 50MB)
logfile_backups=10          ; (num of main logfile rotation backups;default 10)
loglevel=info               ; (log level;default info; others: debug,warn,trace)
pidfile=/var/run/supervisord.pid ; (supervisord pidfile;default supervisord.pid)

[program:httpd]
command=/usr/sbin/httpd -DFOREGROUND

DONE

echo "Going-on with MPM ${HTTPD_MPM}, ENABLE_CGI is ${HTTPD_ENABLE_CGI}."
exec "$@"

