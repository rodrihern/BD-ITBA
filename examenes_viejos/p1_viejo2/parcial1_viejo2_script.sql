-- TABLAS

CREATE TABLE cliente(
        dni int,
        nombre text NOT NULL,
        ciudad text NOT NULL,
        PRIMARY KEY (dni)
);

insert into cliente values(44, 'Anabella Luzuriaga', 'USHUAIA');
insert into cliente values(32, 'Manuel Ruiz', 'CABA');
insert into cliente values(27, 'Santiago López', 'LA PLATA');
insert into cliente values(35, 'Luciana Martínez', 'ROSARIO');
insert into cliente values(76, 'José Pelman', 'ROSARIO');
insert into cliente values(12, 'Greta Báez', 'USHUAIA');

CREATE TABLE auto(
        patente text,
        marca text not null,
        modelo text not null,
        color text not null,
        PRIMARY KEY (patente)
);

insert into auto values('fyi654', 'Chevrolet', 'Corsa', 'gris');
insert into auto values('omg987', 'Ford', 'Fiesta', 'azul');
insert into auto values('vip195', 'VW', 'Vento', 'gris');
insert into auto values('aka654', 'VW', 'Suran', 'beige');
insert into auto values('lol123', 'Honda', 'Civic', 'beige');
insert into auto values('mib111', 'Honda', 'Civic', 'azul');

CREATE TABLE alquila(
        dni int,
        patente text,
        fechaR date not null,
        ciudadR text not null,
        fechaD date,
        ciudadD text,
        km int,
        PRIMARY KEY(dni, patente, fechaR),
        FOREIGN KEY (dni) REFERENCES cliente(dni),
        FOREIGN KEY (patente) REFERENCES auto(patente)      
);

insert into alquila values(44, 'vip195', to_date('15/03/2015','DD/MM/YYYY'), 'BARILOCHE');
insert into alquila values(35, 'fyi654', to_date('10/03/2015','DD/MM/YYYY'), 'CABA', to_date('11/03/2015','DD/MM/YYYY'), 'ROSARIO', '660');
insert into alquila values(32, 'fyi654', to_date('14/01/2015','DD/MM/YYYY'), 'CABA', to_date('18/01/2015','DD/MM/YYYY'), 'CABA', '990');
insert into alquila values(32, 'aka654', to_date('14/02/2015','DD/MM/YYYY'), 'VIEDMA', to_date('15/02/2015','DD/MM/YYYY'), 'VIEDMA', '200');
insert into alquila values(27, 'omg987', to_date('20/03/2015','DD/MM/YYYY'), 'ROSARIO', to_date('22/03/2015','DD/MM/YYYY'), 'LA PLATA', '600');
insert into alquila values(35, 'lol123', to_date('02/02/2015','DD/MM/YYYY'), 'MENDOZA', to_date('09/02/2015','DD/MM/YYYY'), 'CORDOBA', '1300');
insert into alquila values(32, 'lol123', to_date('05/01/2015','DD/MM/YYYY'), 'CORDOBA', to_date('08/01/2015','DD/MM/YYYY'), 'MENDOZA', '330');
insert into alquila values(27, 'fyi654', to_date('04/02/2015','DD/MM/YYYY'), 'CABA', to_date('07/02/2015','DD/MM/YYYY'), 'CABA', '850');
insert into alquila values(27, 'lol123', to_date('13/02/2015','DD/MM/YYYY'), 'CORDOBA', to_date('20/02/2015','DD/MM/YYYY'), 'CABA', '1200');
insert into alquila values(27, 'fyi654', to_date('10/02/2015','DD/MM/YYYY'), 'CABA', to_date('12/02/2015','DD/MM/YYYY'), 'CABA', '700');
insert into alquila values(12, 'mib111', to_date('08/04/2015','DD/MM/YYYY'), 'USHUAIA', to_date('09/04/2015','DD/MM/YYYY'), 'USHUAIA', '300');
insert into alquila values(12, 'mib111', to_date('15/04/2015','DD/MM/YYYY'), 'CORDOBA', to_date('17/04/2015','DD/MM/YYYY'), 'USHUAIA', '1200');
insert into alquila values(12, 'mib111', to_date('20/04/2015','DD/MM/YYYY'), 'USHUAIA');

-- 1.1
-- Mostrar cada DNI acompañado por la cantidad de colores distintos de autos que alquiló sólo para
-- aquellos clientes que nunca han alquilado un auto azul (sin importar si lo devolvieron o no)
-- Se pide que los clientes que nunca alquilaron nada no aparezcan en el resultado.

SELECT DNI, COUNT(DISTINCT color) AS cantidad
FROM ALQUILA a JOIN AUTO c
ON a.patente = c.patente
GROUP BY DNI
HAVING DNI NOT IN (
    SELECT DNI 
    FROM ALQUILA x JOIN AUTO y
    ON x.patente = y.patente
    WHERE y.color = 'azul'
);

-- 1.2)
-- Listar las patentes de los autos que sólo fueron devueltos en la ciudad de residencia del conductor. Es
-- decir, que nunca fueron devueltos en una ciudad distinta a la de residencia del conductor.
-- Realizar este cálculo excluyendo del análisis las tuplas en las cuales los autos todavía no fueron devueltos

SELECT DISTINCT patente 
FROM ALQUILA
where fechaD IS NOT NULL
AND patente NOT IN (
    SELECT patente
    FROM alquila a JOIN cliente c
    ON a.DNI = c.DNI
    WHERE a.ciudadD <> c.ciudad
);

-- 1.3)
-- Crear la vista KILOMETROS que contenga para cada cliente, la suma de los km realizados con sus
-- autos alquilados, sólo para los clientes que no superan la suma de 1600 kms.
-- Para este cálculo deben tomarse las personas de la tabla Cliente. Los autos no devueltos se consideran
-- para este cálculo con recorrido 0(cero). Los clientes que no alquilan autos se consideran para este cálculo con
-- recorrido 0(cero).

CREATE VIEW KILOMETROS (dni, kms)
AS
SELECT c.dni, SUM(CASE WHEN a.km IS NULL THEN 0 ELSE a.km END)
FROM CLIENTE c LEFT OUTER JOIN ALQUILA a
ON c.dni = a.dni
GROUP BY c.DNI
HAVING SUM(CASE WHEN a.km IS NULL THEN 0 ELSE a.km END) < 1600;


SELECT * FROM KILOMETROS;

-- 1.4)
-- Para obtener el promedio de kilómetros recorridos por día por un auto, se calcula la suma de sus
-- kilómetros recorridos en todos sus alquileres y se lo divide por la suma de la cantidad de días en que el auto
-- estuvo alquilado.
-- Tomando como base este promedio, se dice que un auto pertenece a:
-- 4
-- Categoría 1 si el promedio de kilómetros recorridos por día es menor que 200, es decir, en el intervalo
-- [0,200),
-- Categoría 2 si el promedio de kilómetros recorridos por día está en el intervalo 
-- [200, 300),
-- Categoría 3 si el promedio de kilómetros recorridos por día es mayor o igual a 300, es decir, en el intervalo
-- [300, ∞)
-- No se deben tener en cuenta los autos que aún no han sido devueltos.
-- Se pide obtener la suma total de los kilómetros recorridos por los autos alquilados, correspondientes a las
-- categorías antes mencionadas.
-- En el resultado se debe mostrar Categoría y Cantidad de kilómetros

WITH PromediosPorAuto AS (
  SELECT
    patente,
    SUM(km) AS total_km,
    SUM(fechaD - fechaR) AS total_dias
  FROM ALQUILA
  WHERE fechaD IS NOT NULL -- No se tienen en cuenta autos no devueltos
  GROUP BY patente
)
SELECT
  CASE
    WHEN (total_km / total_dias) < 200 THEN 'Cat 1'
    WHEN (total_km / total_dias) < 300 THEN 'Cat 2'
    ELSE 'Cat 3'
  END AS Categoria,
  SUM(total_km) AS kms
FROM PromediosPorAuto
GROUP BY Categoria
ORDER BY Categoria

