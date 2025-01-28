FROM ubuntu:latest

ENV WORDPRESS_VERSION=6.6.2
ENV WOOCOMMERCE_VERSION=9.3.3
ENV PHP_UPLOAD_MAX_FILESIZE=10M
ENV PHP_POST_MAX_SIZE=10M
ENV ADMIN_USERNAME="admin"
ENV ADMIN_EMAIL="woo@mailinator.com"
ENV ADMIN_PASSWORD="WooWoo123"

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget vim unzip apache2 php libapache2-mod-php php-mysql php-mbstring php-xml php-gd php-curl php-zip mysql-server supervisor curl pwgen && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY apache2.conf /etc/apache2/apache2.conf

# Add configuration and scripts
COPY start-apache2.sh /start-apache2.sh
COPY start-mysqld.sh /start-mysqld.sh
COPY run.sh /run.sh
RUN chmod +x /*.sh

COPY my.cnf /etc/mysql/my.cnf
COPY supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
COPY supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
COPY supervisord-init.conf /etc/supervisor/conf.d/supervisord-init.conf

RUN mkdir -p /run/mysqld
RUN chown -R mysql:mysql /run/mysqld
RUN chmod 755 /run/mysqld

# Configure Apache document root
RUN mkdir -p /app && rm -rf /var/www/html && ln -s /app /var/www/html

# Download and install WordPress
WORKDIR /var/www/html
RUN wget -O wordpress.zip https://wordpress.org/wordpress-${WORDPRESS_VERSION}.zip && \
    unzip wordpress.zip && \
    mv wordpress/* . && \
    rm -rf wordpress wordpress.zip && \
    chown -R www-data:www-data .

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Set up MySQL
COPY create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod +x /create_mysql_admin_user.sh

# Set up WordPress
COPY .htaccess /app/.htaccess
COPY setup-wordpress.sh /setup-wordpress.sh
RUN chmod +x /setup-wordpress.sh

# Set up WooCommerce
COPY setup-woocommerce.sh /setup-woocommerce.sh
COPY setup-wizard-woocommerce.php /setup-wizard-woocommerce.php
RUN chmod +x /setup-woocommerce.sh

COPY bootstrap.sh /bootstrap.sh

# Permissions
RUN chmod -R 777 /var/www/html

# Expose ports
EXPOSE 80 3306

# Start services
CMD ["/run.sh"]
