drop table if exists users cascade;
drop table if exists host cascade;
drop table if exists band cascade;
drop table if exists normal_users cascade;
drop table if exists concerts cascade;
drop table if exists interet cascade;
drop type if exists user_type;

create type user_type as enum ('normal', 'host', 'band', 'association');

create table users (
	u_id serial primary key,
	u_type user_type,
	username varchar(30) unique,
	email_address varchar(50) unique,
	unique (u_id, u_type)
);

create table normal_users (
	u_id integer primary key,
	u_type user_type check (u_type = 'normal'),
	foreign key (u_id, u_type) references users(u_id, u_type)
);

create table host (
	u_id integer primary key,
	latitude float default (random() * 180 - 90),
	longitude float default (random() * 360 - 180),
	unique (longitude, latitude),
	u_type user_type check (u_type = 'host'),
	foreign key (u_id, u_type) references users(u_id, u_type)
);

create table band (
	u_id integer primary key,
	u_type user_type check (u_type = 'band'),
	foreign key (u_id, u_type) references users(u_id, u_type)
);

\i trigger.sql
\i copy.sql