deallocate prepare recherche_amis;
deallocate prepare concerts_autour;
deallocate prepare road_trip;
deallocate prepare road_trip_eco;
deallocate prepare concert_with_genre;
deallocate prepare playlist_size_from;

PREPARE recherche_amis(VARCHAR) as
SELECT U1.username 
FROM users U1, users U2, friends
WHERE ((id_f1 = U1.u_id AND id_f2 = U2.u_id)
        OR (id_f1 = U2.u_id AND id_f2 = U1.u_id)) AND U2.username = $1;

SELECT username, COUNT(id_f1) nb_amis 
FROM users JOIN friends
ON (id_f1 = u_id OR id_f2 = u_id) 
GROUP BY username 
ORDER BY nb_amis desc LIMIT 15

\prompt 'Tapez le nom de la personne dont vous voulez voir ses amis -> ' username
EXECUTE recherche_amis(:'username');

\prompt 'Essayez un de ses amis à présent -> ' username
EXECUTE recherche_amis(:'username');

SELECT * FROM user WHERE u_type='band' LIMIT 20;

PREPARE user_all_music(VARCHAR) as
SELECT m_name, CONCATENATE(p_name) 
FROM music
NATURAL JOIN playlist_music_r 
NATURAL JOIN playlist 
NATURAL JOIN users
WHERE username = $1 
GROUP BY m_name;

\prompt 'Tapez le nom de la personne dont vous voulez voir ses musics -> ' username
EXECUTE user_all_music(:'username');
\prompt 'Tapez le nom de la personne dont vous voulez voir ses musics -> ' username
EXECUTE user_all_music(:'username');


--Afficher les concerts annoncés autour de coordonnées et un rayon
-- $1 : latitude, $2 : longitude, $3 : rayon
PREPARE concerts_autour(FLOAT, FLOAT, FLOAT) as 
SELECT c_name, c_date, price, c_cause, host_id,
ROUND((ABS(longitude - $2) + ABS(latitude - $1))::numeric, 2) distance,
latitude, longitude, nb_seat, nb_participant, v_need
FROM concerts
NATURAL JOIN host 
WHERE ABS(longitude - $2) + ABS(latitude - $1) < $3
ORDER BY distance, c_date;

\prompt ' Tapez la latitude -> ' latitude
\prompt ' Tapez la longitude -> ' longitude
\prompt ' Tapez le rayon  -> ' rayon
EXECUTE concerts_autour(:'latitude', :'longitude', :'rayon');

-- Afficher le nom et la date des concerts dans les prochains jours aprés le concert donné en parametre 
PREPARE road_trip(INT) as 
WITH RECURSIVE road_trip_rec as (
SELECT c_name, c_date FROM concerts WHERE  c_id = $1
UNION 
SELECT c.c_name, c.c_date
FROM road_trip_rec r
JOIN concerts c ON c.c_date = r.c_date + INTERVAL '1 day'
) 
SELECT * FROM road_trip_rec LIMIT 10;

--cojointure sur les concerts pour avoir tous les concerts qui se suivent, pour chaque concert on trouve le concert du jour suivant le plus proche,
--sur ca on fait reccursion 
PREPARE road_trip_eco (INT) as 
WITH RECURSIVE
    conc_loc as (SELECT * FROM concerts NATURAL JOIN host),
    
    cons_dis as (SELECT c1.c_id as c1_id, c2.c_id as c2_id,
                ROUND((ABS(c1.longitude - c2.longitude) +
                       ABS(c1.latitude - c2.latitude))::numeric, 2) as distance
                 FROM conc_loc c1, conc_loc c2
                 WHERE c2.c_date = c1.c_date + INTERVAL '1 day'),

    cons AS (SELECT c1_id, c2_id
             FROM cons_dis c1
             WHERE (distance = (SELECT min(c2.distance)
                               FROM cons_dis c2
                               WHERE c2.c1_id = c1.c1_id))
            ),
    road_trip_rec as (SELECT c1_id
                             FROM cons 
                             WHERE c1_id = $1
                             UNION
                             (SELECT c2_id
                              FROM cons
                              NATURAL JOIN road_trip_rec))
SELECT c_name, c_date
FROM road_trip_rec
INNER JOIN concerts ON (road_trip_rec.c1_id = concerts.c_id)
ORDER BY c_date;

\prompt ' Tapez l id du concert  -> ' id
EXECUTE road_trip(:'id');
EXECUTE road_trip_eco(:'id');

\prompt ' Tapez l id du concert  -> ' id
EXECUTE road_trip(:'id');
EXECUTE road_trip_eco(:'id');




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

--la moyenne des participants dans tous les concerts
SELECT ROUND(avg(nb_participant) :: numeric, 0) FROM concerts;

--les lieux de concerts qui ont eu plus de participants que la moyenne *1,3 
SELECT host_id, ROUND(avg(nb_participant) :: numeric, 0) as moyenne_par_lieu
FROM concerts 
GROUP BY host_id
HAVING avg(nb_participant) > (SELECT avg(nb_participant) FROM concerts) * 1.3;


-- Genre subtags
DROP VIEW if exists genres_subtags;
CREATE VIEW genres_subtags AS (
	WITH RECURSIVE genres_subt AS (
		SELECT g_id, g_name, t_id, g_id origin FROM genre
		UNION
		SELECT g1.g_id g_id, g1.g_name g_name, sg.t_id t_id, sg.g_id origin
		FROM genres_subt g1
		INNER JOIN genres_relations r ON g1.origin = r.g_id
		INNER JOIN genre sg ON sg.g_id = r.sg_id
	) SELECT g_id, g_name, t_id FROM genres_subt
);

PREPARE concert_with_genre(VARCHAR) AS
SELECT c_name, c_date FROM concerts c NATURAL JOIN avis a INNER JOIN avis_tags_relations r ON r.a_id = a.a_id
WHERE r.t_id IN (SELECT t_id FROM genres_subtags WHERE g_name = $1);

\prompt ' Donnez un sous-genre de musique pour des concerts -> ' g_name
EXECUTE concert_with_genre(:'g_name');

\prompt ' Donnez un genre de musique pour des concerts -> ' g_name
EXECUTE concert_with_genre(:'g_name');

-- Afficher des utilisateurs avec beaucoup de musiques dans leur playlist 2nd having
SELECT username, COUNT(m_id) nb_musics 
FROM users u 
NATURAL JOIN playlist p 
NATURAL JOIN playlist_music_r r
GROUP BY username 
HAVING COUNT(m_id) > 13;

-- Comptez le nombres de musiques dans les playlist d'un user
PREPARE playlist_size_from(VARCHAR) AS
SELECT p.p_id, COUNT(r.m_id) 
FROM playlist p NATURAL JOIN users u 
LEFT JOIN playlist_music_r r ON r.p_id = p.p_id 
WHERE u.username = $1 
GROUP BY p.p_id;

\prompt ' Tapez un nom d utilisateur -> ' username
EXECUTE playlist_size_from(:'username');

\prompt ' Retapez à nouveau un nom d utilisateur -> ' username
EXECUTE playlist_size_from(:'username');



--Comptez le nombre de musiques dans toutes les playlists
SELECT p.p_id, COUNT(r.m_id) 
FROM playlist p 
LEFT JOIN playlist_music_r r ON r.p_id = p.p_id 
GROUP BY p.p_id;

-- Trouvez le nombre de musiques en moyenne dans les playlist ?
SELECT ROUND(AVG(music_by_p.nb_musics), 3) Nb_moyen_musics
FROM (SELECT COUNT(r.m_id) nb_musics FROM playlist p
	  LEFT JOIN playlist_music_r r ON r.p_id = p.p_id GROUP BY p.p_id) music_by_p;
