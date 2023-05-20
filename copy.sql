SET datestyle TO iso, dmy;

-- /home/baptiste/random/projet_bdd
-- /home/popos/Documents/projet_bddssh

\COPY users (u_type, username, email_address) FROM '/home/baptiste/random/projet_bdd/users.csv' CSV HEADER;

\COPY concerts (host_id,c_name,price,c_date,nb_seat,c_cause,v_need,nb_participant) FROM '/home/baptiste/random/projet_bdd/concert.csv' CSV HEADER;

\COPY friends (id_f1, id_f2) FROM '/home/baptiste/random/projet_bdd/friendship.csv' CSV HEADER

\COPY organisation_relation (u_id,c_id) FROM '/home/baptiste/random/projet_bdd/organisation_relation.csv' CSV HEADER;

\COPY interet (u_id,c_id,participation) FROM '/home/baptiste/random/projet_bdd/interet.csv' CSV HEADER

\COPY media (m_type,pathname,c_id) FROM '/home/baptiste/random/projet_bdd/media.csv' CSV HEADER

\COPY genre (g_name) FROM '/home/baptiste/random/projet_bdd/genre.csv' CSV HEADER
