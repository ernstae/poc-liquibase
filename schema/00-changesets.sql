--liquibase formatted sql

--changeset ernsta:1 failOnError:true dbms:mysql
create table users (
       id int primary key,
       name varchar(255)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

--rollback drop table users;

--changeset ernst:2
insert into users (id, name) values (1, 'ernst');

--changeset ernsta:3
ALTER TABLE users ADD COLUMN comments varchar(20);

--changeset ernsta:4
--preconditions onFail:HALT onError:HALT
--precondition-sql-check expectedResult:0 SELECT COUNT(*) FROM users WHERE id=1 AND name='ernst' AND comments!=NULL;
UPDATE users SET comments='a person' WHERE id IN (1) AND name='ernst';


