deallocate prepare recherche_amis;

PREPARE recherche_amis(VARCHAR) as
SELECT U1.username FROM users U1, users U2, friends
WHERE ((id_f1 = U1.u_id AND id_f2 = U2.u_id) OR (id_f1 = U2.u_id AND id_f2 = U1.u_id)) AND U2.username = $1;

SELECT username, COUNT(id_f1) nb_amis FROM users JOIN friends
ON (id_f1 = u_id OR id_f2 = u_id) GROUP BY username ORDER BY nb_amis desc LIMIT 15;

\prompt 'Tapez le nom de la personne dont vous voulez voir ses amis -> ' username
EXECUTE recherche_amis(:'username');
\prompt 'Essayez un de ses amis à présent -> ' username
EXECUTE recherche_amis(:'username');

--PREPARE user_all_music(VARCHAR) as
--SELECT m_name, CONCATENATE(p_name) FROM music
--NATURAL JOIN playlist_music_r NATURAL JOIN playlist NATURAL JOIN users
--WHERE username = $1 GROUP BY m_name;

-- Afficher les concerts annoncés autour de coordonnées et un rayon
-- $1 : latitude, $2 : longitude, $3 : rayon
-- PREPARE concerts_autour(FLOAT, FLOAT, FLOAT)

-- Trois \prompt  puis execute exemple

-- \prompt concert_name pour Recursion :
-- (
-- First element : Argument de \prompt
-- Union avec :
-- SELECT concert, (C1.longitude - C2.longitude + C1.latitude - C2.latitude) distance FROM concerts du jour suivant
-- ORDER BY distance LIMIT 1
-- ) SELECT * FROM recursion LIMIT 10;