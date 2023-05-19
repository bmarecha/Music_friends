SET datestyle TO iso, dmy;

-- /home/baptiste/random/projet_bdd/
-- /home/popos/Documents/projet_bddssh/

\COPY users (u_type, username, email_address) FROM '/home/popos/Documents/projet_bddssh/users.csv' CSV HEADER;

\COPY concerts (host_id,c_name,price,c_date,nb_seat,c_cause,v_need,nb_participant) FROM '/home/popos/Documents/projet_bddssh/concert.csv' CSV HEADER;

\COPY friends (id_f1, id_f2) FROM '/home/popos/Documents/projet_bddssh/friendship.csv' CSV HEADER

\COPY organisation_relation (u_id,c_id) FROM '/home/popos/Documents/projet_bddssh/organisation_relation.csv' CSV HEADER;

\COPY interet (u_id,c_id,participation) FROM '/home/popos/Documents/projet_bddssh/interet.csv' CSV HEADER

\COPY media (m_type,pathname,c_id) FROM '/home/popos/Documents/projet_bddssh/media.csv' CSV HEADER

\COPY genre (g_name) FROM '/home/popos/Documents/projet_bddssh/genre.csv' CSV HEADER