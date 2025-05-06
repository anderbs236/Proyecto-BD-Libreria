-- Crear tabla temporal de cantidades (1 y 2)
DROP TEMPORARY TABLE IF EXISTS TEMP_CANTIDADES;
CREATE TEMPORARY TABLE TEMP_CANTIDADES (cantidad INT);
INSERT INTO TEMP_CANTIDADES VALUES (1), (2);

-- Crear tabla temporal con las 500 primeras ventas
DROP TEMPORARY TABLE IF EXISTS TEMP_ID_VENTA;
CREATE TEMPORARY TABLE TEMP_ID_VENTA AS
SELECT id_venta, precio_total
FROM VENTA
ORDER BY id_venta
LIMIT 500;

--  Crear tabla temporal TEMP_DETALLE_VENTA
-- Se selecciona SOLO UNA combinación válida por venta
-- para que no se repita ningún id_venta y el subtotal coincida
DROP TEMPORARY TABLE IF EXISTS TEMP_DETALLE_VENTA;

CREATE TEMPORARY TABLE TEMP_DETALLE_VENTA AS
SELECT
  id_venta,
  isbn,
  cantidad,
  precio_unitario,
  subtotal
FROM (
  SELECT
    v.id_venta,
    l.isbn,
    c.cantidad,
    l.precio_recomendado AS precio_unitario,
    ROUND(c.cantidad * l.precio_recomendado, 2) AS subtotal,
    ROW_NUMBER() OVER (PARTITION BY v.id_venta ORDER BY RAND()) AS fila
  FROM TEMP_ID_VENTA v
  JOIN TEMP_CANTIDADES c ON TRUE
  JOIN LIBRO_EN_VENTA l ON ROUND(c.cantidad * l.precio_recomendado, 2) = v.precio_total
) AS combinaciones_validas
WHERE fila = 1;

-- Limpiar e insertar en la tabla real DETALLE_VENTA
DELETE FROM DETALLE_VENTA;

INSERT INTO DETALLE_VENTA (id_venta, isbn, cantidad, precio_unitario, subtotal)
SELECT id_venta, isbn, cantidad, precio_unitario, subtotal
FROM TEMP_DETALLE_VENTA;

-- Verificar que se insertaron correctamente
-- Debe devolver 500 filas, todas con id_venta diferente
SELECT COUNT(*) AS total_filas,
       COUNT(DISTINCT id_venta) AS ventas_distintas,
       MIN(id_venta), MAX(id_venta)
FROM DETALLE_VENTA;
