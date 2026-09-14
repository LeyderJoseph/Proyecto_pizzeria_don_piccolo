USE  PIZZERIA_DON_PICCOLO;

/*Triggers*/
/* 1 - Trigger de actualización automática de stock de ingredientes cuando se realiza un pedido.*/

DELIMITER //
CREATE TRIGGER actualizar_stock_ingredientes
AFTER INSERT ON detalle_pedidos
FOR EACH ROW
BEGIN
    UPDATE ingredientes i
    INNER JOIN pizza_ingredientes pi
        ON i.id_ingrediente = pi.id_ingrediente
    SET i.stock_actual = i.stock_actual -
        (pi.cantidad_requerida * NEW.cantidad)
    WHERE pi.id_pizza = NEW.id_pizza;
END //
DELIMITER ;

SELECT id_ingrediente, nombre, stock_actual
FROM ingredientes
WHERE id_ingrediente IN (1, 2, 3, 4, 5, 18);

INSERT INTO pedidos
(id_cliente, fecha_hora, tipo_entrega, metodo_pago, estado,
 subtotal, iva, costo_envio, total)
VALUES
(3, '2026-09-14 19:00:00', 'recoger_en_local', 'tarjeta',
 'pendiente', 76000, 14440, 0, 90440);
 
 INSERT INTO detalle_pedidos
(id_pedido, id_pizza, cantidad, precio_unitario, subtotal)
VALUES
(17, 7, 2, 38000, 76000);

SELECT id_ingrediente, nombre, stock_actual
FROM ingredientes
WHERE id_ingrediente IN (1, 2, 3, 4, 5, 18);


/* 2 - Trigger de auditoría que registre en una tabla historial_precios cada vez que se modifique el precio de una pizza.*/
DELIMITER //
CREATE TRIGGER registrar_historial_precio
AFTER UPDATE ON pizzas
FOR EACH ROW
BEGIN
    IF OLD.precio_base <> NEW.precio_base THEN
        INSERT INTO historial_precios
        (id_pizza, precio_anterior, precio_nuevo)
        VALUES
        (OLD.id_pizza, OLD.precio_base, NEW.precio_base);
    END IF;
END //
DELIMITER ;

UPDATE pizzas
SET precio_base = 19000
WHERE id_pizza = 1;

SELECT h.id_historial,
       p.nombre,
       p.tamano,
       h.precio_anterior,
       h.precio_nuevo,
       h.fecha_cambio
FROM historial_precios h
INNER JOIN pizzas p ON h.id_pizza = p.id_pizza;

/* 3 - Trigger para marcar repartidor como “disponible” nuevamente cuando termina un domicilio.*/

DELIMITER //
CREATE TRIGGER liberar_repartidor
AFTER UPDATE ON domicilios
FOR EACH ROW
BEGIN
    IF OLD.hora_entrega IS NULL
       AND NEW.hora_entrega IS NOT NULL THEN

        UPDATE repartidores
        SET estado = 'disponible'
        WHERE id_repartidor = NEW.id_repartidor;

    END IF;
END //
DELIMITER ;

UPDATE domicilios
SET hora_entrega = NULL
WHERE id_domicilio = 11;

UPDATE repartidores
SET estado = 'no disponible'
WHERE id_repartidor = 3;

CALL registrar_entrega(11, '2026-09-12 20:35:00');

SELECT r.id_repartidor,
       r.nombre,
       r.estado,
       d.id_domicilio,
       d.hora_entrega,
       p.id_pedido,
       p.estado AS estado_pedido
FROM repartidores r
INNER JOIN domicilios d ON r.id_repartidor = d.id_repartidor
INNER JOIN pedidos p ON d.id_pedido = p.id_pedido
WHERE d.id_domicilio = 11;

