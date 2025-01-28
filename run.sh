#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}/" \
    -e "s/^post_max_size.*/post_max_size = ${PHP_POST_MAX_SIZE}/" /etc/php5/apache2/php.ini

chown -R mysql $VOLUME_HOME
chgrp -R mysql $VOLUME_HOME
	
echo "=> Installing MySQL ..."
mysqld --initialize-insecure > /dev/null 2>&1
echo "=> Done!"  

echo "Starting supervisor which will start apache, mysql and run init scripts"
exec supervisord -n
