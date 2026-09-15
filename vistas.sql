USE  PIZZERIA_DON_PICCOLO;
/*VISTAS*/
 /* 1 - Vista de resumen de pedidos por cliente (nombre del cliente, cantidad de pedidos, total gastado).*/
 
CREATE OR REPLACE VIEW vista_resumen_pedidos_cliente AS
SELECT c.id_cliente,
       c.nombre AS cliente,
       COUNT(p.id_pedido) AS cantidad_pedidos,
       SUM(p.total) AS total_gastado
FROM clientes c
LEFT JOIN pedidos p
    ON c.id_cliente = p.id_cliente
   AND p.estado = 'entregado'
GROUP BY c.id_cliente, c.nombre;

SELECT * FROM vista_resumen_pedidos_cliente;


/* 2 - Vista de desempeño de repartidores (número de entregas, tiempo promedio, zona). */

CREATE VIEW vista_desempeno_repartidores AS
SELECT r.id_repartidor,
       r.nombre AS repartidor,
       r.zona_asignada AS zona,
       COUNT(d.id_domicilio) AS numero_entregas,
       AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega))
       AS promedio_minutos_entrega
FROM repartidores r
LEFT JOIN domicilios d
    ON r.id_repartidor = d.id_repartidor
   AND d.hora_salida IS NOT NULL
   AND d.hora_entrega IS NOT NULL
GROUP BY r.id_repartidor, r.nombre, r.zona_asignada;

SELECT * FROM vista_desempeno_repartidores;

/* 3 - Vista de stock de ingredientes por debajo del mínimo permitido. */

CREATE VIEW vista_stock_bajo_minimo AS
SELECT id_ingrediente,
       nombre,
       unidad_medida,
       stock_actual,
       stock_minimo,
       disponible
FROM ingredientes
WHERE stock_actual < stock_minimo;

SELECT * FROM vista_stock_bajo_minimo;

UPDATE ingredientes
SET stock_actual = 1500,
    disponible = FALSE
WHERE id_ingrediente = 6;


