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

create table friends (
    id_f1 INT NOT NULL,
    id_f2 INT NOT NULL,
    primary key (id_f1, id_f2),
    foreign key (id_f1) references users(u_id),
    foreign key (id_f2) references users(u_id)
);
create table follow (
    id_target INT NOT NULL,
    id_src INT NOT NULL,
    primary key (id_target, id_src),
    foreign key (id_target) references users(u_id),
    foreign key (id_src) references users(u_id)
);


/*create trigger normal_users_reinsert after insert on users when (user_type = 'normal')*/


create table concerts (
	c_id serial primary key,
	host_id integer,
	pathname varchar(50) NOT NULL,
	c_date DATE,
	price integer CHECK (price >= 0),
	c_cause varchar(50),
	v_need boolean default false,
	nb_seat integer,
	nb_participant integer,
	primary key (c_id,host_id),
	foreign key (host_id) references to (host_id)

);

create table interet (
	u_id integer,
	c_id integer,
	participation boolean,
	foreign key (u_id) references normal_users(u_id),
	foreign key (c_id) references concerts(c_id)
);

create type media_type as enum ('gif', 'mp3', 'png', 'jpeg');

create table media (
	pathname varchar(50),
	m_type  media_type
);

create table avis (
	note integer CHECK (note <= 5 and note >=0),
	a_date DATE,
	comment varchar(50)
);

create table genre (
	g_id serial primary key,
	nom varchar(30)
);

create table music (
	m_name varchar(30),
	g_id integer,
	foreign key (g_id) references to genre(g_id)
);

create table relations_genres (
	sg_id integer,
	g_id integer,
	primary key (sg_id, g_id),
	foreign key (sg_id) references to genre(g_id),
	foreign key (g_id) references to genre(g_id)
);

\i trigger.sql
\i copy.sql