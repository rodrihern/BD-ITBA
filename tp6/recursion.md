## ¿Por qué necesitamos recursión en SQL?

Versiones anteriores como SQL2 no podían resolver ciertos problemas que implican relaciones jerárquicas o transitivas. Por ejemplo, no se podía responder fácilmente a preguntas como:
- ¿Quiénes son **todos** los subordinados (directos e indirectos) de un gerente?
- ¿Qué ciudades se pueden alcanzar desde un origen, considerando todas las posibles escalas de vuelos?
Estos problemas requieren calcular la**clausura transitiva** de una relación. SQL3 introdujo la capacidad de realizar estas consultas recursivas.

---

## La Cláusula `WITH`: Tablas Temporales

Antes de ver la recursión, es clave entender la cláusula `WITH`. Permite crear tablas temporales (también conocidas como _Common Table Expressions_ o CTEs) que existen solo durante la ejecución de una consulta. Son útiles para simplificar consultas complejas.

### Sintaxis Básica

``` sql
WITH nombre_tabla_temporal AS (
    -- Una consulta SELECT que define la tabla
    SELECT columna1, columna2 FROM tabla_existente
)
-- La consulta principal que usa la tabla temporal
SELECT * FROM nombre_tabla_temporal;
```

### Ejemplo Práctico
Dada una tabla `ALUMNO`, podemos crear una tabla temporal `creacion` con los nombres en mayúsculas y luego consultarla:

``` sql
WITH creacion AS (
    SELECT legajo, UPPER(nombre) AS N FROM ALUMNO
)
SELECT * FROM creacion WHERE legajo > 100;
```

**Resultado:** Se obtiene una lista de alumnos con legajo mayor a 100, con sus nombres en mayúsculas.

--- 
## Recursión con `WITH RECURSIVE`
Para las consultas recursivas, se utiliza `WITH RECURSIVE`. La estructura es fundamental y siempre sigue el mismo patrón.
### Estructura de una Consulta Recursiva

Una consulta recursiva se compone de dos partes unidas por un
`UNION`:
1. **Caso Base**: Es la primera consulta `SELECT` (antes del `UNION`). **No es recursiva**. Define el conjunto de datos inicial, el punto de partida (equivalente R0​ en la teoría).
2. **Paso Recursivo**: Es la segunda consulta `SELECT` (después del `UNION`). Se llama a sí misma (hace referencia a la tabla temporal que se está creando) para procesar los resultados de la iteración anterior y encontrar nuevos resultados.
La consulta se detiene cuando el paso recursivo ya no genera nuevas filas, alcanzando un "punto fijo".
**Importante**: SQL3 solo soporta **recursión lineal**, lo que significa que la tabla temporal que se está definiendo solo puede aparecer una vez en la parte recursiva de la consulta.

### Ejemplo 1: Jerarquía de Empleados
**Problema**: Tenemos una tabla `JefeDe(P1, P2)` que indica que P1 es jefe directo de P2. Queremos encontrar todas las relaciones de superioridad, directas e indirectas (quién es "SuperiorDe" quién).

``` sql
WITH RECURSIVE SuperiorDe (X, Y) AS (
    -- Caso Base: Todos los jefes directos son superiores.
    SELECT P1, P2 FROM JefeDe

    UNION

    -- Paso Recursivo: Si A es superior de B, y B es jefe directo de C,
    -- entonces A también es superior de C.
    SELECT SuperiorDe.X, JefeDe.P2
    FROM SuperiorDe, JefeDe
    WHERE SuperiorDe.Y = JefeDe.P1
)
SELECT X, Y FROM SuperiorDe;
```

- **Primera iteración**: El `Caso Base` carga la tabla `JefeDe` en `SuperiorDe`.
- **Iteraciones siguientes**: El `Paso Recursivo` combina los resultados existentes en `SuperiorDe` con la tabla `JefeDe` para encontrar nuevas relaciones jerárquicas (ej. los jefes de los jefes).
- **Finalización**: El proceso se repite hasta que no se encuentran nuevas relaciones de superioridad.

### Ejemplo 2: Itinerarios de Vuelos

**Problema**: Dada una tabla `vuelo(origen, destino, salida, arribo)`, encontrar todos los itinerarios posibles, incluyendo vuelos con escalas.

``` sql
WITH RECURSIVE combinacion(origen, destino, salida, arribo) AS (
    -- Caso Base: Todos los vuelos directos son itinerarios posibles.
    SELECT * FROM vuelo

    UNION

    -- Paso Recursivo: Si hay un vuelo de A a B y una combinación de B a C,
    -- y el vuelo de A a B llega antes de que salga la combinación de B a C,
    -- entonces existe un itinerario de A a C.
    SELECT vuelo.origen, combinacion.destino, vuelo.salida, combinacion.arribo
    FROM vuelo, combinacion
    WHERE vuelo.destino = combinacion.origen AND
          vuelo.arribo < combinacion.salida
)
SELECT * FROM combinacion;
```
Esta consulta construirá una tabla final (`VUELO+`) que contiene no solo los vuelos directos, sino también todas las conexiones posibles, como `BA -> Salta` o `BA -> San Luis`, que se logran a través de escalas.