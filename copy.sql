drop table if exists users cascade;
drop table if exists host cascade;
drop table if exists band cascade;
drop table if exists normal_users cascade;
drop table if exists concerts cascade;
drop table if exists interet cascade;

create type user_type as enum ('normal', 'host', 'band', 'association');

create table users (
	u_id serial primary key,
	u_type user_type,
	username varchar(30) unique,
	email_address varchar(50) unique,
);

create table normal_users (
	nu_id serial primary key,
	u_id integer primary key,
	u_type user_type,
	foreign key (u_id, u_type) references users(u_id, u_type)
);

create table host (
	u_id integer primary key,
	longitude float,
	latitude float,
	unique (longitude, latitude),
	u_type user_type,
	foreign key (u_id, u_type) references users(u_id, u_type)
);

create table band (
	u_id integer primary key,
	u_type user_type,
	foreign key (u_id, u_type) references users(u_id, u_type)
);

/*create trigger normal_users_reinsert after insert on users when (user_type = 'normal')*/


create table concerts (
	c_id serial primary key
);

create table interet (
	u_id integer,
	c_id integer,
	participation boolean,
	foreign key (u_id) references normal_users(u_id),
	foreign key (c_id) references concerts(c_id)
);

COPY users (username, email_address)
FROM '/home/baptiste/random/ghiz/users.csv' CSV HEADER