FROM mysql:latest

ENV MYSQL_ROOT_PASSWORD=$DB_Password

COPY ["create_database.sql", "/docker-entrypoint-initdb.d/01-user_setup.sql"]
