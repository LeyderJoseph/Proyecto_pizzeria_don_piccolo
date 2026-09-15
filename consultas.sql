USE  PIZZERIA_DON_PICCOLO;

/* Clientes con pedidos entre dos fechas (BETWEEN) */
SELECT c.id_cliente,
       c.nombre,
       c.telefono,
       p.id_pedido,
       p.fecha_hora,
       p.estado,
       p.total
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.fecha_hora BETWEEN '2026-09-01 00:00:00' AND '2026-09-12 23:59:59'
ORDER BY p.fecha_hora;

/* Pizzas más vendidas (GROUP BY y COUNT). */
SELECT p.id_pizza,
       p.nombre,
       p.tamano,
       COUNT(dp.id_detalle) AS veces_pedida,
       SUM(dp.cantidad) AS cantidad_total_vendida
FROM pizzas p
JOIN detalle_pedidos dp ON p.id_pizza = dp.id_pizza
JOIN pedidos pe ON dp.id_pedido = pe.id_pedido
WHERE pe.estado = 'entregado'
GROUP BY p.id_pizza, p.nombre, p.tamano
ORDER BY cantidad_total_vendida DESC;

/* Pedidos por repartidor (JOIN) */
SELECT r.id_repartidor,
       r.nombre AS repartidor,
       r.zona_asignada,
       p.id_pedido,
       p.fecha_hora AS fecha_pedido,
       p.estado AS estado_pedido,
       d.hora_salida,
       d.hora_entrega
FROM repartidores r
JOIN domicilios d ON r.id_repartidor = d.id_repartidor
JOIN pedidos p ON d.id_pedido = p.id_pedido
ORDER BY r.nombre, p.fecha_hora;

/*Promedio de entrega por zona (AVG y JOIN).*/
SELECT d.zona,
       AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega))
       AS promedio_minutos_entrega,
       COUNT(d.id_domicilio) AS cantidad_entregas
FROM domicilios d
JOIN pedidos p ON d.id_pedido = p.id_pedido
WHERE p.estado = 'entregado'
  AND d.hora_salida IS NOT NULL
  AND d.hora_entrega IS NOT NULL
GROUP BY d.zona
ORDER BY promedio_minutos_entrega;

/*Clientes que gastaron más de un monto (HAVING).*/
SELECT c.id_cliente,
       c.nombre,
       COUNT(p.id_pedido) AS cantidad_pedidos,
       SUM(p.total) AS total_gastado
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.estado = 'entregado'
GROUP BY c.id_cliente, c.nombre
HAVING SUM(p.total) > 100000
ORDER BY total_gastado DESC;

/*Búsqueda por coincidencia parcial de nombre de pizza (LIKE).*/
SELECT id_pizza,
       nombre,
       tamano,
       precio_base,
       tipo,
       disponible
FROM pizzas
WHERE nombre LIKE '%champinones%';

/*Subconsulta para obtener los clientes frecuentes (más de 5 pedidos mensuales).*/
SELECT id_cliente,
       nombre,
       telefono,
       correo
FROM clientes
WHERE id_cliente IN (
    SELECT p.id_cliente
    FROM pedidos p
    WHERE p.estado <> 'cancelado'
      AND YEAR(p.fecha_hora) = 2026
      AND MONTH(p.fecha_hora) = 9
    GROUP BY p.id_cliente
    HAVING COUNT(p.id_pedido) > 5
);

