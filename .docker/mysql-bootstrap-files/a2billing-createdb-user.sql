
/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2012 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/

--
-- A2Billing database script - Create user & create a new database
--

/* Default values - Please change them to whatever you want

Database name is: mya2billing
Database user is: a2billinguser
User password is: a2billing


Usage:

mysql -u root -p"root password" < a2billing-MYSQL-createdb-user.sql 

*/


use mysql;

delete from user where User='a2billinguser';
delete from db where User='a2billinguser';

GRANT ALL PRIVILEGES ON mya2billing.* TO 'a2billinguser'@'%' IDENTIFIED BY 'a2billing' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON mya2billing.* TO 'a2billinguser'@'localhost' IDENTIFIED BY 'a2billing' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON mya2billing.* TO 'a2billinguser'@'localhost.localdomain' IDENTIFIED BY 'a2billing' WITH GRANT OPTION;

GRANT ALL PRIVILEGES ON *.* TO 'root'@'phpmyadmin' IDENTIFIED BY 'root' WITH GRANT OPTION;

create DATABASE if not exists `mya2billing`;