# woocommerce-docker

This repo provides a way of spawning an instance of WooCommerce with
minimal intervention.

## Getting started

Use the Makefile.

In one terminal:

```bash
make reset
```

In another if need be:

```bash
make ssh
```

In your browser go to http://localhost:8080/ to visit the site.

To access the Wordpress admin system go to http://localhost:8080/wp-admin

Logins:

Wordpress
- user: admin
- pass: tbc

MySQL
- user: admin
- pass: tbc
