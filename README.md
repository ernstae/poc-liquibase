# Liquibase Proof-of-Concept

Liquibase is an application for tooling schema updates and changes to database environments.  The software supports most of the major DB environments, and does so through connectivity with JDBC.

For more information about Liquibase, see http://www.liquibase.org/documentation/index.html

## Quickstart

TL;DR for this:  
* make sure you have Docker engine on your computer with `docker-compose`
* run `docker-compose up` in this directory to start a mysql and liquibase container.
* run `./runtest.sh` from the repository root to pass the necessary commands to the liquibase container

The `runtest.sh` script contains all the necessary commands to apply changesets using liquibase to the MySQL database. 

```
➜  liquibasetest git:(master) ✗ ./runtest.sh
We are now verifying that the schema has no tables (there should be no output of this command)
+ docker-compose exec mysql bash -c 'mysql dbtest -e "show tables"'
mysql_1      | mbind: Operation not permitted

Let's run the liquibase updates against the liquibase container
+ docker-compose exec liquibase bash -c 'liquibase --url='\''jdbc:mysql://db/dbtest?useUnicode=true&characterEncoding=UTF-8&useSSL=false'\'' --changeLogFile=/schema/00-changesets.sql --username=root update'
Liquibase Update Successful


Let's verify the database has three tables as expected
+ docker-compose exec mysql bash -c 'mysql dbtest -e "show tables; select * from users; select * from DATABASECHANGELOG"'

+-----------------------+
| Tables_in_dbtest      |
+-----------------------+
| DATABASECHANGELOG     |
| DATABASECHANGELOGLOCK |
| users                 |
+-----------------------+

+----+-------+----------+
| id | name  | comments |
+----+-------+----------+
|  1 | ernst | a person |
+----+-------+----------+

+----+--------+---------------------------+---------------------+---------------+----------+------------------------------------+-------------+----------+------+-----------+
| ID | AUTHOR | FILENAME                  | DATEEXECUTED        | ORDEREXECUTED | EXECTYPE | MD5SUM                             | DESCRIPTION | COMMENTS | TAG  | LIQUIBASE |
+----+--------+---------------------------+---------------------+---------------+----------+------------------------------------+-------------+----------+------+-----------+
| 1  | ernsta | /schema/00-changesets.sql | 2018-01-23 21:12:04 |             1 | EXECUTED | 7:9a35f10bc52eea016fb5345873244ac4 | sql         |          | NULL | 3.2.2     |
| 2  | ernst  | /schema/00-changesets.sql | 2018-01-23 21:12:04 |             2 | EXECUTED | 7:9e7280a3f68a243288e462b62412a546 | sql         |          | NULL | 3.2.2     |
| 3  | ernsta | /schema/00-changesets.sql | 2018-01-23 21:12:04 |             3 | EXECUTED | 7:a9685fc4d0e253403db427617cf5c245 | sql         |          | NULL | 3.2.2     |
| 4  | ernsta | /schema/00-changesets.sql | 2018-01-23 21:12:04 |             4 | EXECUTED | 7:11c0b4ecc306699a1b17848c731047e9 | sql         |          | NULL | 3.2.2     |
+----+--------+---------------------------+---------------------+---------------+----------+------------------------------------+-------------+----------+------+-----------+
```

## Accessing the Database

You can easily launch a mysql console by running the command `docker-compose exec mysql mysql dbtest` (to connect into the database named "dbtest")

A sample session might look like this:
```
➜  liquibasetest git:(master) ✗ docker-compose exec mysql mysql dbtest

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.3-rc-log MySQL Community Server (GPL)

Copyright (c) 2000, 2017, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>

```

When liquibase applies changesets to the database, it maintains two additional tables called `DATABASECHANGELOG` and `DATABASECHANGELOGLOCK` for both maintaining state and version control purposes.

```
 show tables;
+-----------------------+
| Tables_in_axontest    |
+-----------------------+
| DATABASECHANGELOG     |
| DATABASECHANGELOGLOCK |
| users                 |
+-----------------------+
3 rows in set (0.00 sec)
```
The file `DATABASECHANGELOG` maintains a listing of all the changes made by liquibase, with timestamps and hashes.  For more information about these tables: 


## Disclaimer
This work is not and should not be considered "production-ready", especially since there is no password set on the MySQL instance's root user account.  Please use this only for testing and reference on a local, controlled environment.  Otherwise, edit the `docker-compose.yml` and establish a password for the MySQL account.


## Diagrams to show what's going on
These are a work in progress, and use the *mermaid* syntax for graph diagrams.

```mermaid
graph TD;
  AA[you at your computer] --> CC[docker-compose]
  CC--> BB[Docker Engine]
  BB--> |launch container| A[mysql:latest]
  BB--> |launch container| B[liquibase]
  /schema --> |bind mount volume| B
  B --> |applies dbchangeset| A
  schema changes --> A;
```
