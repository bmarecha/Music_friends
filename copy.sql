drop table if exists users cascade;
drop table if exists host cascade;
drop table if exists band cascade;
drop table if exists normal_users cascade;
drop table if exists concerts cascade;

create table users (
	u_id serial primary key,
	username varchar(30) unique,
	email_address varchar(50) unique
);

COPY users (username, email_address)
FROM '/home/baptiste/random/ghiz/users.csv' CSV HEADER