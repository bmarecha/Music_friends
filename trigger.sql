drop function if exists u_insert;

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
