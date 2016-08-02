#!/bin/bash
/usr/bin/mysql_install_db --user=mysql
/usr/bin/mysqld_safe --datadir="/var/lib/mysql"
