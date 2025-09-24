CREATE TABLE alumno 
(
legajo  INT, 
nombre  TEXT, 
sexo 	TEXT, 
carrera TEXT, 
PRIMARY KEY(legajo)
);

CREATE TABLE curso
(
codigo  INT,
nombre  TEXT,
PRIMARY KEY(codigo)
);

CREATE TABLE inscripcion
(
codigo 	INT,
legajo 	INT,
anio 	INT,
PRIMARY KEY(codigo, legajo, anio),
FOREIGN KEY(codigo) REFERENCES curso ON DELETE CASCADE ON UPDATE RESTRICT,
FOREIGN KEY(legajo) REFERENCES alumno ON DELETE CASCADE ON UPDATE RESTRICT
);

/*Datos de la tabla alumno*/
INSERT INTO alumno VALUES (30001, 'Lopez, Ana', 'F', 'informatica');
INSERT INTO alumno VALUES (30002, 'Garcia, Juan', 'M', 'electronica');
INSERT INTO alumno VALUES (30003, 'Arevalo, Jose', 'M', 'electronica');
INSERT INTO alumno VALUES (30004, 'Abrojos, Paula', 'F', 'informatica');
INSERT INTO alumno VALUES (30005, 'Patan, Pamela', 'F', 'informatica');

/*Datos de la tabla curso*/
INSERT INTO curso VALUES (1, 'Base de Datos I');
INSERT INTO curso VALUES (2, 'Programacion I');
INSERT INTO curso VALUES (3, 'Estructuras y Algoritmos');
INSERT INTO curso VALUES (4, 'Introduccion a la Computacion');
INSERT INTO curso VALUES (5, 'Programacion IV');

/*Datos de la tabla inscripcion*/
INSERT INTO inscripcion VALUES (1, 30001, 2014);
INSERT INTO inscripcion VALUES (1, 30005, 2014);
INSERT INTO inscripcion VALUES (2, 30001, 2014);
INSERT INTO inscripcion VALUES (2, 30002, 2014);
INSERT INTO inscripcion VALUES (3, 30001, 2015);
INSERT INTO inscripcion VALUES (3, 30005, 2015);
INSERT INTO inscripcion VALUES (4, 30001, 2015);
INSERT INTO inscripcion VALUES (4, 30002, 2014);
INSERT INTO inscripcion VALUES (4, 30002, 2015);
INSERT INTO inscripcion VALUES (4, 30005, 2014);
INSERT INTO inscripcion VALUES (5, 30001, 2015);
INSERT INTO inscripcion VALUES (5, 30005, 2015);
INSERT INTO inscripcion VALUES (5, 30005, 2014);
INSERT INTO inscripcion VALUES (5, 30003, 2014);