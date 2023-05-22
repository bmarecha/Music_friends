SET datestyle TO iso, dmy;

TRUNCATE TABLE users RESTART IDENTITY CASCADE;
TRUNCATE TABLE genre RESTART IDENTITY CASCADE;

-- /home/baptiste/random/projet_bdd
-- /home/popos/Documents/projet_bddssh

\COPY users (u_type, username, email_address) FROM '/home/baptiste/random/projet_bdd/users.csv' CSV HEADER;

\COPY concerts (host_id,c_name,price,c_date,nb_seat,c_cause,v_need,nb_participant) FROM '/home/baptiste/random/projet_bdd/concert.csv' CSV HEADER;

\COPY friends (id_f1, id_f2) FROM '/home/baptiste/random/projet_bdd/friendship.csv' CSV HEADER

\COPY organisation_relation (u_id,c_id) FROM '/home/baptiste/random/projet_bdd/organisation_relation.csv' CSV HEADER;

\COPY interet (u_id,c_id,participation) FROM '/home/baptiste/random/projet_bdd/interet.csv' CSV HEADER

\COPY media (m_type,pathname,c_id) FROM '/home/baptiste/random/projet_bdd/media.csv' CSV HEADER

\COPY genre (g_name) FROM '/home/baptiste/random/projet_bdd/genre.csv' CSV HEADER

\COPY genres_relations (sg_id, g_id) FROM '/home/baptiste/random/projet_bdd/sgenre_relations.csv' CSV HEADER

\COPY music (m_name,g_id,u_id) FROM '/home/baptiste/random/projet_bdd/musics.csv' CSV HEADER

\COPY playlist (p_name,u_id) FROM '/home/baptiste/random/projet_bdd/playlists.csv' CSV HEADER

\COPY playlist_music_r (m_id,p_id) FROM '/home/baptiste/random/projet_bdd/musics_p_r.csv' CSV HEADER

\COPY avis (c_id,a_date,note,u_id,comment) FROM '/home/baptiste/random/projet_bdd/avis.csv' CSV HEADER

\COPY avis_tags_relations (t_id, a_id) FROM '/home/baptiste/random/projet_bdd/avis_tags.csv' CSV HEADER