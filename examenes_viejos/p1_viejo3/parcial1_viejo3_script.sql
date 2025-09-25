-- TABLAS

CREATE TABLE receta(
     id int,
     descripcion text,
     porcion int,
     PRIMARY KEY(id)
);

insert into receta values (1,'Lemon Pie', 4); 
insert into receta values (2, 'Pan Arabe', 3); 
insert into receta values (3, 'Tallarines', 4);

CREATE TABLE ingrediente(
        nombre text,
        gramaje int,
        precio float,
        PRIMARY KEY (nombre) 
);

insert into ingrediente values('Limon', 1000, 0.8); 
insert into ingrediente values('Harina', 500, 1); 
insert into ingrediente values('Manteca', 200, 1.3); 
insert into ingrediente values('Leche', 1000, 1); 
insert into ingrediente values('Azucar', 500, 1.3); 
insert into ingrediente values('Huevo', 100, 0.5); 
insert into ingrediente values('Agua', 100, 0); 

CREATE TABLE FormadaPor(
        id int,
        nombre text,
        cantidad int,
        PRIMARY KEY (id, nombre),
        FOREIGN KEY (id) references receta(id),
        FOREIGN KEY (nombre) references ingrediente(nombre)
);

insert into FormadaPor values(1, 'Limon', 200); 
insert into FormadaPor values(1, 'Harina', 1000); 
insert into FormadaPor values(1, 'Manteca', 200); 
insert into FormadaPor values(1, 'Leche', 600); 
insert into FormadaPor values(1, 'Azucar', 50); 
insert into FormadaPor values(1, 'Huevo', 200); 
insert into FormadaPor values(1, 'Agua', 100); 
insert into FormadaPor values(3, 'Huevo', 200); 
insert into FormadaPor values(3, 'Harina', 1500); 
insert into FormadaPor values(3, 'Agua', 100); 
insert into FormadaPor values(2, 'Agua', 400); 
insert into FormadaPor values(2, 'Harina', 1000); 

-- 4.1
-- Escribir una consulta SQL en DB2 para  mostrar los  nombres de los ingredientes tales que en todas 
-- las  recetas  en  las  cuales  lograron  intervenir  lo  hacen  en  una  proporción  correspondiente  a  por  lo  menos  el  
-- 20% de la composición (en gramos) de dicha receta.

WITH tot AS (
  SELECT id, SUM(cantidad) AS total_gramos
  FROM FormadaPor
  GROUP BY id
)
SELECT f.nombre
FROM FormadaPor f
JOIN tot t ON t.id = f.id
GROUP BY f.nombre
HAVING MIN( f.cantidad * 1.0 / t.total_gramos ) >= 0.20;


-- 4.2
-- Escribir una consulta SQL en DB2 para mostrar el nombre de cada receta y cuanto costaría preparar 
-- una  sola  porción  de  la  misma,  sólo  para  aquellas  recetas  que  lleven  no  más  de  4  productos  en  su  
-- composición.

WITH pocos_ingredientes AS (
  SELECT id
  FROM FormadaPor
  GROUP BY id
  HAVING COUNT(*) <= 4
)

SELECT DISTINCT descripcion, (
	SUM(f.cantidad * i.precio / i.gramaje) / r.porcion
) as cuesta
FROM ingrediente i JOIN FormadaPor f 
ON i.nombre = f.nombre JOIN receta r ON r.id = f.id
WHERE r.id IN (SELECT id FROM pocos_ingredientes)
GROUP BY f.id, r.descripcion, r.porcion;

