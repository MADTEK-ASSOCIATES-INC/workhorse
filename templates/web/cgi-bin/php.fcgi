#!/bin/bash
PHPRC=/var/www/<CLIENT>/<PLATFORM>/<DOMAIN>/etc/
PHP_CGI=/usr/bin/php-cgi
PHP_FCGI_CHILDREN=4
PHP_FCGI_MAX_REQUESTS=1000
export PHPRC
export PHP_FCGI_CHILDREN
export PHP_FCGI_MAX_REQUESTS
exec $PHP_CGI
