SET datestyle TO iso, dmy;

\COPY users (u_type, username, email_address) FROM '/home/popos/Documents/projet_bddssh/users.csv' CSV HEADER;

\COPY concerts (host_id,c_name,price,c_date,nb_seat,nb_participant,c_cause,v_need) FROM '/home/popos/Documents/projet_bddssh/concerts.csv' CSV HEADER;

\COPY friends (id_f1, id_f2) FROM '/home/popos/Documents/projet_bddssh/friendship.csv' CSV HEADER