# sudo mysql < db.sql

CREATE DATABASE dbperso;
CREATE USER 'dbpersouser'@'localhost' IDENTIFIED by 'dbpersopass';
use dbperso;
CREATE TABLE personne(num_personne INT, nom_personne VARCHAR(50), prenom_personne VARCHAR(50));
INSERT INTO personne VALUES(1,"Cabras","Brigitte");
INSERT INTO personne VALUES(2,"Dianis","Jeanne");
INSERT INTO personne VALUES(3,"Kyle","Zhang");
GRANT SELECT ON dbperso.* TO 'dbpersouser'@'localhost';
FLUSH PRIVILEGES;
