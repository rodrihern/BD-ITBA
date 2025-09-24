-- creacion de las tablas

CREATE TABLE ALU (
    legajo INTEGER PRIMARY KEY,
    nombre VARCHAR(255)
);

CREATE TABLE MATERIA (
    codigo INTEGER PRIMARY KEY,
    nombre VARCHAR(255)
);

CREATE TABLE PROFESOR (
    legProf INTEGER PRIMARY KEY,
    nombre VARCHAR(255),
    antiguedad DATE
);

CREATE TABLE EXAMEN (
    legajo INTEGER,
    legProf INTEGER,
    nota INTEGER,
    fecha DATE,
    codigo INTEGER,
    nroActa INTEGER,
    FOREIGN KEY (legajo) REFERENCES ALU(legajo),
    FOREIGN KEY (legProf) REFERENCES PROFESOR(legProf),
    FOREIGN KEY (codigo) REFERENCES MATERIA(codigo)
);

INSERT INTO ALU (legajo, nombre) VALUES
(12000, 'Andrea Garcia'),
(12500, 'Pedro Lima'),
(11500, 'Ana Salina'),
(10500, 'Sol Roy');

INSERT INTO MATERIA (codigo, nombre) VALUES
(50, 'Programacion I'),
(20, 'Estructura y Algoritmos'),
(80, 'Base de Datos I'),
(10, 'Programacion IV');

INSERT INTO PROFESOR (legProf, nombre, antiguedad) VALUES
(533, 'Anibal Solano', '1960-10-12'),
(239, 'Martin Knuth', '1974-03-22'),
(448, 'Sara Warxel', '1980-08-17'),
(329, 'Paula Lorca', '1960-12-10');

INSERT INTO EXAMEN (legajo, legProf, nota, fecha, codigo, nroActa) VALUES
(12000, 239, 2, '2013-03-03', 80, 111),
(12000, 533, 3, '2013-03-15', 20, 676),
(12500, 533, 4, '2013-03-03', 20, 676),
(12500, 239, 5, '2013-03-03', 80, 111),
(12000, 239, 8, '2014-03-21', 80, 133),
(11500, 533, 9, '2013-03-15', 20, 676),
(11500, 239, 6, '2013-03-03', 10, 144),
(10500, 239, 8, '2013-03-03', 10, 144),
(10500, 533, 2, '2013-03-03', 20, 144),
(11500, 533, 7, '2013-03-03', 80, 111),
(12000, 448, 6, '2014-03-21', 10, 887),
(12000, 448, 8, '2014-03-21', 50, 888),
(11500, 448, 10, '2015-04-08', 50, 900);

-- 5.2) Mostrar los nombres de los alumnos a los cuales les falta aprobar algún examen. Realizarlo de dos
-- formas distintas: al estilo álgebra relacional y usando la función de agregación COUNT(*).

SELECT DISTINCT nombre
FROM ALU alu
WHERE EXISTS (
  SELECT * FROM MATERIA m
  WHERE NOT EXISTS (
    SELECT * FROM EXAMEN e
    where nota >= 4 
    AND m.codigo = e.codigo 
    AND e.legajo = alu.legajo
  )
)


SELECT nombre
FROM ALU al JOIN EXAMEN ex
ON al.legajo = ex.legajo
WHERE nota >= 4
GROUP BY al.legajo
HAVING COUNT(DISTINCT codigo) < (SELECT COUNT(*) FROM MATERIA)


-- 5.3) Mostrar los legajos de los profesores que les tomaron exámenes a todos los alumnos

SELECT legProf
FROM EXAMEN 
GROUP BY legProf
HAVING COUNT(DISTINCT legajo) = (SELECT COUNT(*) FROM ALU)

-- 5.4) Los profesores han dictado quizás más de una materia. Se pide mostrar los legajos de los profesores
-- que para una misma materia dictada han tomado exámenes a todos los alumnos en dicha materia. La salida
-- debe aparecer acompañada por el código de la materia en cuestión.

SELECT legProf, codigo
FROM EXAMEN
GROUP BY legProf, codigo
HAVING COUNT(DISTINCT legajo) = (SELECT COUNT(*) FROM ALU)

-- 5.5) Si se observan los datos en la tabla EXAMEN se está permitiendo que haya actas firmadas “por
-- renglones”. Ejemplo: el acta 144 tiene al docente con legajo 239 que firmó para ciertos alumnos y el docente
-- con legajo 533 firmó para otros alumnos.
-- Escribir una consulta que muestre cuáles son (si existen) las actas que tienen más de un profesor
-- responsable de la misma.

SELECT nroActa 
FROM EXAMEN
GROUP BY nroActa
HAVING COUNT(DISTINCT legProf) > 1