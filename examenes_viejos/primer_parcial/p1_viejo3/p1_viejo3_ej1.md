# Ejercicio 1

## 1.1

```sql
-- CLIENTE (no dan clave -> uso todos sus atributos como PK)
CREATE TABLE Cliente (
  nombre     TEXT   NOT NULL,
  direccion  TEXT   NOT NULL,
  PRIMARY KEY (nombre, direccion)
);

-- PELICULA
CREATE TABLE Pelicula (
  id       INTEGER    PRIMARY KEY,
  genero   TEXT       NOT NULL,
  titulo   TEXT       NOT NULL,
  duracion INTEGER    NOT NULL
);

-- FACTURA
CREATE TABLE Factura (
  id     INTEGER  PRIMARY KEY,
  fecha  DATE     NOT NULL,
  -- compradoPor: N (Factura) a 1 (Cliente) -> FK en Factura
  cliente_nombre    TEXT   NOT NULL,
  FOREIGN KEY (cliente_nombre)
    REFERENCES Cliente(nombre)
);

-- DETALLEFACTURA (entidad débil respecto de Factura)
-- nroLinea es clave parcial -> PK = (factura_id, nroLinea)
-- correspondeA: N (Detalle) a 1 (Pelicula) -> FK a Pelicula
-- tiene: N (Detalle) a 1 (Factura) -> FK a Factura
CREATE TABLE DetalleFactura (
  factura_id     INTEGER NOT NULL,
  nroLinea       INTEGER NOT NULL,
  cantidad       INTEGER NOT NULL,
  precioXunidad  NUMERIC NOT NULL,
  pelicula_id    INTEGER NOT NULL,
  PRIMARY KEY (factura_id, nroLinea),
  FOREIGN KEY (factura_id)  REFERENCES Factura(id),
  FOREIGN KEY (pelicula_id) REFERENCES Pelicula(id)
);

```

Recordar que cuando tengo una relacion que tiene un 1, puedo meterla del otro lado y sino hay que crear una tabla nueva para la relacion

## 1.2 verdadero o falso

### Una misma película no puede haberse vendido a dos precios diferentes.

Falso

### No puede aparecer en una factura el registro de dos clientes distintos.

Verdadero

### Si  un  cliente  cambia  de  dirección  las  facturas  pasadas  quedan  automáticamente  con  la  nueva  dirección

Verdadero (lo referencia por nombre)

### Los números de líneas no pueden repetirse para facturas distintas.

Falso

### En la misma factura no puede haber dos líneas con la misma película.

Verdadero

### Si se borra una línea de detalle factura, automáticamente se borra la factura correspondiente. 
 
Falso

