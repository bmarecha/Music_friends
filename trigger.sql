
drop function if exists u_insert cascade;
drop function if exists f_insert cascade;

create function u_insert() returns trigger as $users_reinsert$
BEGIN
	--
	-- Create a row in herited user table to make sure each user is in a category.
	--
	IF (NEW.u_type = 'normal') THEN
		INSERT INTO normal_users (u_id, u_type) VALUES(NEW.u_id, NEW.u_type);
	ELSIF (NEW.u_type = 'host') THEN
		INSERT INTO host (u_id, u_type) VALUES (NEW.u_id, NEW.u_type);
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