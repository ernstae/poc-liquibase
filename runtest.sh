#!/bin/bash -x

echo "We are now verifying that the schema has no tables (there should be no output of this command)"
docker-compose exec mysql bash -c 'mysql dbtest -e "show tables"';

echo "Let's run the liquibase updates against the liquibase container"
docker-compose exec liquibase bash -c "liquibase --url='jdbc:mysql://db/dbtest?useUnicode=true&characterEncoding=UTF-8&useSSL=false' --changeLogFile=/schema/00-changesets.sql --username=root update"

echo "Let's verify the database has three tables as expected"
docker-compose exec mysql bash -c 'mysql dbtest -e "show tables; select * from users; select * from DATABASECHANGELOG"'
