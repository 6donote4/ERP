#!/bin/sh
#========================================
#   Linux Distribution: Debian 10
#   Author: 6donote4 <mailto:do_note@hotmail.com>
#   Dscription: LAMP configuration automaticly for inoERP
#   Version: 0.0.1
#   Blog: https://www.donote.tk https://6donote4.github.io
#========================================
# This script is used to configure LAMP for inoERP
VERSION=0.0.1
PROGNAME="$(basename $0)"

export LC_ALL=C

SCRIPT_UMASK=0122
umask $SCRIPT_UMASK

usage() {
cat << EOF
delfiles $VERSION

Usage:
./$PROGNAME [option]
Options
-c	Confiure LAMP
--version  Show version
-h --help  Show this usage
EOF
}

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

if [[ "$1" == ""  ]];then
    usage
    exit 0
fi

ARGS=( "$@" )

			export PATH=$PATH:/sbin:/bin:/usr/bin
	case "$1" in
           -c)
			apt-get install -y apache2* 
			apt-get install -y php-*
			apt-get install -y php7.3-*
			apt-get install -y vim emacs
			apt-get install -y default-mysql-server
			dpkg -i webmin_1.930_all.deb
			apt-get -f install -y
			cp -f 000-default.conf /etc/apache2/sites-available 
			tar xjvf inoERP-0.6.1.tar.bz2
			cp -r ./inoERP-0.6.1/inoerp /var/www
			chmod -R 777 /var/www/inoerp
			a2enmod proxy_fcgi setenvif
			a2enconf php7.3-fpm 
			systemctl reload apache2
			systemctl restart apache2
			systemctl restart php7.3-fpm
			dpkg-reconfigure locales
			;;
	    -h|--help)
			usage
			exit 0
			;;
	    --version)
			echo $VERSION
			exit 0
			;;
	
	    *)
			echo  "Invalid parameter $1" 1>&2
			exit 1
			;;
	esac
