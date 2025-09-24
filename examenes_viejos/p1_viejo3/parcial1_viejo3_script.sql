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
        cant int,
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
