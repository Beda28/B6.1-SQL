FROM mysql:8.4

COPY init.sql   /docker-entrypoint-initdb.d/01_init.sql
COPY insert.sql /docker-entrypoint-initdb.d/02_insert.sql
COPY query.sql  /sql/query.sql

EXPOSE 3306