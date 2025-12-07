-- TABLAS

CREATE TABLE suscripcion (
    id              SERIAL PRIMARY KEY,
    cliente_email   VARCHAR(255) NOT NULL,
    tipo            VARCHAR(20)  NOT NULL
        CHECK (tipo IN ('nueva', 'renovacion')),
    modalidad       VARCHAR(20)  NOT NULL
        CHECK (modalidad IN ('mensual', 'anual')),
    fecha_inicio    DATE        NOT NULL,
    fecha_fin       DATE        NOT NULL,
    CHECK (fecha_fin >= fecha_inicio)
);

CREATE TABLE pago (
    fecha           DATE        NOT NULL,
    medio_pago      VARCHAR(30) NOT NULL
        CHECK (medio_pago IN (
            'tarjeta_credito',
            'tarjeta_debito',
            'transferencia',
            'efectivo',
            'mercadopago'
        )),
    id_transaccion  VARCHAR(100) PRIMARY KEY,
    cliente_email   VARCHAR(255) NOT NULL,
    modalidad       VARCHAR(20)  NOT NULL
        CHECK (modalidad IN ('mensual', 'anual')),
    monto           NUMERIC(10,2) NOT NULL
        CHECK (monto > 0),
    suscripcion_id  INTEGER,
    CONSTRAINT fk_pago_suscripcion
        FOREIGN KEY (suscripcion_id)
        REFERENCES suscripcion(id)
);

-- FUNCIONES AUXILIARES

CREATE OR REPLACE FUNCTION obtener_suscripcion_en_fecha(
    p_email TEXT,
    p_fecha DATE
) RETURNS suscripcion AS $$
DECLARE
    r suscripcion%ROWTYPE;
BEGIN
    SELECT *
    INTO r
    FROM suscripcion
    WHERE cliente_email = p_email
      AND p_fecha BETWEEN fecha_inicio AND fecha_fin
    ORDER BY fecha_fin DESC
    LIMIT 1;

    RETURN r;  -- si no hay filas, id queda NULL
END;
$$ LANGUAGE plpgsql;

-- Calcular rango (inicio/fin) según modalidad, a partir de una fecha base
CREATE OR REPLACE FUNCTION calcular_rango(
    p_fecha_base DATE,
    p_modalidad  TEXT
) RETURNS TABLE(fecha_inicio DATE, fecha_fin DATE) AS $$
BEGIN
    fecha_inicio := p_fecha_base;

    IF p_modalidad = 'mensual' THEN
        fecha_fin := (p_fecha_base + INTERVAL '1 month' - INTERVAL '1 day')::DATE;
    ELSIF p_modalidad = 'anual' THEN
        fecha_fin := (p_fecha_base + INTERVAL '1 year' - INTERVAL '1 day')::DATE;
    ELSE
        RAISE EXCEPTION 'Modalidad desconocida: %', p_modalidad;
    END IF;

    RETURN NEXT;
END;
$$ LANGUAGE plpgsql;

-- Chequear solapamiento de suscripciones para un cliente
CREATE OR REPLACE FUNCTION hay_solapamiento(
    p_email      TEXT,
    p_inicio_nvo DATE,
    p_fin_nvo    DATE
) RETURNS BOOLEAN AS $$
DECLARE
    existe BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM suscripcion s
        WHERE s.cliente_email = p_email
          AND NOT (
                p_fin_nvo   < s.fecha_inicio
            OR  p_inicio_nvo > s.fecha_fin
          )
    )
    INTO existe;

    RETURN existe;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER

CREATE OR REPLACE FUNCTION trg_pagos_suscripcion()
RETURNS trigger AS $$
DECLARE
    actual   suscripcion%ROWTYPE;  -- período vigente en la fecha del pago (si existe)
    v_inicio DATE;
    v_fin    DATE;
BEGIN
    -- buscar suscripcion vigente en la fecha del pago
    actual := obtener_suscripcion_en_fecha(NEW.cliente_email, NEW.fecha);

    -- es nueva
    IF actual.id IS NULL THEN
        SELECT fecha_inicio, fecha_fin
        INTO v_inicio, v_fin
        FROM calcular_rango(NEW.fecha, NEW.modalidad);

        IF hay_solapamiento(NEW.cliente_email, v_inicio, v_fin) THEN
            RAISE EXCEPTION
                'Nueva suscripción de % se superpone con otra existente (% - %)',
                NEW.cliente_email, v_inicio, v_fin;
        END IF;

        INSERT INTO suscripcion (cliente_email, tipo, modalidad, fecha_inicio, fecha_fin)
        VALUES (NEW.cliente_email, 'nueva', NEW.modalidad, v_inicio, v_fin)
        RETURNING id INTO NEW.suscripcion_id;

        RETURN NEW;
    END IF;

    -- es renovacion -> me fijo que sea dentro de los 30 dias
    IF NEW.fecha < (actual.fecha_fin - INTERVAL '30 days') THEN
        RAISE EXCEPTION
            'Pago demasiado anticipado para el período [% - %] del cliente %: '
            'fecha pago %, solo se permite desde %',
            actual.fecha_inicio,
            actual.fecha_fin,
            NEW.cliente_email,
            NEW.fecha,
            (actual.fecha_fin - INTERVAL '30 days')::date;
    END IF;

    -- arranca al dia siguiente del periodo actual
    SELECT fecha_inicio, fecha_fin
    INTO v_inicio, v_fin
    FROM calcular_rango((actual.fecha_fin + INTERVAL '1 day')::date, NEW.modalidad);

    IF hay_solapamiento(NEW.cliente_email, v_inicio, v_fin) THEN
        RAISE EXCEPTION
            'Renovación de % sobre período [% - %] se superpone con otra suscripción existente (% - %)',
            NEW.cliente_email,
            actual.fecha_inicio,
            actual.fecha_fin,
            v_inicio,
            v_fin;
    END IF;

    INSERT INTO suscripcion (cliente_email, tipo, modalidad, fecha_inicio, fecha_fin)
    VALUES (NEW.cliente_email, 'renovacion', NEW.modalidad, v_inicio, v_fin)
    RETURNING id INTO NEW.suscripcion_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER pagos_before_insert
BEFORE INSERT ON pago
FOR EACH ROW
EXECUTE FUNCTION trg_pagos_suscripcion();



-- FUNCION DE ANALISIS

CREATE OR REPLACE FUNCTION consolidar_cliente(p_email TEXT)
RETURNS void AS $$
DECLARE
    reg RECORD;
    periodo_inicio DATE;
    periodo_fin DATE;
    periodo_num INTEGER := 0;
    total_meses INTEGER := 0;
    meses_periodo INTEGER;
    primera BOOLEAN := TRUE;
    gap_inicio DATE;
    gap_fin DATE;

    pago RECORD;       
    etiqueta_tipo TEXT; 
    duracion_mes INTEGER;
BEGIN
    RAISE NOTICE '== Cliente: % ==', p_email;

    FOR reg IN
        SELECT *
        FROM suscripcion
        WHERE cliente_email = p_email
        ORDER BY fecha_inicio
    LOOP
        -- Buscar datos del pago asociado
        SELECT fecha AS fecha_pago, medio_pago
        INTO pago
        FROM pago
        WHERE suscripcion_id = reg.id;

        
        duracion_mes := CASE reg.modalidad WHEN 'mensual' THEN 1 ELSE 12 END;

        etiqueta_tipo :=
            UPPER(reg.tipo) || ' ' ||
            UPPER(reg.modalidad);

        IF primera THEN
            primera := FALSE;
            periodo_num := 1;
            periodo_inicio := reg.fecha_inicio;
            periodo_fin := reg.fecha_fin;

            RAISE NOTICE 'Periodo #%: %', periodo_num, '';
            RAISE NOTICE '   % (% %) | pago=% medio=% | cobertura=% a %',
                etiqueta_tipo,
                duracion_mes,
                CASE WHEN duracion_mes = 1 THEN 'mes' ELSE 'meses' END,
                pago.fecha_pago,
                pago.medio_pago,
                reg.fecha_inicio,
                reg.fecha_fin;

        ELSE
            -- mismo periodo
            IF reg.fecha_inicio = periodo_fin + INTERVAL '1 day' THEN
                periodo_fin := reg.fecha_fin;

                RAISE NOTICE '   % (% %) | pago=% medio=% | cobertura=% a %',
                    etiqueta_tipo,
                    duracion_mes,
                    CASE WHEN duracion_mes = 1 THEN 'mes' ELSE 'meses' END,
                    pago.fecha_pago,
                    pago.medio_pago,
                    reg.fecha_inicio,
                    reg.fecha_fin;

            ELSE
                -- terminar periodo anterior
                SELECT
                    (EXTRACT(YEAR FROM age(periodo_fin + 1, periodo_inicio))::INT * 12)
                    + EXTRACT(MONTH FROM age(periodo_fin + 1, periodo_inicio))::INT
                INTO meses_periodo;

                total_meses := total_meses + meses_periodo;

                RAISE NOTICE '(Fin del período #%: % a %) | Total período: % %',
                    periodo_num,
                    periodo_inicio,
                    periodo_fin,
                    meses_periodo,
                    CASE WHEN meses_periodo = 1 THEN 'mes' ELSE 'meses' END;

                gap_inicio := periodo_fin + 1;
                gap_fin := reg.fecha_inicio - 1;

                IF gap_inicio <= gap_fin THEN
                    RAISE NOTICE '--- PERIODO DE BAJA --- (% a %)',
                        gap_inicio, gap_fin;
                END IF;

                periodo_num := periodo_num + 1;
                periodo_inicio := reg.fecha_inicio;
                periodo_fin := reg.fecha_fin;

                RAISE NOTICE 'Periodo #%: %', periodo_num, '';
                RAISE NOTICE '   % (% %) | pago=% medio=% | cobertura=% a %',
                    etiqueta_tipo,
                    duracion_mes,
                    CASE WHEN duracion_mes = 1 THEN 'mes' ELSE 'meses' END,
                    pago.fecha_pago,
                    pago.medio_pago,
                    reg.fecha_inicio,
                    reg.fecha_fin;
            END IF;

        END IF;
    END LOOP;


    IF primera THEN
        RAISE NOTICE 'Cliente % no tiene suscripciones registradas', p_email;
        RETURN;
    END IF;

    SELECT
        (EXTRACT(YEAR FROM age(periodo_fin + 1, periodo_inicio))::INT * 12)
        + EXTRACT(MONTH FROM age(periodo_fin + 1, periodo_inicio))::INT
    INTO meses_periodo;

    total_meses := total_meses + meses_periodo;

    RAISE NOTICE '(Fin del período #%: % a %) | Total período: % %',
        periodo_num,
        periodo_inicio,
        periodo_fin,
        meses_periodo,
        CASE WHEN meses_periodo = 1 THEN 'mes' ELSE 'meses' END;

    RAISE NOTICE '== Total acumulado: % % ==',
        total_meses,
        CASE WHEN total_meses = 1 THEN 'mes' ELSE 'meses' END;

END;
$$ LANGUAGE plpgsql;