CREATE TABLE jugador
(
	codigo	TEXT,
	nombre	TEXT,
	telefono	TEXT,
	PRIMARY KEY(codigo)
);

CREATE TABLE penalizacion
(
	codigo	TEXT,
	fecha		DATE,
	monto		INTEGER,
	PRIMARY KEY(codigo, fecha),
	FOREIGN KEY(codigo) REFERENCES jugador ON DELETE CASCADE ON UPDATE RESTRICT
);

INSERT INTO jugador VALUES ('A02', 'Barros', '4542-8872');
INSERT INTO jugador VALUES ('A03', 'Andrade', '4652-7618');
INSERT INTO jugador VALUES ('B04', 'Taranto', '4314-2345');
INSERT INTO jugador VALUES ('B06', 'Vilar', null);
INSERT INTO jugador VALUES ('R02', 'Sanchez', '4785-6562');
INSERT INTO jugador VALUES ('R07', 'Peirano', '4612-3332');
INSERT INTO jugador VALUES ('R11', 'Cardoso', '4314-8102');
SET DATESTYLE TO ISO, DMY;
INSERT INTO penalizacion VALUES ('B06', '24/10/2014', 120);
INSERT INTO penalizacion VALUES ('A03', '04/03/2014', 100);
INSERT INTO penalizacion VALUES ('A03', '12/05/2015', 150);
INSERT INTO penalizacion VALUES ('B04', '12/05/2015', 120);
INSERT INTO penalizacion VALUES ('R07', '15/07/2015', 100);
INSERT INTO penalizacion VALUES ('R07', '30/10/2014', 120);
INSERT INTO penalizacion VALUES ('R11', '18/07/2015', 150);
