
drop function if exists u_insert cascade;
drop function if exists f_insert cascade;

create function u_insert_tag() returns trigger as $users_tag_create$
BEGIN
	--
	-- Create a row in tag table to make sure each user has an associated tag.
	--
	INSERT INTO tag (t_name) VALUES(NEW.username);
	NEW.t_id := (SELECT t_id FROM tag WHERE t_name = NEW.username);
	RETURN NEW;
END;
$users_tag_create$ LANGUAGE plpgsql;

create trigger users_tag_create before insert or update on users for each row
execute function u_insert_tag();

create function c_insert_tag() returns trigger as $concerts_tag_create$
BEGIN
	--
	-- Create a row in tag table to make sure each concert has an associated tag.
	--
	INSERT INTO tag (t_name) VALUES(NEW.c_name);
	NEW.t_id := (SELECT t_id FROM tag WHERE t_name = NEW.c_name);
	RETURN NEW;
END;
$concerts_tag_create$ LANGUAGE plpgsql;

create trigger concerts_tag_create before insert or update on concerts for each row
execute function c_insert_tag();

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