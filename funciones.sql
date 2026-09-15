USE  PIZZERIA_DON_PICCOLO;
/*Funciones y Procedimientos*/
/* 1 - Función para calcular el total de un pedido (sumando precios de pizzas + costo de envío + IVA).*/
DELIMITER //
CREATE FUNCTION calcular_total_pedido(p_id_pedido INT)
RETURNS DOUBLE
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_subtotal DOUBLE;
    DECLARE v_costo_envio DOUBLE;
    DECLARE v_iva DOUBLE;
    SELECT SUM(subtotal) INTO v_subtotal FROM detalle_pedidos WHERE id_pedido = p_id_pedido;
    SELECT costo_envio INTO v_costo_envio FROM pedidos WHERE id_pedido = p_id_pedido;
    SET v_iva = v_subtotal * 0.19;
    RETURN v_subtotal + v_costo_envio + v_iva;
END //
DELIMITER ;
SELECT calcular_total_pedido(4) AS total_pedido_4;


/* 2 - Función para calcular la ganancia neta diaria (ventas - costos de ingredientes)..*/
DELIMITER //
CREATE FUNCTION calcular_ganancia_neta_diaria(p_fecha DATE)
RETURNS DOUBLE
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_ventas DOUBLE;
    DECLARE v_costos_ingredientes DOUBLE;
    SELECT SUM(total) INTO v_ventas FROM pedidos WHERE DATE(fecha_hora) = p_fecha AND estado = 'entregado';
    SELECT SUM(pi.cantidad_requerida * i.costo_unitario * dp.cantidad) INTO v_costos_ingredientes 
    FROM pedidos p JOIN detalle_pedidos dp ON p.id_pedido = dp.id_pedido
    JOIN pizza_ingredientes pi ON dp.id_pizza = pi.id_pizza
    JOIN ingredientes i ON pi.id_ingrediente = i.id_ingrediente
    WHERE DATE(p.fecha_hora) = p_fecha
      AND p.estado = 'entregado';
    RETURN v_ventas - v_costos_ingredientes;
END //
DELIMITER ;
SELECT calcular_ganancia_neta_diaria('2026-09-01') AS ganancia_neta;

/* 3 - Procedimiento para cambiar automáticamente el estado del pedido a “entregado” cuando se registre la hora de entrega..*/
DELIMITER //
CREATE PROCEDURE registrar_entrega(IN p_id_domicilio INT, IN p_hora_entrega DATETIME)
BEGIN
    UPDATE domicilios
    SET hora_entrega = p_hora_entrega
    WHERE id_domicilio = p_id_domicilio;

    UPDATE pedidos p JOIN domicilios d ON p.id_pedido = d.id_pedido
    SET p.estado = 'entregado'
    WHERE d.id_domicilio = p_id_domicilio;
END //
DELIMITER ;

UPDATE domicilios
SET hora_salida = '2026-09-11 20:30:00'
WHERE id_domicilio = 10;

CALL registrar_entrega(10, '2026-09-11 21:05:00');

SELECT d.id_domicilio, d.hora_salida, d.hora_entrega,
       p.id_pedido, p.estado
FROM domicilios d JOIN pedidos p ON d.id_pedido = p.id_pedido
WHERE d.id_domicilio = 10;
  
  