#!/bin/sh
mysql -u root --password=$MYSQL_ROOT_PASSWORD < /.docker/mysql-bootstrap-files/a2billing-createdb-user.sql
echo succesfully created mya2billing database
/.docker/mysql-bootstrap-files/install-db.sh
