-- PARA LIMPIAR LA DB ENTERA
DROP SCHEMA public CASCADE;

CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO public;

-- LIMPIAR SOLO LAS TABLAS

BEGIN;

TRUNCATE TABLE suscripcion
    RESTART IDENTITY   -- vuelve a poner el SERIAL de id en 1
    CASCADE;           -- borra también todas las filas de pago

COMMIT;


-- PRIMEROS INSETRS PARA VER QUE ANDEN BIEN LOS TRIGGERS
insert into pago (fecha, medio_pago, id_transaccion, cliente_email, modalidad, monto) 
values ('2024-01-01','tarjeta_credito', 'UUID-001','valentina.sosa@mail.com','mensual',3000); 

insert into pago (fecha, medio_pago, id_transaccion,cliente_email, modalidad, monto) 
values ('2024-01-28','tarjeta_debito', 'UUID-002','valentina.sosa@mail.com','mensual',3000);

insert into pago (fecha, medio_pago, id_transaccion,cliente_email, modalidad, monto) 
values ('2023-03-10', 'mercadopago', 'UUID-003','julian.moreno@mail.com', 'anual', 30000);

insert into pago (fecha, medio_pago, id_transaccion,cliente_email, modalidad, monto) 
values ('2024-03-01', 'tarjeta_credito', 'UUID-004', 'julian.moreno@mail.com', 'anual', 30000);

insert into pago (fecha, medio_pago, id_transaccion,cliente_email, modalidad, monto) 
values ('2022-08-01', 'efectivo', 'UUID-005','carla.perez21@mail.com', 'mensual', 3000);

insert into pago (fecha, medio_pago,id_transaccion, cliente_email, modalidad, monto) 
values ('2022-10-10', 'transferencia', 'UUID-006', 'carla.perez21@mail.com', 'mensual', 3000);



-- LA SEGUNDA DEBERIA FALLAR POR SER MUY ANTICIPADA

insert into pago (fecha, medio_pago, id_transaccion,cliente_email, modalidad, monto) 
values ('2024-01-01', 'tarjeta_credito', 'E1-BASE-UUID-0001','agustin.ramos@mail.com', 'anual', 30000);

insert into pago (fecha, medio_pago, id_transaccion,cliente_email, modalidad, monto) 
values ('2024-09-01', 'tarjeta_debito', 'E1-ANTICIPADA-MAL','agustin.ramos@mail.com', 'anual', 30000);

-- LA SEGUNDA DEBERIA FALLAR POR QUEDAR SUPERPUESTA

insert into pago (fecha, medio_pago, id_transaccion,cliente_email, modalidad, monto) 
values ('2024-01-01', 'tarjeta_credito', 'E7-FUTURO-BASE', 'nicolas.castro@mail.com', 'anual', 30000);

insert into pago (fecha, medio_pago, id_transaccion, cliente_email, modalidad, monto) 
values ('2023-12-20', 'efectivo', 'E7-RETRO-SUPERP', 'nicolas.castro@mail.com', 'mensual', 3000);

-- PARA PROBAR LO DE CONSOLIDAR (NO LO PROBE)
INSERT INTO pago (fecha, medio_pago, id_transaccion, cliente_email, modalidad, monto)
VALUES
    ('2024-01-01', 'tarjeta_credito',  'UUID-001', 'valentina.sosa@mail.com',  'mensual',  3000.00),
    ('2024-01-28', 'tarjeta_debito',   'UUID-002', 'valentina.sosa@mail.com',  'mensual',  3000.00),
    ('2023-03-10', 'mercadopago',      'UUID-003', 'julian.moreno@mail.com',   'anual',   30000.00),
    ('2024-03-01', 'tarjeta_credito',  'UUID-004', 'julian.moreno@mail.com',   'anual',   30000.00),
    ('2022-08-01', 'efectivo',         'UUID-005', 'carla.perez21@mail.com',   'mensual',  3000.00),
    ('2022-10-10', 'transferencia',    'UUID-006', 'carla.perez21@mail.com',   'mensual',  3000.00);

select consolidar_cliente('valentina.sosa@mail.com');

select consolidar_cliente('julian.moreno@mail.com');

select consolidar_cliente('carla.perez21@mail.com');

select consolidar_cliente('julian.romero@mail.com'); -- debe dar mensaje de que no tiene suscripciones

