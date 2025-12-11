create table producto (
        prodID int primary key,
        descripcion char(3)
);

insert into producto VALUES(10, 'PYT');
insert into producto VALUES(20, 'BUH');
insert into producto VALUES(30, 'CRE');
insert into producto VALUES(40, 'GIR');
insert into producto VALUES(50, 'TTO');
insert into producto VALUES(60, 'ABC');

create table cliente (
        clientID int primary key,
        nombre text
);

insert into cliente VALUES(921, 'Rial');
insert into cliente VALUES(1001, 'Ray');
insert into cliente VALUES(3420, 'Stewart');
insert into cliente VALUES(200, 'Shrek');
insert into cliente VALUES(933, 'Felicitas');
insert into cliente VALUES(971, 'Dumas');

create table encuestador (
        encID int primary key,
        nombre text
);

insert into encuestador VALUES(102, 'Andrade');
insert into encuestador VALUES(165, 'Hedn');
insert into encuestador VALUES(220, 'IANNYS');
insert into encuestador VALUES(370, 'Loprano');

create table log (
	prodID int,
	clientID int,
	encID int,
	fecha date,
	satisfaccion int
);

set datestyle to dmy;
insert into log VALUES(10, 921, 102, '12/10/2004', 5);
insert into log VALUES(30, 921, 102, '12/10/2004', 5);
insert into log VALUES(50, 921, 165, '16/02/2004', 5);
insert into log VALUES(10, 3420, 165, '16/02/2004', 3);
insert into log VALUES(20, 3420, 165, '18/02/2004', 7);
insert into log VALUES(30, 3420, 165, '18/02/2004', 7);
insert into log VALUES(40, 3420, 220, '12/10/2004', 9);
insert into log VALUES(50, 3420, 220, '12/10/2004', 9);
insert into log VALUES(10, 200, 102, '15/02/2004', 2);
insert into log VALUES(30, 200, 102, '15/02/2004');
insert into log VALUES(50, 933, 220, '15/02/2004', 8);
insert into log VALUES(60, 971, 370, '15/02/2004', 7);

