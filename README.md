
Le fichier "init.sql":
    Il contient toutes les instructions SQL nécessaires pour créer les tables de notre base de données.
    Cela inclut la définition des colonnes, des types de données, des clés primaires, des clés étrangères et d'autres contraintes.
    Chaque table est créée à l'aide de la commande CREATE TABLE, avec ses colonnes et ses contraintes spécifiées.

Le fichier "trigger.sql":
    Ce fichier regroupe les déclencheurs (triggers) que nous avons mis en place dans notre base de données.
    Les triggers sont des procédures stockées qui s'exécutent automatiquement lorsqu'un événement spécifique se produit sur une table. 
    Ils sont utilisés pour mettre en place des contraintes supplémentaires ou pour effectuer des actions spécifiques en réponse à des modifications de données.

Le fichier "prepare.sql":
    Il contient les requêtes que nous avons développées pour interroger et manipuler nos données.

Le fichier "copy.csv":
    Ce fichier contient les commandes nécessaires pour charger les données à partir de fichiers CSV dans nos tables.
    Les commandes COPY sont utilisées pour importer les données à partir des fichiers CSV dans PostgreSQL. Nous spécifions le chemin du fichier CSV et le nom de la table cible.

Les fichiers CSV:
    Ils contiennent les données que nous avons récupérées du site Mookaroo .

En organisant notre projet de cette manière, nous séparons les différentes tâches et permettons une meilleure gestion de notre base de données. On peut travailler sur chaque aspect individuellement, ce qui facilite la maintenance, la collaboration et le suivi des modifications.