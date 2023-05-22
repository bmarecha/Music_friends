— une requête qui porte sur au moins trois tables ; x

— une ’auto jointure’ ou ’jointure réflexive’ (jointure de deux copies d’une même table)
— une sous-requête corrélée ;

— une sous-requête dans le FROM ; x 

— une sous-requête dans le WHERE ;

— deux agrégats nécessitant GROUP BY et HAVING ;

— une requête impliquant le calcul de deux agrégats (par exemple, les moyennes d’un ensemble de
maximums) ;

— une jointure externe (LEFT JOIN, RIGHT JOIN ou FULL JOIN) ;

— deux requêtes équivalentes exprimant une condition de totalité, l’une avec des sous requêtes corré-
lées et l’autre avec de l’agrégation ;

— deux requêtes qui renverraient le même résultat si vos tables ne contenaient pas de nulls, mais
qui renvoient des résultats différents ici (vos données devront donc contenir quelques nulls), vous
proposerez également de petites modifications de vos requêtes (dans l’esprit de ce qui sera présenté
dans le cours sur l’information incomplète) afin qu’elles retournent le même résultat ; x x

— une requête récursive x

— une requête utilisant du fenêtrage (par exemple, pour chaque mois de 2022, les dix groupes dont
les concerts ont eu le plus de succès ce mois-ci, en termes de nombre d’utilisateurs ayant indiqué
souhaiter y participer).