drop table if exists tag cascade;
drop table if exists users cascade;
drop table if exists host cascade;
drop table if exists band cascade;
drop table if exists normal_users cascade;
drop table if exists concerts cascade;
drop table if exists interet cascade;
drop table if exists organisation_relation cascade;
drop table if exists media  cascade;
drop table if exists avis cascade;
drop table if exists genre cascade;
drop table if exists music cascade;
drop table if exists genres_relations cascade;
drop table if exists playlist cascade;
drop table if exists playlist_music_r cascade;
drop type if exists media_type;
drop type if exists user_type;
drop table if exists friends cascade;
drop table if exists follow cascade;
drop table if exists avis cascade;
drop table if exists avis_tags_relations cascade;

create type user_type as enum ('normal', 'host', 'band', 'association');

create table tag (
	t_id SERIAL PRIMARY KEY,
	t_name varchar(50) UNIQUE NOT NULL
);

create table users (
	u_id SERIAL PRIMARY KEY,
	t_id INT,
	u_type user_type NOT NULL,
	username varchar(30) UNIQUE NOT NULL,
	email_address varchar(50) UNIQUE NOT NULL,
	UNIQUE (u_id, u_type),
	FOREIGN KEY (t_id) references tag(t_id) ON DELETE CASCADE
);

create table normal_users (
	u_id INT PRIMARY KEY,
	u_type user_type check (u_type = 'normal'),
	FOREIGN KEY (u_id, u_type) references users(u_id, u_type) ON DELETE CASCADE
);

create table host (
	host_id INT PRIMARY KEY,
	latitude float default (random() * 180 - 90),
	longitude float default (random() * 360 - 180),
	UNIQUE (longitude, latitude),
	u_type user_type check (u_type = 'host'),
	FOREIGN KEY (host_id, u_type) references users(u_id, u_type) ON DELETE CASCADE
);

create table band (
	u_id INT PRIMARY KEY,
	u_type user_type check (u_type = 'band'),
	FOREIGN KEY (u_id, u_type) references users(u_id, u_type) ON DELETE CASCADE
);

create table friends (
    id_f1 INT NOT NULL,
    id_f2 INT NOT NULL CHECK (id_f2 <> id_f1),
    PRIMARY KEY (id_f1, id_f2),
    FOREIGN KEY (id_f1) references users(u_id) ON DELETE CASCADE,
    FOREIGN KEY (id_f2) references users(u_id) ON DELETE CASCADE
);
create table follow (
    id_target INT NOT NULL,
    id_src INT NOT NULL CHECK (id_src <> id_target),
    PRIMARY KEY (id_target, id_src),
    FOREIGN KEY (id_target) references users(u_id) ON DELETE CASCADE,
    FOREIGN KEY (id_src) references users(u_id) ON DELETE CASCADE
);

create table concerts (
	c_id SERIAL UNIQUE,
	host_id INT,
	t_id INT,
	c_name varchar(30) NOT NULL,
	c_date DATE,
	price INT CHECK (price >= 0),
	c_cause varchar(50),
	v_need boolean default false,
	nb_seat INT CHECK (nb_seat >= 0),
	nb_participant INT CHECK (nb_participant >= 0),
	PRIMARY KEY (c_id,host_id),
	FOREIGN KEY (host_id) references host(host_id) ON DELETE CASCADE,
	FOREIGN KEY (t_id) references tag(t_id) ON DELETE CASCADE

);

create table organisation_relation (
	c_id INT,
	u_id INT,
	PRIMARY KEY (c_id, u_id),
	FOREIGN KEY (c_id) references concerts(c_id) ON DELETE CASCADE,
	FOREIGN KEY (u_id) references users(u_id) ON DELETE CASCADE
);


create table interet (
	u_id INT,
	c_id INT,
	participation boolean NOT NULL default false,
	PRIMARY KEY(u_id, c_id),
	FOREIGN KEY (u_id) references normal_users(u_id) ON DELETE CASCADE,
	FOREIGN KEY (c_id) references concerts(c_id) ON DELETE CASCADE
);

create type media_type as enum ('gif', 'mp3', 'png', 'jpeg');

create table media (
	med_id SERIAL PRIMARY KEY,
	c_id INT references concerts(c_id) ON DELETE CASCADE,
	pathname varchar(70),
	m_type  media_type
);

create table genre (
	g_id SERIAL PRIMARY KEY,
	g_name varchar(30) NOT NULL,
	t_id INT
);

create table music (
	m_id SERIAL UNIQUE,
	m_name varchar(40) NOT NULL,
	t_id INT,
	g_id INT,
	u_id INT,
	PRIMARY KEY(m_id, u_id),
	FOREIGN KEY (u_id) references band(u_id) ON DELETE CASCADE,
	FOREIGN KEY (g_id) references genre(g_id) ON DELETE CASCADE,
	FOREIGN KEY (t_id) references tag(t_id) ON DELETE CASCADE
);

create table avis (
	a_id SERIAL UNIQUE,
	note INT CHECK (note <= 5 and note >=0),
	a_date DATE,
	comment varchar(255),
	u_id INT,
	c_id INT,
	PRIMARY KEY(c_id, u_id),
	FOREIGN KEY(u_id) references users(u_id) ON DELETE CASCADE,
	FOREIGN KEY (c_id) references concerts(c_id)  ON DELETE CASCADE

);

create table avis_tags_relations (
	t_id INT,
	a_id INT,
	PRIMARY KEY (t_id, a_id),
	FOREIGN KEY (t_id) references tag(t_id) ON DELETE CASCADE,
	FOREIGN KEY (a_id) references avis(a_id) ON DELETE CASCADE
);

create table genres_relations (
	sg_id INT,
	g_id INT,
	PRIMARY KEY (sg_id, g_id),
	FOREIGN KEY (sg_id) references genre(g_id) ON DELETE CASCADE,
	FOREIGN KEY (g_id) references genre(g_id) ON DELETE CASCADE
);

create table playlist (
	p_id SERIAL UNIQUE,
	p_name varchar(30) NOT NULL,
	u_id INT,
	u_type user_type, -- owner type, to check if it's a band
	PRIMARY KEY(p_id, u_id),
	FOREIGN KEY (u_id, u_type) references users(u_id, u_type) ON DELETE CASCADE
);

create table playlist_music_r (
	p_id INT,
	m_id INT,
	PRIMARY KEY (p_id, m_id),
	FOREIGN KEY (p_id) references playlist(p_id) ON DELETE CASCADE,
	FOREIGN KEY (m_id) references music(m_id) ON DELETE CASCADE
);


\i trigger.sql
\i copy.sql