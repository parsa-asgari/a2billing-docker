#!/bin/sh

echo "**************************"
echo "Bootstrapping the A2Billing stack"
echo "--------------------------"
echo ""

echo "Please do make sure that your working directory is inside a2billing-docker/"
echo ""

echo "==> The current working directory is"
echo $(echo $PWD)
echo ""


echo "==> 1 - Running Composer and making sure everything is installed"
echo "====> 1.1 - Running docker run --rm --interactive --tty --volume ./a2billing:/app composer update"
echo ""
docker run --rm --interactive --tty --volume ./a2billing:/app composer update
echo ""
echo "====> 1.2 - Running docker run --rm --interactive --tty --volume ./a2billing:/app composer install"
echo ""
docker run --rm --interactive --tty --volume ./a2billing:/app composer install
echo ""
echo "====> 1.3 - Running docker run --rm --interactive --tty --volume ./a2billing:/app composer dump-autoload "
echo ""
docker run --rm --interactive --tty --volume ./a2billing:/app composer dump-autoload 
echo ""
echo "====> 1.4 - Successfully ran Composer and installed/updated PHP dependencies"

echo ""
echo ""

echo "==> 2 - Running the 'db' container and making sure MySQL is setup correctly"
echo "====> 2.1 - Running docker compose up -d db"
echo ""
docker compose up -d db
echo ""
echo "====> 2.1 - Running docker exec -it db bash /.docker/mysql_bootstrap.sh"
echo ""
echo "====> Waiting for the MySQL container to get ready..."
sleep 20
docker exec -it db bash /.docker/mysql_bootstrap.sh
docker compose down
echo ""
echo "====> 2.1 - Successfully setup MySQL and prepared the mya2billing database + configured access for phpMyAdmin"
echo ""

echo "==> 3 - Running the A2billing Docker Stack "
echo "====> 3.1 - Running docker compose up -d"
echo ""
docker compose up -d
echo ""
echo "====> 3.1 - Successfully ran docker compose up -d"

echo ""
echo "Successfully bootstrapped the A2Billing stack"
echo "--------------------------"
echo "**************************"