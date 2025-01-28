echo "Sleeping for 20 seconds..."
sleep 20
/create_mysql_admin_user.sh
/setup-wordpress.sh
/setup-woocommerce.sh
