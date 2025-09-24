-- ejercicio 1

-- ejercicio 2


-- ejercicio 3 (tabla)

CREATE TABLE editorial(
    codEdit CHAR(3) NOT NULL,
    direccion TEXT,
    nombre TEXT,
    pais TEXT,
    PRIMARY KEY (codEdit)
);

CREATE TABLE libro(
    ISBN INT NOT NULL,
    titulo TEXT NOT NULL,
    autor TEXT, 
    codEdit CHAR(3),
    genero TEXT,
    precio FLOAT,
    PRIMARY KEY (ISBN),
    FOREIGN KEY (codEdit) REFERENCES editorial(codEdit)
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

CREATE TABLE factura(
    codFact INT NOT NULL,
    fecha DATE,
    monto FLOAT,
    PRIMARY KEY (codFact)
);

CREATE TABLE detalleFactura(
    codFact INT NOT NULL,
    ISBN INT NOT NULL,
    nroLinea INT NOT NULL,
    cantidad INT NOT NULL,
    PRIMARY KEY (codFact, nroLinea),
    FOREIGN KEY (codFact) REFERENCES factura(codFact)
        ON DELETE CASCADE
        ON UPDATE RESTRICT,
    FOREIGN KEY (ISBN) REFERENCES libro(ISBN)
        ON DELETE CASCADE
        ON UPDATE RESTRICT
);

INSERT INTO editorial (codEdit, direccion, nombre, pais) VALUES
('WO5', NULL, 'Addison Wesley', 'Canada'),
('XA3', NULL, 'Prentice Hall', 'USA'),
('BO3', NULL, 'Mc Graw Hill', 'USA');

INSERT INTO libro (ISBN, titulo, autor, codEdit, genero, precio) VALUES
(15030108, 'El lenguaje c', 'Kernighan', 'XA3', 'Computacion', 28.50),
(16015229, 'Perlas de prog.', 'Bentley', 'WO5', 'Computacion', 118.00),
(30111230, 'Blancanieves', NULL, 'XA3', 'Infantil', 32.30),
(18000111, 'Alicia en el pais', 'Carroll', 'BO3', 'Infantil', 52.00),
(15030109, 'Origami', 'Youtang', 'XA3', 'Manualidades', 20.00),
(16000205, 'Unix', 'Steavens', 'WO5', 'Computacion', 83.50),
(18010300, 'El bigote', 'Carriére', 'WO5', 'Novela', 53.90),
(17001030, 'Sr presidente', 'Asturias', NULL, 'Novela', 120.00);


INSERT INTO factura (codFact, fecha, monto) VALUES
(1000, '2015-09-03', 46.50),
(1001, '2015-09-03', 124.30),
(1002, '2015-09-05', 130.00),
(1003, '2015-09-30', 157.90),
(1004, '2015-09-09', 38.00);

INSERT INTO detalleFactura (codFact, nroLinea, ISBN, cantidad) VALUES
(1000, 1, 15030108, 1),
(1000, 2, 16015229, 1),
(1001, 1, 17001030, 1),
(1001, 2, 30111230, 1),
(1001, 3, 15030109, 2),
(1002, 1, 16015229, 1),
(1002, 2, 16000205, 1),
(1002, 3, 15030108, 1),
(1002, 4, 18010300, 1),
(1003, 1, 18000111, 2),
(1004, 1, 15030109, 1),
(1004, 2, 16015229, 1);
--(1004, 3, 16000000, 2); -- va a fallar por integridad referencial
 

-- Ejercicio 4

CREATE TABLE proveedor (
    nroProv INT PRIMARY KEY,
    nombre TEXT NOT NULL,
    ciudad TEXT NOT NULL
);

CREATE TABLE producto (
    codProd INT PRIMARY KEY,
    descripcion TEXT NOT NULL,
    genero TEXT NOT NULL
);

CREATE TABLE cliente (
    nroCli INT PRIMARY KEY,
    nombre TEXT NOT NULL,
    ciudad TEXT NOT NULL,
    direccion TEXT NOT NULL
);

CREATE TABLE pedido (
    nroCli INT,
    nroProv INT,
    codProd INT,
    cantidad INT NOT NULL,
    fecha DATE NOT NULL,
    PRIMARY KEY (nroCli, nroProv, codProd, fecha),
    FOREIGN KEY (nroCli) REFERENCES cliente(nroCli) ON DELETE CASCADE,
    FOREIGN KEY (nroProv) REFERENCES proveedor(nroProv) ON DELETE CASCADE,
    FOREIGN KEY (codProd) REFERENCES producto(codProd) ON DELETE CASCADE
);

-- Datos PROVEEDOR
INSERT INTO proveedor VALUES
(10, 'Importaciones ABC', 'Capital Federal'),
(20, 'Revistas Unidas', 'Rosario'),
(30, 'Distribuidora Manfretti', 'Cordoba'),
(40, 'Distribuidora PPP', 'Rosario');

-- Datos PRODUCTO
INSERT INTO producto VALUES
(1, 'Revista Gente', 'Chismes'),
(2, 'Caras', 'Chismes'),
(3, 'Foco', 'Chismes'),
(4, 'Speak Up', 'Ingles'),
(5, 'Learn English', 'Ingles'),
(6, 'El Grafico', 'Deporte'),
(7, 'Pelo', 'Musical'),
(8, '100 recetas fáciles-Arguiñano', 'Cocina'),
(9, 'Cocinando con Choly Berreteaga', 'Cocina'),
(10, 'La Nacion', 'Diario'),
(11, 'Pagina 12', 'Diario'),
(12, 'Clarin', 'Diario'),
(13, 'La Razon', 'Diario'),
(14, 'Buenos Aires Herald', 'Diario');

-- Datos CLIENTE
INSERT INTO cliente VALUES
(10, 'Felipe Garcia', 'Capital Federal', 'Tucuman 110'),
(20, 'Anastasia Le Court', 'Capital Federal', 'Alvear 1256'),
(30, 'Teodora Boorman', 'Rosario', '25 de Mayo 1400'),
(40, 'Jose Ryan', 'Rosario', '25 de Mayo 240'),
(50, 'Maria Carbajal', 'Capital Federal', 'Viamonte 6822'),
(60, 'Sonia Santillan', 'Capital Federal', 'Alem 500'),
(70, 'ITBA', 'Capital Federal', 'Madero 399'),
(80, 'Franco Ronelli', 'Rosario', 'Francia 200'),
(90, 'Monica Musso', 'Parana', 'Lima 189');

-- Datos PEDIDO
INSERT INTO pedido VALUES
(10, 10, 4, 1, '2015-06-30'),
(10, 10, 5, 3, '2015-06-30'),
(40, 30, 9, 1, '2015-09-15'),
(40, 10, 11, 4, '2014-12-10'),
(40, 10, 1, 1, '2013-12-10'),
(50, 30, 10, 1, '2014-08-02'),
(50, 40, 11, 1, '2014-10-30'),
(50, 30, 12, 1, '2014-01-31'),
(50, 30, 13, 1, '2014-08-04'),
(50, 40, 14, 1, '2014-01-31'),
(70, 40, 10, 3, '2012-02-29'),
(70, 40, 11, 3, '2012-02-29'),
(70, 40, 12, 1, '2012-02-29'),
(70, 30, 12, 2, '2012-02-18'),
(70, 40, 13, 3, '2012-02-29'),
(70, 40, 14, 3, '2012-02-29'),
(90, 40, 2, 2, '2015-09-08'),
(90, 30, 2, 1, '2013-02-10'),
(90, 30, 8, 1, '2015-06-30');