CREATE DATABASE PIZZERIA_DON_PICCOLO;
USE  PIZZERIA_DON_PICCOLO;

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre varchar(100) not null,
    telefono varchar(20) not null,
    direccion varchar(50) not null,
    correo varchar (100) not null,
    tipo_documento ENUM('C.C.', 'T.I', 'PASAPORTE', 'C.E', 'VISA'),
    documento varchar (20) not null
);


CREATE TABLE pizzas (
    id_pizza INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tamano ENUM('personal', 'mediana', 'familiar', 'gigante') NOT NULL,
    precio_base DOUBLE NOT NULL,
    tipo ENUM('vegetariana', 'especial', 'clasica') NOT NULL,
    disponible BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (nombre, tamano)
    );

CREATE TABLE ingredientes (
id_ingrediente int auto_increment primary key,
nombre varchar(100) not null unique,
unidad_medida ENUM('gramos', 'mililitros', 'unidad') NOT NULL,
stock_actual int NOT NULL DEFAULT 0,
stock_minimo int NOT NULL DEFAULT 0,
costo_unitario double NOT NULL,
disponible BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE pizza_ingredientes (
    id_pizza INT NOT NULL,
    id_ingrediente INT NOT NULL,
    cantidad_requerida DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pizza, id_ingrediente),
    CONSTRAINT fk_pi_pizza
        FOREIGN KEY (id_pizza) REFERENCES pizzas(id_pizza),
    CONSTRAINT fk_pi_ingrediente
        FOREIGN KEY (id_ingrediente) REFERENCES ingredientes(id_ingrediente)
);

CREATE TABLE repartidores (
    id_repartidor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    zona_asignada VARCHAR(100) NOT NULL,
    estado ENUM('disponible', 'no disponible') NOT NULL DEFAULT 'disponible'
    );
    
CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_entrega ENUM('domicilio', 'recoger_en_local') NOT NULL DEFAULT 'domicilio',
    metodo_pago ENUM('efectivo', 'tarjeta', 'app') NOT NULL,
    estado ENUM('pendiente', 'en preparacion', 'entregado', 'cancelado') NOT NULL DEFAULT 'pendiente',
    subtotal double NOT NULL DEFAULT 0,
    iva double NOT NULL DEFAULT 0,
    costo_envio double NOT NULL DEFAULT 0,
    total double NOT NULL DEFAULT 0,
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
        );
        
CREATE TABLE detalle_pedidos (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_pizza INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario double NOT NULL,
    subtotal double NOT NULL,
    CONSTRAINT fk_detalle_pedido
        FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    CONSTRAINT fk_detalle_pizza
        FOREIGN KEY (id_pizza) REFERENCES pizzas(id_pizza)
        );
        
	CREATE TABLE domicilios (
    id_domicilio INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL UNIQUE,
    id_repartidor INT NOT NULL,
    direccion_entrega VARCHAR(100) NOT NULL,
    zona VARCHAR(100) NOT NULL,
    hora_salida DATETIME NULL,
    hora_entrega DATETIME NULL,
    distancia_km DECIMAL(6,2) NOT NULL,
    costo_envio double NOT NULL,
    CONSTRAINT fk_domicilio_pedido
        FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    CONSTRAINT fk_domicilio_repartidor
        FOREIGN KEY (id_repartidor) REFERENCES repartidores(id_repartidor)
	);

CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL UNIQUE,
    fecha_pago DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metodo_pago ENUM('efectivo', 'tarjeta', 'app') NOT NULL,
    monto double NOT NULL,
    estado_pago ENUM('pendiente', 'pagado', 'rechazado') NOT NULL DEFAULT 'pendiente',
    CONSTRAINT fk_pago_pedido
        FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
);
 
CREATE TABLE historial_precios (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_pizza INT NOT NULL,
    precio_anterior double NOT NULL,
    precio_nuevo double NOT NULL,
    fecha_cambio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_historial_pizza
        FOREIGN KEY (id_pizza) REFERENCES pizzas(id_pizza)
	);


/* Inserción de  datos */


INSERT INTO clientes
(nombre, telefono, direccion, correo, tipo_documento, documento)
VALUES
('Ana Martinez', '3001234567', 'Carrera 10 # 25-30, Centro', 'ana.martinez@gmail.com', 'C.C.', '1012345678'),
('Carlos Ramirez', '3012345678', 'Calle 45 # 12-18, Norte', 'carlos.ramirez@gmail.com', 'C.C.', '1023456789'),
('Laura Gomez', '3023456789', 'Carrera 8 # 30-15, Sur', 'laura.gomez@gmail.com', 'C.C.', '1034567890'),
('Juan Perez', '3034567890', 'Calle 20 # 15-40, Occidente', 'juan.perez@gmail.com', 'C.C.', '1045678901'),
('Sofia Rodriguez', '3045678901', 'Carrera 15 # 60-22, Norte', 'sofia.rodriguez@gmail.com', 'T.I', '1056789012'),
('Andres Torres', '3056789012', 'Calle 10 # 8-25, Centro', 'andres.torres@gmail.com', 'C.C.', '1067890123'),
('Valentina Castro', '3067890123', 'Carrera 25 # 45-10, Oriente', 'valentina.castro@gmail.com', 'C.C.', '1078901234'),
('Mateo Herrera', '3078901234', 'Calle 65 # 20-35, Norte', 'mateo.herrera@gmail.com', 'PASAPORTE', 'PA1234567');



INSERT INTO ingredientes
(nombre, unidad_medida, stock_actual, stock_minimo, costo_unitario, disponible)
VALUES
('Masa para pizza', 'gramos', 30000, 6000, 10, TRUE),
('Salsa de tomate', 'gramos', 15000, 3000, 8, TRUE),
('Queso mozzarella', 'gramos', 20000, 5000, 25, TRUE),
('Jamon', 'gramos', 8000, 2000, 30, TRUE),
('Piña', 'gramos', 6000, 1500, 18, TRUE),
('Pepperoni', 'gramos', 7000, 2000, 35, TRUE),
('Pollo', 'gramos', 9000, 2500, 32, TRUE),
('Champinones', 'gramos', 5000, 1200, 28, TRUE),
('Pimenton', 'gramos', 4000, 1000, 15, TRUE),
('Cebolla', 'gramos', 5000, 1200, 10, TRUE),
('Tomate', 'gramos', 6000, 1500, 12, TRUE),
('Aceitunas negras', 'gramos', 2500, 700, 40, TRUE),
('Queso parmesano', 'gramos', 3500, 800, 45, TRUE),
('Queso azul', 'gramos', 2500, 600, 50, TRUE),
('Maiz dulce', 'gramos', 4000, 1000, 18, TRUE),
('Carne molida', 'gramos', 7000, 2000, 38, TRUE),
('Jalapenos', 'gramos', 2000, 500, 35, TRUE),
('Oregano', 'gramos', 1000, 200, 20, TRUE);



INSERT INTO pizza_ingredientes
(nombre, tamano, precio_base, tipo, disponible)
VALUES
-- Margarita
('Margarita', 'personal', 18000, 'clasica', TRUE),
('Margarita', 'mediana', 28000, 'clasica', TRUE),
('Margarita', 'familiar', 38000, 'clasica', TRUE),
('Margarita', 'gigante', 48000, 'clasica', TRUE),

-- Hawaiana
('Hawaiana', 'personal', 20000, 'clasica', TRUE),
('Hawaiana', 'mediana', 30000, 'clasica', TRUE),
('Hawaiana', 'familiar', 38000, 'clasica', TRUE),
('Hawaiana', 'gigante', 50000, 'clasica', TRUE),

-- Pepperoni
('Pepperoni', 'personal', 22000, 'especial', TRUE),
('Pepperoni', 'mediana', 32000, 'especial', TRUE),
('Pepperoni', 'familiar', 42000, 'especial', TRUE),
('Pepperoni', 'gigante', 55000, 'especial', TRUE),

-- Don Piccolo Especial
('Don Piccolo Especial', 'personal', 25000, 'especial', TRUE),
('Don Piccolo Especial', 'mediana', 35000, 'especial', TRUE),
('Don Piccolo Especial', 'familiar', 45000, 'especial', TRUE),
('Don Piccolo Especial', 'gigante', 60000, 'especial', TRUE),

-- Pollo con Champinones
('Pollo con Champinones', 'personal', 23000, 'especial', TRUE),
('Pollo con Champinones', 'mediana', 35000, 'especial', TRUE),
('Pollo con Champinones', 'familiar', 45000, 'especial', TRUE),
('Pollo con Champinones', 'gigante', 60000, 'especial', TRUE),

-- Vegetariana
('Vegetariana', 'personal', 19000, 'vegetariana', TRUE),
('Vegetariana', 'mediana', 28000, 'vegetariana', TRUE),
('Vegetariana', 'familiar', 36000, 'vegetariana', TRUE),
('Vegetariana', 'gigante', 50000, 'vegetariana', TRUE),

-- Cuatro Quesos
('Cuatro Quesos', 'personal', 22000, 'especial', TRUE),
('Cuatro Quesos', 'mediana', 34000, 'especial', TRUE),
('Cuatro Quesos', 'familiar', 44000, 'especial', TRUE),
('Cuatro Quesos', 'gigante', 58000, 'especial', TRUE),

-- Mexicana
('Mexicana', 'personal', 24000, 'especial', TRUE),
('Mexicana', 'mediana', 32000, 'especial', TRUE),
('Mexicana', 'familiar', 42000, 'especial', TRUE),
('Mexicana', 'gigante', 55000, 'especial', TRUE),

-- Napolitana
('Napolitana', 'personal', 18000, 'vegetariana', TRUE),
('Napolitana', 'mediana', 30000, 'vegetariana', TRUE),
('Napolitana', 'familiar', 40000, 'vegetariana', TRUE),
('Napolitana', 'gigante', 48000, 'vegetariana', FALSE);



INSERT INTO repartidores
(nombre, telefono, zona_asignada, estado)
VALUES
('Miguel Alvarez', '3101234567', 'Centro', 'disponible'),
('Daniel Rojas', '3112345678', 'Norte', 'disponible'),
('Camila Vargas', '3123456789', 'Sur', 'disponible'),
('Sebastian Mora', '3134567890', 'Occidente', 'disponible'),
('Natalia Ruiz', '3145678901', 'Oriente', 'disponible'),
('Felipe Castro', '3156789012', 'Centro', 'no disponible');


INSERT INTO pedidos
(id_cliente, fecha_hora, tipo_entrega, metodo_pago, estado,
 subtotal, iva, costo_envio, total)
VALUES
-- Pedidos de Ana Martínez: más de 5 pedidos en septiembre
(1, '2026-09-01 12:30:00', 'domicilio', 'efectivo', 'entregado', 18000, 3420, 5000, 26420),
(1, '2026-09-03 19:15:00', 'domicilio', 'tarjeta', 'entregado', 30000, 5700, 6000, 41700),
(1, '2026-09-05 13:10:00', 'domicilio', 'app', 'entregado', 22000, 4180, 5000, 31180),
(1, '2026-09-08 20:00:00', 'domicilio', 'tarjeta', 'entregado', 45000, 8550, 8000, 61550),
(1, '2026-09-10 18:30:00', 'recoger_en_local', 'efectivo', 'entregado', 28000, 5320, 0, 33320),
(1, '2026-09-12 21:00:00', 'domicilio', 'app', 'entregado', 55000, 10450, 10000, 75450),

-- Pedidos de otros clientes
(2, '2026-09-02 18:45:00', 'domicilio', 'tarjeta', 'entregado', 35000, 7790, 6000, 48790),
(2, '2026-09-06 20:30:00', 'domicilio', 'efectivo', 'entregado', 38000, 8170, 5000, 51170),
(3, '2026-09-07 19:00:00', 'domicilio', 'app', 'entregado', 44000, 9785, 7500, 61285),
(4, '2026-09-09 12:00:00', 'recoger_en_local', 'tarjeta', 'entregado', 30000, 5700, 0, 35700),
(5, '2026-09-11 20:15:00', 'domicilio', 'app', 'en preparacion', 50000, 11210, 9000, 70210),
(6, '2026-09-12 19:30:00', 'domicilio', 'efectivo', 'pendiente', 42000, 9310, 7000, 58310),

-- Pedidos de agosto para consultas por fechas
(7, '2026-08-25 18:00:00', 'domicilio', 'tarjeta', 'entregado', 32000, 7315, 6500, 45815),
(8, '2026-08-28 20:00:00', 'recoger_en_local', 'efectivo', 'entregado', 35000, 6650, 0, 41650),

-- Pedido cancelado
(2, '2026-09-13 14:00:00', 'domicilio', 'efectivo', 'cancelado', 18000, 3420, 0, 21420);


INSERT INTO detalle_pedidos
(id_pedido, id_pizza, cantidad, precio_unitario, subtotal)
VALUES
-- Pedido 1: Margarita personal
(1, 1, 1, 18000, 18000),

-- Pedido 2: Hawaiana mediana
(2, 6, 1, 30000, 30000),

-- Pedido 3: Pepperoni personal
(3, 9, 1, 22000, 22000),

-- Pedido 4: Don Piccolo Especial familiar
(4, 15, 1, 45000, 45000),

-- Pedido 5: Vegetariana mediana
(5, 22, 1, 28000, 28000),

-- Pedido 6: Mexicana gigante
(6, 32, 1, 55000, 55000),

-- Pedido 7: Pollo con Champinones mediana
(7, 18, 1, 35000, 35000),

-- Pedido 8: Margarita personal + Hawaiana personal
(8, 1, 1, 18000, 18000),
(8, 5, 1, 20000, 20000),

-- Pedido 9: Cuatro Quesos familiar
(9, 27, 1, 44000, 44000),

-- Pedido 10: Napolitana mediana
(10, 34, 1, 30000, 30000),

-- Pedido 11: Vegetariana gigante
(11, 24, 1, 50000, 50000),

-- Pedido 12: Pepperoni familiar
(12, 11, 1, 42000, 42000),

-- Pedido 13: Mexicana mediana
(13, 30, 1, 32000, 32000),

-- Pedido 14: Don Piccolo Especial mediana
(14, 14, 1, 35000, 35000),

-- Pedido 15 cancelado: Margarita personal
(15, 1, 1, 18000, 18000);


INSERT INTO domicilios
(id_pedido, id_repartidor, direccion_entrega, zona,
 hora_salida, hora_entrega, distancia_km, costo_envio)
VALUES
-- Pedidos entregados
(1, 1, 'Carrera 10 # 25-30, Centro', 'Centro',
 '2026-09-01 12:50:00', '2026-09-01 13:15:00', 3.20, 5000),

(2, 2, 'Calle 45 # 12-18, Norte', 'Norte',
 '2026-09-03 19:40:00', '2026-09-03 20:10:00', 4.50, 6000),

(3, 1, 'Carrera 10 # 25-30, Centro', 'Centro',
 '2026-09-05 13:30:00', '2026-09-05 13:55:00', 3.00, 5000),

(4, 3, 'Carrera 10 # 25-30, Centro', 'Sur',
 '2026-09-08 20:25:00', '2026-09-08 21:05:00', 6.80, 8000),

(6, 5, 'Carrera 10 # 25-30, Centro', 'Oriente',
 '2026-09-12 21:25:00', '2026-09-12 22:15:00', 9.50, 10000),

(7, 2, 'Calle 45 # 12-18, Norte', 'Norte',
 '2026-09-02 19:10:00', '2026-09-02 19:40:00', 4.20, 6000),

(8, 1, 'Calle 45 # 12-18, Norte', 'Centro',
 '2026-09-06 20:50:00', '2026-09-06 21:15:00', 3.40, 5000),

(9, 4, 'Carrera 8 # 30-15, Sur', 'Occidente',
 '2026-09-07 19:30:00', '2026-09-07 20:10:00', 6.00, 7500),

(13, 5, 'Carrera 25 # 45-10, Oriente', 'Oriente',
 '2026-08-25 18:20:00', '2026-08-25 18:50:00', 5.00, 6500),

-- Pedido todavía en preparación
(11, 5, 'Carrera 15 # 60-22, Norte', 'Oriente',
 NULL, NULL, 8.20, 9000),

-- Pedido pendiente
(12, 3, 'Calle 10 # 8-25, Centro', 'Sur',
 NULL, NULL, 5.50, 7000);



 INSERT INTO domicilios
(id_pedido, id_repartidor, direccion_entrega, zona,
 hora_salida, hora_entrega, distancia_km, costo_envio)
VALUES
-- Pedidos entregados
(1, 1, 'Carrera 10 # 25-30, Centro', 'Centro',
 '2026-09-01 12:50:00', '2026-09-01 13:15:00', 3.20, 5000),

(2, 2, 'Calle 45 # 12-18, Norte', 'Norte',
 '2026-09-03 19:40:00', '2026-09-03 20:10:00', 4.50, 6000),

(3, 1, 'Carrera 10 # 25-30, Centro', 'Centro',
 '2026-09-05 13:30:00', '2026-09-05 13:55:00', 3.00, 5000),

(4, 3, 'Carrera 10 # 25-30, Centro', 'Sur',
 '2026-09-08 20:25:00', '2026-09-08 21:05:00', 6.80, 8000),

(6, 5, 'Carrera 10 # 25-30, Centro', 'Oriente',
 '2026-09-12 21:25:00', '2026-09-12 22:15:00', 9.50, 10000),

(7, 2, 'Calle 45 # 12-18, Norte', 'Norte',
 '2026-09-02 19:10:00', '2026-09-02 19:40:00', 4.20, 6000),

(8, 1, 'Calle 45 # 12-18, Norte', 'Centro',
 '2026-09-06 20:50:00', '2026-09-06 21:15:00', 3.40, 5000),

(9, 4, 'Carrera 8 # 30-15, Sur', 'Occidente',
 '2026-09-07 19:30:00', '2026-09-07 20:10:00', 6.00, 7500),

(13, 5, 'Carrera 25 # 45-10, Oriente', 'Oriente',
 '2026-08-25 18:20:00', '2026-08-25 18:50:00', 5.00, 6500),

-- Pedido todavía en preparación
(11, 5, 'Carrera 15 # 60-22, Norte', 'Oriente',
 NULL, NULL, 8.20, 9000),

-- Pedido pendiente
(12, 3, 'Calle 10 # 8-25, Centro', 'Sur',
 NULL, NULL, 5.50, 7000);


 INSERT INTO pagos
(id_pedido, fecha_pago, metodo_pago, monto, estado_pago)
VALUES
(1, '2026-09-01 13:15:00', 'efectivo', 26420, 'pagado'),
(2, '2026-09-03 20:10:00', 'tarjeta', 41700, 'pagado'),
(3, '2026-09-05 13:55:00', 'app', 31180, 'pagado'),
(4, '2026-09-08 21:05:00', 'tarjeta', 61550, 'pagado'),
(5, '2026-09-10 18:30:00', 'efectivo', 33320, 'pagado'),
(6, '2026-09-12 22:15:00', 'app', 75450, 'pagado'),
(7, '2026-09-02 19:40:00', 'tarjeta', 48790, 'pagado'),
(8, '2026-09-06 21:15:00', 'efectivo', 51170, 'pagado'),
(9, '2026-09-07 20:10:00', 'app', 61285, 'pagado'),
(10, '2026-09-09 12:00:00', 'tarjeta', 35700, 'pagado'),
(11, '2026-09-11 20:15:00', 'app', 70210, 'pendiente'),
(12, '2026-09-12 19:30:00', 'efectivo', 58310, 'pendiente'),
(13, '2026-08-25 18:50:00', 'tarjeta', 45815, 'pagado'),
(14, '2026-08-28 20:00:00', 'efectivo', 41650, 'pagado'),
(15, '2026-09-13 14:00:00', 'efectivo', 0, 'rechazado');