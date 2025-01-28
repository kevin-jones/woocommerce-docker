echo "Sleeping for 1 second first to allow things to start..."
sleep 1

mysqladmin create wordpress 
wp core install --url=http://localhost --title="Test Wordpress" --admin_user=$ADMIN_USERNAME --admin_password=$ADMIN_PASSWORD --admin_email=$ADMIN_EMAIL --allow-root

rm -rf /app/wp-config-sample.php /app/wp-admin/install*.php 

chmod 775 /app 
find /app -type d -exec chmod 775 {} \;
find /app -type f -exec chmod 664 {} \;
chown -R www-data:www-data /app

