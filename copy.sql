COPY users (u_type, username, email_address)
FROM '/home/baptiste/random/projet_bdd/users.csv' CSV HEADER;

COPY friends (id_f1, id_f2)
FROM '/home/baptiste/random/projet_bdd/friendship.csv' CSV HEADER