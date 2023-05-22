
drop function if exists u_insert cascade;
drop function if exists f_insert cascade;
drop function if exists u_insert_tag cascade;
drop function if exists c_insert_tag cascade;
drop function if exists m_insert_tag cascade;
drop function if exists g_insert_tag cascade;

create function u_insert_tag() returns trigger as $users_tag_create$
BEGIN
	--
	-- Create a row in tag table to make sure each user has an associated tag.
	--
	IF (NEW.username NOT IN (SELECT t_name FROM tag)) THEN
		INSERT INTO tag (t_name) VALUES(NEW.username);
	END IF;
	NEW.t_id := (SELECT t_id FROM tag WHERE t_name = NEW.username);
	RETURN NEW;
END;
$users_tag_create$ LANGUAGE plpgsql;

create trigger users_tag_create before insert or update on users for each row
execute function u_insert_tag();

create function u_insert() returns trigger as $users_reinsert$
BEGIN
	--
	-- Create a row in herited user table to make sure each user is in a category.
	--
	IF (NEW.u_type = 'normal') THEN
		INSERT INTO normal_users (u_id, u_type) VALUES(NEW.u_id, NEW.u_type);
	ELSIF (NEW.u_type = 'host') THEN
		INSERT INTO host (host_id, u_type) VALUES (NEW.u_id, NEW.u_type);
	ELSIF (NEW.u_type = 'band') THEN
		INSERT INTO band (u_id, u_type) VALUES (NEW.u_id, NEW.u_type);
	END IF;
	RETURN NULL; -- result is ignored since this is an AFTER trigger
END;
$users_reinsert$ LANGUAGE plpgsql;

create trigger users_reinsert after insert or update on users for each row
execute function u_insert();

create function f_insert() returns trigger as $friendship_insert_order$
DECLARE temp INT;
BEGIN
	-- Ensures id_f2 is always greater than id_f1
	IF (NEW.id_f1 > NEW.id_f2) THEN
		temp := NEW.id_f1;
		NEW.id_f1 := NEW.id_f2;
		NEW.id_f2 := temp;
	END IF;

	RETURN NEW;
END;
$friendship_insert_order$ LANGUAGE plpgsql;

create trigger friendship_insert_order before insert or update on friends for each row
execute function f_insert();

create function c_insert_tag() returns trigger as $concerts_tag_create$
BEGIN
	--
	-- Create a row in tag table to make sure each concert has an associated tag.
	--
	IF (NEW.c_name NOT IN (SELECT t_name FROM tag)) THEN
		INSERT INTO tag (t_name) VALUES(NEW.c_name);
	END IF;
	NEW.t_id := (SELECT t_id FROM tag WHERE t_name = NEW.c_name);
	RETURN NEW;
END;
$concerts_tag_create$ LANGUAGE plpgsql;

create trigger concerts_tag_create before insert or update on concerts for each row
execute function c_insert_tag();

create function g_insert_tag() returns trigger as $genre_tag_create$
BEGIN
	--
	-- Create a row in tag table to make sure each genre has an associated tag.
	--
	IF (NEW.g_name NOT IN (SELECT t_name FROM tag)) THEN
		INSERT INTO tag (t_name) VALUES(NEW.g_name);
	END IF;
	NEW.t_id := (SELECT t_id FROM tag WHERE t_name = NEW.g_name);
	RETURN NEW;
END;
$genre_tag_create$ LANGUAGE plpgsql;

create trigger genre_tag_create before insert or update on genre for each row
execute function g_insert_tag();

create function m_insert_tag() returns trigger as $music_tag_create$
BEGIN
	--
	-- Create a row in tag table to make sure each genre has an associated tag.
	--
	IF (NEW.m_name NOT IN (SELECT t_name FROM tag)) THEN
		INSERT INTO tag (t_name) VALUES(NEW.m_name);
	END IF;
	NEW.t_id := (SELECT t_id FROM tag WHERE t_name = NEW.m_name);
	RETURN NEW;
END;
$music_tag_create$ LANGUAGE plpgsql;

create trigger music_tag_create before insert or update on music for each row
execute function m_insert_tag();

drop function if exists p_insert_owner cascade;
drop function if exists m_insert_check cascade;

create function p_insert_owner() returns trigger as $playlist_insert$
BEGIN
	--
	-- Verify if there isn't already 10 playlist from that user
	--
	IF (10 <= (SELECT COUNT(*) FROM playlist WHERE u_id = NEW.u_id)) THEN
		ROLLBACK;
		RAISE EXCEPTION  'This user already have 10 playlist.';
	ELSE
		IF (NEW.u_type IS NULL) THEN
			NEW.u_type := (SELECT u_type FROM users WHERE u_id = NEW.u_id);
		END IF;
	END IF;
	RETURN NEW;
END;
$playlist_insert$ LANGUAGE plpgsql;

create trigger playlist_insert before insert or update on playlist for each row
execute function p_insert_owner();

create function m_insert_check() returns trigger as $music_insert$
BEGIN
	--
	-- Verify if there isn't already 20 musics from that playlist
	--
	IF (20 <= (SELECT COUNT(*) FROM playlist_music_r WHERE p_id = NEW.p_id)) THEN
		ROLLBACK;
		RAISE EXCEPTION  'This playlist already have 20 songs.';
	ELSE
		IF ('band' = (SELECT u_type FROM playlist WHERE p_id = NEW.p_id)
			AND (SELECT u_id FROM playlist WHERE p_id = NEW.p_id) != (SELECT u_id FROM music WHERE m_id = NEW.m_id)) THEN
			ROLLBACK;
			RAISE EXCEPTION 'This is a band playlist, you can only insert music from the same band';
		END IF;
	END IF;
	RETURN NEW;
END;
$music_insert$ LANGUAGE plpgsql;

create trigger music_insert before insert or update on playlist_music_r for each row
execute function m_insert_check();