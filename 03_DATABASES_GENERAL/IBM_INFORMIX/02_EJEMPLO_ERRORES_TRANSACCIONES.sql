-- ERRORES EN TRANSACCIONES CON UNA OLTP INFORMIX:
--
-- (-535) --> Already in Transaction
-- (-255) --> Not in Transaction
-- (-107) --> Record is Locked
-- (-143) --> Deadlock
---------------------------------------------------------------------------------------------------
-- En Informix, cada sesión (conexión) puede estar en uno de dos estados:
-- 1] Fuera de transacción (libre o autocommit)
-- 2] Dentro de una transacción activa (iniciada y esperando confirmación o cancelación)
-- Informix no soporta transacciones anidadas:

BEGIN WORK; -- OK
-- ... (sin commit ni rollback) ...
BEGIN WORK; -- ERROR = -535
---------------------------------------------------------------------------------------------------
-- Por otro lado, cuando se trata de hacer un:
COMMIT;
-- ó
ROLLBACK;
-- sin haber comenzado una transacción (BEGIN WORK), entonces generamos un error -255:
-- (-255): Not in Transaction.
---------------------------------------------------------------------------------------------------
-- Ahora, cuando decimos que una app en C++ (o Java) abre una transacción en esa misma conexión, ocurre por una de dos vías:
-- 1] El código en C++ (vía ESQL/C, dbx, ODBC o C SDK) ejecuta la instrucción de forma directa:
EXEC SQL BEGIN WORK;

-- 2] Desactivación del autocommit o modo libre en el driver/API:
-- Si la app en C++ se conecta mediante ODBC, OTL o JDBC y configura la sesión con:
AutoCommit = FALSE || SQL_AUTOCOMMIT_OFF
-- Informix asume que cualquier sentencia SQL previa (o la propia configuración) ya colocó a la CONEXIÓN en ESTADO TRANSACCIONAL.
---------------------------------------------------------------------------------------------------
-- PROBLEMAS TRANSACCIONALES
-- 
-- El problema ocurre cuando la aplicación en C++ y el SP comparten la misma conexión a la BD y se coordinan mal en tiempos:
-- 
-- 1. C++: EXEC SQL BEGIN WORK;
-- 2. C++ ---> SP
-- 3. SP: BEGIN WORK; (Rechazado ERROR -535: Already in Transaction)
-- 4. SP: COMMIT WORK; Pero cierra la transacción que comenzó C++.
-- ESTADO = MODO LIBRE (FUERA DE TRANSACCIÓN)
-- 5. El SP finaliza y devuelve datos.
-- 6. C++: COMMIT; (ERROR -255: Not in Transaction, porque el SP se la robó y la cerró!
---------------------------------------------------------------------------------------------------
-- Al implementar una solución con una variable de tipo bandera: "v_tx_propia", en el paso 3, cuando el SP ejecuta:
BEGIN WORK;
-- el SP DETECTA el error -535 (Already in Transaction), apaga su bandera (la settea a FALSE = 0), y en el paso 4 se SALTA el
-- COMMIT WORK; -- No lo hace porque "v_tx_propia" == 0.
-- El resultado es que el STORED PROCEDURE NO SECUESTRA LA TRANSACCIÓN que inició la app cliente (C++).
-- De esta forma, la transacción del paso 1 se mantiene abierta hasta que C++ decide terminarla (COMMIT o ROLLBACK).
---------------------------------------------------------------------------------------------------
-- Solución:
CREATE PROCEDURE "owner".sp_name (
    pNumero    CHAR(9)
    ,pFecha    DATE
)
RETURNING
    CHAR(10) AS numeroSalida
    ,CHAR(1) AS banderaSalida
;
-- VARIABLE DEFINITION SECTION
DEFINE cCodErr CHAR(5);
DEFINE cTipo   CHAR(1);
-- TRANSACTION CONTROL
DEFINE v_tx_propia SMALLINT; -- Validar si este mismo SP inicia la transaccion

-- VARIABLE INITIALIZATION SECTION
LET cCodErr = '00000';
LET cTipo = '';
LET v_tx_propia = 1; -- Al ejecutarse este SP, se inicializa en TRUE (1) esta bandera.

SET ISOLATION TO DIRTY READ;
SET LOCK MODE TO WAIT 3;

BEGIN
    ON EXCEPTION
        SET iSqlErr
    IF iSqlErr <> 0 THEN
        LET cCodErr = iSqlError;
    END IF;
    END EXCEPTION;

    -- Nucleo de la solución:
    BEGIN
        ON EXCEPTION IN (-535)
            LET v_tx_propia = 0; -- Significa que otro proceso/app tiene una transacción abierta
        END EXCEPTION WITH RESUME; -- Continúa la ejecución del SP, pero lanza la excepción.
        BEGIN WORK; -- Inicia la transacción del SP:
    END;

    -- ... Lógica

    IF v_tx_propia = 1 THEN
        COMMIT WORK; -- Cierra la transaccion únicamente si el SP la comenzó.
    END IF;

END;

END PROCEDURE
DOCUMENT
'RRHG',
'20261030';
---------------------------------------------------------------------------------------------------
-- PENDIENTE:
SET ISOLATION TO DIRTY READ;
SET LOCK MODE TO WAIT 3;
---------------------------------------------------------------------------------------------------