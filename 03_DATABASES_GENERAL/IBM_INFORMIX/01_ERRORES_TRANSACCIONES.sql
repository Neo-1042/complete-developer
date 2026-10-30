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
