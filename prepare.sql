--deallocate prepare recherche_amis;
--deallocate prepare concerts_autour;
--deallocate prepare road_trip;
--
--PREPARE recherche_amis(VARCHAR) as
--SELECT U1.username FROM users U1, users U2, friends
--WHERE ((id_f1 = U1.u_id AND id_f2 = U2.u_id) OR (id_f1 = U2.u_id AND id_f2 = U1.u_id)) AND U2.username = $1;
--
--SELECT username, COUNT(id_f1) nb_amis FROM users JOIN friends
--ON (id_f1 = u_id OR id_f2 = u_id) GROUP BY username ORDER BY nb_amis desc LIMIT 15;

--\prompt 'Tapez le nom de la personne dont vous voulez voir ses amis -> ' username
--EXECUTE recherche_amis(:'username');
--\prompt 'Essayez un de ses amis à présent -> ' username
--EXECUTE recherche_amis(:'username');

--PREPARE user_all_music(VARCHAR) as
--SELECT m_name, CONCATENATE(p_name) FROM music
--NATURAL JOIN playlist_music_r NATURAL JOIN playlist NATURAL JOIN users
--WHERE username = $1 GROUP BY m_name;

-- Afficher les concerts annoncés autour de coordonnées et un rayon
-- $1 : latitude, $2 : longitude, $3 : rayon
--PREPARE concerts_autour(FLOAT, FLOAT, FLOAT) as 
--SELECT c_name, c_date, price, c_cause, host_id,
--ROUND((ABS(longitude - $2) + ABS(latitude - $1))::numeric, 2) distance,
--latitude, longitude, nb_seat, nb_participant, v_need
--FROM concerts
--NATURAL JOIN host 
--WHERE ABS(longitude - $2) + ABS(latitude - $1) < $3
--ORDER BY distance, c_date;
--
--\prompt ' Tapez la latitude -> ' latitude
--\prompt ' Tapez la longitude -> ' longitude
--\prompt ' Tapez le rayon  -> ' rayon
--EXECUTE concerts_autour(:'latitude', :'longitude', :'rayon');
--
---- Afficher le nom et la date des concerts dans les prochains jours aprés le concert donné en parametre 
--PREPARE road_trip(INT) as 
--WITH RECURSIVE road_trip_rec as (
--SELECT c_name, c_date FROM concerts WHERE  c_id = $1
--UNION 
--SELECT c.c_name, c.c_date
--FROM road_trip_rec r
--JOIN concerts c ON c.c_date = r.c_date + INTERVAL '1 day'
--) SELECT * FROM road_trip_rec LIMIT 10;
--
--\prompt ' Tapez l id du concert  -> ' id
--EXECUTE road_trip(:'id');
--
--
--

-- Groupe séparé pour plus de visibilité
SELECT host_id, nb_seat, nb_participant FROM concerts WHERE host_id = 428;
-- Somme unique
SELECT host_id, sum(nb_seat - nb_participant)
FROM concerts WHERE host_id = 428
GROUP BY host_id;
-- Sommes séparées
SELECT host_id, sum(nb_seat) - sum(nb_participant)
FROM concerts WHERE host_id = 428
GROUP BY host_id;

-- Second one fixed to have the same result as first one
--SELECT host_id, sum(nb_seat) - sum(nb_participant)
--FROM concerts WHERE host_id = 428 AND nb_participant IS NOT NULL
--GROUP BY host_id;


-- le prix moyen de concert pour chaque mois
SELECT "month", avg(price) as avg_price 
FROM (
    SELECT TO_CHAR(c_date, 'MM') as "month", price
    FROM concerts
) a
GROUP BY "month"
ORDER BY "month";

