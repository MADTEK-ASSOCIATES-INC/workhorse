create database TARGETDB;
create user 'USER'@'localhost' identified by 'PASSWORD';
grant all on TARGETDB.* to 'USER'@'localhost';
