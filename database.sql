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
(id_pizza, id_ingrediente, cantidad_requerida)
VALUES
-- 1 a 4. Margarita
(1, 1, 200), (1, 2, 60),  (1, 3, 100), (1, 18, 2),
(2, 1, 350), (2, 2, 100), (2, 3, 160), (2, 18, 3),
(3, 1, 600), (3, 2, 150), (3, 3, 250), (3, 18, 4),
(4, 1, 850), (4, 2, 210), (4, 3, 350), (4, 18, 6),

-- 5 a 8. Hawaiana
(5, 1, 200), (5, 2, 60),  (5, 3, 100), (5, 4, 40),  (5, 5, 40),  (5, 18, 2),
(6, 1, 350), (6, 2, 100), (6, 3, 160), (6, 4, 70),  (6, 5, 70),  (6, 18, 3),
(7, 1, 600), (7, 2, 150), (7, 3, 250), (7, 4, 100), (7, 5, 100), (7, 18, 4),
(8, 1, 850), (8, 2, 210), (8, 3, 350), (8, 4, 150), (8, 5, 150), (8, 18, 6),

-- 9 a 12. Pepperoni
(9, 1, 200),  (9, 2, 60),  (9, 3, 100),  (9, 6, 50),  (9, 18, 2),
(10, 1, 350), (10, 2, 100), (10, 3, 160), (10, 6, 90),  (10, 18, 3),
(11, 1, 600), (11, 2, 150), (11, 3, 250), (11, 6, 140), (11, 18, 4),
(12, 1, 850), (12, 2, 210), (12, 3, 350), (12, 6, 200), (12, 18, 6),

-- 13 a 16. Don Piccolo Especial
(13, 1, 200), (13, 2, 60),  (13, 3, 100), (13, 4, 40),  (13, 6, 40),
(13, 7, 40),  (13, 8, 30),  (13, 9, 25),  (13, 10, 20), (13, 15, 30), (13, 18, 2),

(14, 1, 350), (14, 2, 100), (14, 3, 160), (14, 4, 70),  (14, 6, 70),
(14, 7, 70),  (14, 8, 55),  (14, 9, 45),  (14, 10, 35), (14, 15, 50), (14, 18, 3),

(15, 1, 600), (15, 2, 150), (15, 3, 250), (15, 4, 100), (15, 6, 100),
(15, 7, 100), (15, 8, 80),  (15, 9, 60),  (15, 10, 50), (15, 15, 80), (15, 18, 4),

(16, 1, 850), (16, 2, 210), (16, 3, 350), (16, 4, 150), (16, 6, 150),
(16, 7, 150), (16, 8, 120), (16, 9, 90),  (16, 10, 75), (16, 15, 110), (16, 18, 6),

-- 17 a 20. Pollo con Champinones
(17, 1, 200), (17, 2, 60),  (17, 3, 100), (17, 7, 60),  (17, 8, 45),  (17, 18, 2),
(18, 1, 350), (18, 2, 100), (18, 3, 160), (18, 7, 100), (18, 8, 80),  (18, 18, 3),
(19, 1, 600), (19, 2, 150), (19, 3, 250), (19, 7, 150), (19, 8, 120), (19, 18, 4),
(20, 1, 850), (20, 2, 210), (20, 3, 350), (20, 7, 210), (20, 8, 170), (20, 18, 6),

-- 21 a 24. Vegetariana
(21, 1, 200), (21, 2, 60),  (21, 3, 100), (21, 8, 40),  (21, 9, 30),
(21, 10, 30), (21, 11, 40), (21, 12, 20), (21, 18, 2),

(22, 1, 350), (22, 2, 100), (22, 3, 160), (22, 8, 70),  (22, 9, 50),
(22, 10, 50), (22, 11, 70), (22, 12, 35), (22, 18, 3),

(23, 1, 600), (23, 2, 150), (23, 3, 250), (23, 8, 100), (23, 9, 80),
(23, 10, 80), (23, 11, 100), (23, 12, 60), (23, 18, 4),

(24, 1, 850), (24, 2, 210), (24, 3, 350), (24, 8, 150), (24, 9, 110),
(24, 10, 110), (24, 11, 150), (24, 12, 85), (24, 18, 6),

-- 25 a 28. Cuatro Quesos
(25, 1, 200), (25, 2, 50),  (25, 3, 70),  (25, 13, 30), (25, 14, 25), (25, 18, 2),
(26, 1, 350), (26, 2, 80),  (26, 3, 100), (26, 13, 50), (26, 14, 40), (26, 18, 3),
(27, 1, 600), (27, 2, 120), (27, 3, 160), (27, 13, 75), (27, 14, 60), (27, 18, 4),
(28, 1, 850), (28, 2, 170), (28, 3, 220), (28, 13, 105), (28, 14, 80), (28, 18, 6),

-- 29 a 32. Mexicana
(29, 1, 200), (29, 2, 60),  (29, 3, 100), (29, 16, 80),  (29, 10, 30),
(29, 9, 40),  (29, 17, 20), (29, 18, 2),

(30, 1, 350), (30, 2, 100), (30, 3, 160), (30, 16, 110), (30, 10, 45),
(30, 9, 60),  (30, 17, 30), (30, 18, 3),

(31, 1, 600), (31, 2, 150), (31, 3, 250), (31, 16, 150), (31, 10, 60),
(31, 9, 80),  (31, 17, 40), (31, 18, 4),

(32, 1, 850), (32, 2, 210), (32, 3, 350), (32, 16, 220), (32, 10, 90),
(32, 9, 120), (32, 17, 60), (32, 18, 6),

-- 33 a 36. Napolitana
(33, 1, 200), (33, 2, 60),  (33, 3, 100), (33, 11, 50),  (33, 12, 25),  (33, 18, 2),
(34, 1, 350), (34, 2, 100), (34, 3, 160), (34, 11, 80),  (34, 12, 40),  (34, 18, 3),
(35, 1, 600), (35, 2, 150), (35, 3, 250), (35, 11, 120), (35, 12, 60),  (35, 18, 4),
(36, 1, 850), (36, 2, 210), (36, 3, 350), (36, 11, 170), (36, 12, 85),  (36, 18, 6);


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
