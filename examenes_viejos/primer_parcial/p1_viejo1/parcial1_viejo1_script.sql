-- TABLAS


create table libroo4f (
        ISBN text,
        descrip text,
        primary key(ISBN)
       )
;

insert into libroo4f VALUES('007213495X', 'XML Handbook');
insert into libroo4f VALUES('8448130340', 'Manual Oracle');
insert into libroo4f VALUES('0072229527', 'Oracle 10G');
insert into libroo4f VALUES('0471701467', 'Thinking Recursively');
insert into libroo4f VALUES('0201545411', 'Abstractions');
insert into libroo4f VALUES('0764568744', 'Java 1.5');
insert into libroo4f VALUES('0672318288', 'DB2');       


create table autor (
        autorID int,
        nombre text,
        primary key(autorID)
       )
;

insert into autor VALUES(01, 'Chang');
insert into autor VALUES(02, 'Scardina');
insert into autor VALUES(03, 'Kiritzov');
insert into autor VALUES(04, 'Wang');
insert into autor VALUES(05, 'Roberts');
insert into autor VALUES(06, 'Horton');
insert into autor VALUES(07, 'Mullins');

create table autoria (
        ISBN text,
        autorID int,
        primary key(ISBN,autorID),
        foreign key(ISBN) references libroo4f (ISBN),
        foreign key(autorID) references autor (autorID)
       )
;

insert into autoria VALUES('007213495X', 01);
insert into autoria VALUES('007213495X', 02);
insert into autoria VALUES('007213495X', 03);
insert into autoria VALUES('8448130340', 01);
insert into autoria VALUES('0072229527', 03);
insert into autoria VALUES('0072229527', 01);
insert into autoria VALUES('0072229527', 04);
insert into autoria VALUES('0471701467', 05);
insert into autoria VALUES('0201545411', 05);
insert into autoria VALUES('0764568744', 06);
insert into autoria VALUES('0672318288', 07);


create table ejemplar (
        ISBN text,
        subnumero int,
        primary key(ISBN,subnumero),
        foreign key(ISBN) references libroo4f (ISBN)
        )
;

insert into ejemplar VALUES('007213495X',03);
insert into ejemplar VALUES('8448130340',01);
insert into ejemplar VALUES('8448130340',04);
insert into ejemplar VALUES('8448130340',05);
insert into ejemplar VALUES('8448130340',06);
insert into ejemplar VALUES('0471701467',01);
insert into ejemplar VALUES('0471701467',02);
insert into ejemplar VALUES('0471701467',03);
insert into ejemplar VALUES('0201545411',01);
insert into ejemplar VALUES('0764568744',01);
insert into ejemplar VALUES('0764568744',02);
insert into ejemplar VALUES('0764568744',03);
insert into ejemplar VALUES('0672318288',02);
insert into ejemplar VALUES('0672318288',04);

create table prestamo (
        legajo text,
        ISBN text,
        subnumero int,
        fechaPrestamo timestamp,
        fechaDevolucion timestamp,
        primary key(ISBN,subnumero,fechaPrestamo),
        foreign key(ISBN,subnumero) references ejemplar (ISBN,subnumero)
        )
;

insert into prestamo VALUES(111,'007213495X',3,to_timestamp('2005-04-16 08:00','YYYY-MM-DD HH24:MI'),to_timestamp('2005-04-16 11:00','YYYY-MM-DD HH:MI'));
insert into prestamo VALUES(111,'007213495X',3,to_timestamp('2005-04-16 15:00','YYYY-MM-DD hh24:MI'),Null);
insert into prestamo VALUES(222,'8448130340',1,to_timestamp('2005-04-16 08:30','YYYY-MM-DD hh24:MI'),to_timestamp('2005-04-16 09:00','YYYY-MM-DD hh24:MI'));
insert into prestamo VALUES(111,'8448130340',1,to_timestamp('2005-04-16 10:00','YYYY-MM-DD hh24:MI'),Null);
insert into prestamo VALUES(222,'8448130340',5,to_timestamp('2005-04-16 15:00','YYYY-MM-DD hh24:MI'),Null);
insert into prestamo VALUES(333,'8448130340',6,to_timestamp('2005-04-20 15:01','YYYY-MM-DD hh24:MI'),Null);
insert into prestamo VALUES(333,'0471701467',1,to_timestamp('2005-04-20 15:04','YYYY-MM-DD hh24:MI'),Null);
insert into prestamo VALUES(444,'0764568744',1,to_timestamp('2005-04-20 12:04','YYYY-MM-DD hh24:MI'),to_timestamp('2005-04-27 14:04','YYYY-MM-DD hh24:MI'));
insert into prestamo VALUES(222,'0764568744',3,to_timestamp('2005-04-20 11:00','YYYY-MM-DD hh24:MI'),to_timestamp('2005-04-20 15:00','YYYY-MM-DD hh24:MI'));
insert into prestamo VALUES(222,'0764568744',1,to_timestamp('2005-05-21 10:00','YYYY-MM-DD hh24:MI'),to_timestamp('2005-05-29 15:00','YYYY-MM-DD hh24:MI'));
insert into prestamo VALUES(555,'0672318288',2,to_timestamp('2005-02-01 12:00','YYYY-MM-DD hh24:MI'),to_timestamp('2005-02-02 12:00','YYYY-MM-DD hh24:MI'));
insert into prestamo VALUES(555,'0672318288',4,to_timestamp('2005-02-25 12:00','YYYY-MM-DD hh24:MI'),to_timestamp('2005-02-28 10:00','YYYY-MM-DD hh24:MI'));

-- 1.1)
-- Listar los nombres de los autores que siempre han escrito libros sin compartir autoría (o sea siempre
-- escribieron libros solos). Los nombres deben aparecer una sola vez en el listado. Asumir que no hay autores
-- que están en la tabla AUTORES y no aparezcan en la tabla AUTORIA.

-- sin count

SELECT a.nombre
FROM AUTOR a
WHERE EXISTS (
  SELECT b.ISBN
  FROM AUTORIA b
  WHERE b.autorID = a.autorID
)
AND NOT EXISTS (
  SELECT x.ISBN
  FROM AUTORIA x
  WHERE x.autorID = a.autorID
    AND EXISTS (
      SELECT y.autorID
      FROM AUTORIA y
      WHERE y.ISBN = x.ISBN
        AND y.autorID <> a.autorID
    )
);

-- con count

SELECT nombre
FROM autor
WHERE autorid NOT IN (
    -- Paso 2: Seleccionar todos los autores que participaron en los libros coescritos
    SELECT DISTINCT autorid
    FROM autoria
    WHERE isbn IN (
        -- Paso 1: Obtener la lista de ISBN de todos los libros coescritos
        SELECT isbn
        FROM autoria
        GROUP BY isbn
        HAVING COUNT(autorid) > 1
    )
);

-- 1.2)
-- Sólo para aquellos alumnos cuyo porcentaje de ejemplares todavía retenidos en su poder respecto de
-- los ejemplares que algunas vez sacaron en préstamo (no importa si fueron o no devueltos) supere el 50%,
-- escribir una consulta SQL en DB2 para obtener un listado de dos columnas llamadas LEGAJO y
-- PORCENTAJE, obviamente la primera con el legajo y la segunda con el porcentaje junto al símbolo %.

SELECT legajo, (SUM(CASE WHEN fechadevolucion IS NULL THEN 1.0 ELSE 0.0 END) / COUNT(*))* 100 AS porcentaje
FROM prestamo
GROUP BY legajo
HAVING (SUM(CASE WHEN fechadevolucion IS NULL THEN 1.0 ELSE 0.0 END) / COUNT(*)) * 100 > 50;

-- 1.3) 
-- Solamente para aquellos libros (no ejemplar) tal que no tengan ejemplares fuera de la biblioteca,
-- calcular el máximo período (en cantidad de días) en que el libro permaneció prestado (para este cálculo no
-- distinguir entre sus ejemplares). Para ellos se pide escribir una consulta SQL en DB2 y obtener un listado de
-- dos columnas llamadas ISBN y PERIODOMAXIMO, obviamente la primera con el ISBN y la segunda con el
-- periodo máximo en días que duró el préstamo. Tener en cuenta que no debe aparecer en el listado aquellos
-- libros que nunca fueron devueltos.

SELECT ISBN, MAX(periodo) AS max_periodo
FROM (
    SELECT ISBN, CAST(fechaDevolucion AS DATE)- CAST(fechaPrestamo AS DATE) AS periodo 
    FROM PRESTAMO
    WHERE ISBN NOT IN (
        SELECT ISBN
        FROM PRESTAMO
        WHERE fechaDevolucion IS NULL
    )
)
GROUP BY ISBN;


-- 1.4)
-- Se quiere saber cuál es la descripción de los libros tal que todos sus ejemplares catalogados en la
-- biblioteca fueron prestados por lo menos alguna vez a una misma persona. Escribir la consulta SQL DB2 que
-- permita obtener este resultado ordenado descendentemente por descripción

SELECT lib.descrip
FROM libroo4f as lib
WHERE lib.ISBN IN (
    SELECT x.ISBN
    FROM prestamo x
    GROUP BY x.ISBN, x.legajo
    HAVING COUNT(DISTINCT x.subNumero) = (
        SELECT COUNT(z.subNumero) FROM ejemplar z WHERE z.ISBN = x.ISBN
    )
)
ORDER BY lib.descrip DESC;

-- 1.5)
-- Averiguar cuáles son los libros tal que todas las veces que tuvieron ejemplares en préstamo ya
-- devueltos, su demora no fue mayor a 24 horas. Solo listar ISBN sin repetirlos.

SELECT DISTINCT ISBN
FROM PRESTAMO
WHERE fechaDevolucion IS NOT NULL
AND ISBN NOT IN (
    SELECT ISBN
    FROM PRESTAMO
    WHERE CAST(fechaDevolucion as DATE) - cast(fechaPrestamo as DATE) >= 1
);