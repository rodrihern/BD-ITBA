CREATE TABLE cliente(
        codigo varchar(5),
        razonsocial text,
        PRIMARY KEY (codigo)
);

insert into cliente values('A531', 'La Anonima S.A.I.E.P'); 
insert into cliente values('A958', 'Carrefour Argentina S.A.'); 
insert into cliente values('A561', 'Cencosud S.A.');
insert into cliente values('A256', 'Dinosaurio S.A.'); 
insert into cliente values('A124', 'COTO S.A.'); 
insert into cliente values('A888', 'ITBA');

CREATE TABLE consultor(
        codigo int,
        nombre text,
        PRIMARY KEY (codigo)
);

insert into consultor values(4562, 'Martinez, Julian'); 
insert into consultor values(5687, 'Juarez, Manuel'); 
insert into consultor values(3245, 'Uranga, Maria Paz'); 
insert into consultor values(9566, 'Casares Ulloa, Ayelen');
insert into consultor values(1457, 'Benitez, Agustin');

CREATE TABLE servicio(
        codigo varchar(5),
        descripcion text unique not null,
        precio int,
        PRIMARY KEY (codigo)        
);

insert into servicio values('H0001', 'Analisis', 300); 
insert into servicio values('H0003', 'Desarrollo', 450); 
insert into servicio values('H0005', 'Testing', 300);
insert into servicio values('H0006', 'Capacitacion', 350);
insert into servicio values('H0007', 'Mantenimiento', 300);

CREATE TABLE hora(
        consultor int,
        cliente varchar(5),
        tiposervicio varchar(5),
        fecha date,
        cantidad int,
        PRIMARY KEY(consultor, cliente, tiposervicio, fecha),
        FOREIGN KEY (consultor) REFERENCES consultor(codigo),
        FOREIGN KEY (cliente) REFERENCES cliente(codigo),
        FOREIGN KEY (tiposervicio) REFERENCES servicio(codigo)
);

insert into hora values (9566, 'A124', 'H0001', '16-SEP-12', 6);
insert into hora values (5687, 'A531', 'H0005', '02-AUG-12', 8);
insert into hora values (9566, 'A256', 'H0001', '03-AUG-12', 8);
insert into hora values (1457, 'A124', 'H0007', '04-AUG-12', 6);
insert into hora values (9566, 'A124', 'H0003', '17-SEP-12', 8);
insert into hora values (9566, 'A124', 'H0005', '20-SEP-12', 8);
insert into hora values (5687, 'A531', 'H0005', '07-AUG-12', 8);
insert into hora values (5687, 'A531', 'H0005', '08-AUG-12', 8);
insert into hora values (5687, 'A561', 'H0006', '10-OCT-12', 8);
insert into hora values (5687, 'A531', 'H0005', '10-AUG-12', 8);
insert into hora values (9566, 'A256', 'H0003', '11-AUG-12', 6);
insert into hora values (5687, 'A561', 'H0006', '11-OCT-12', 8);
insert into hora values (5687, 'A531', 'H0005', '13-AUG-12', 6);
insert into hora values (9566, 'A256', 'H0003', '14-AUG-12', 8);
insert into hora values (5687, 'A561', 'H0006', '12-OCT-12', 8);
insert into hora values (3245, 'A124', 'H0006', '30-AUG-12', 8);
insert into hora values (5687, 'A531', 'H0005', '18-AUG-12', 6);
insert into hora values (1457, 'A124', 'H0007', '19-AUG-12', 5);
insert into hora values (5687, 'A531', 'H0005', '21-AUG-12', 8);
insert into hora values (1457, 'A124', 'H0007', '24-OCT-12', 6);
insert into hora values (9566, 'A256', 'H0005', '25-AUG-12', 4);
insert into hora values (1457, 'A124', 'H0007', '26-OCT-12', 8);
insert into hora values (5687, 'A124', 'H0006', '29-AUG-12', 8);
insert into hora values (9566, 'A256', 'H0006', '30-AUG-12', 6);
insert into hora values (3245, 'A958', 'H0006', '01-SEP-12', 8);
insert into hora values (3245, 'A561', 'H0006', '02-SEP-12', 8);
insert into hora values (3245, 'A561', 'H0006', '03-SEP-12', 8);
insert into hora values (3245, 'A561', 'H0006', '04-SEP-12', 8);
insert into hora values (3245, 'A561', 'H0006', '05-SEP-12', 8);
insert into hora values (1457, 'A256', 'H0006', '05-SEP-12', 8);
insert into hora values (1457, 'A256', 'H0007', '15-SEP-12', 8);
insert into hora values (9566, 'A531', 'H0005', '10-MAY-13', 2);
insert into hora values (9566, 'A561', 'H0006', '15-JUL-13', 1);



CREATE TABLE dependencias(
        etapa text,
        dependeDe text,
        PRIMARY KEY (etapa, dependeDe)
);

insert into dependencias values ('Preparación del lugar', 'Selección del lugar');
insert into dependencias values ('Fabricación del generador', 'Selección de proveedores');
insert into dependencias values ('Instalar el generador', 'Preparación del lugar');
insert into dependencias values ('Instalar el generador', 'Fabricación del generador');
insert into dependencias values ('Entrenar operarios', 'Selección de personal');
insert into dependencias values ('Entrenar operarios', 'Preparación del manual de operaciones');
insert into dependencias values ('Obtención de licencia', 'Instalar el generador');
insert into dependencias values ('Obtención de licencia', 'Entrenar operarios');
insert into dependencias values ('Obtención de licencia', 'Obtención del permiso ambiental');