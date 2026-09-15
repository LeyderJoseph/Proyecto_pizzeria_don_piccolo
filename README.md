# Pizzería Don Piccolo — Sistema de gestión de pedidos y domicilios

Base de datos relacional desarrollada en **MySQL** para apoyar la gestión de clientes, pizzas, ingredientes, pedidos, repartidores, domicilios y pagos de la Pizzería Don Piccolo.

El sistema reemplaza el registro manual de pedidos por una estructura que permite consultar ventas, controlar el inventario de ingredientes, registrar entregas a domicilio y auditar cambios de precios.

## Contenido

- [Modelo de datos](#modelo-de-datos)
- [Tablas principales](#tablas-principales)
- [Funciones](#funciones)
- [Procedimiento almacenado](#procedimiento-almacenado)
- [Triggers](#triggers)
- [Consultas realizadas](#consultas-realizadas)
- [Vistas](#vistas)
- [Evidencias sugeridas](#evidencias-sugeridas)

## Modelo de datos

El modelo contiene diez tablas relacionadas. Las claves foráneas aseguran que cada pedido pertenezca a un cliente, cada detalle corresponda a una pizza válida y cada domicilio tenga un repartidor asignado.

![Diagrama entidad-relación de Pizzería Don Piccolo](imagenes/Diagrama_pizzeria.png)

> El archivo `Diagrama_pizzeria.png` debe permanecer en la misma carpeta que este README para que GitHub o Visual Studio lo muestren correctamente.

## Tablas principales

| Tabla | Propósito |
|---|---|
| `clientes` | Almacena los datos personales y de contacto de los clientes. |
| `pizzas` | Contiene el menú: nombre, tamaño, precio, tipo y disponibilidad. |
| `ingredientes` | Controla existencias, stock mínimo, costo y disponibilidad de ingredientes. |
| `pizza_ingredientes` | Define la receta de cada pizza y la cantidad requerida de cada ingrediente. |
| `repartidores` | Registra repartidores, zona asignada y disponibilidad. |
| `pedidos` | Guarda la información general de cada venta. |
| `detalle_pedidos` | Relaciona los pedidos con las pizzas solicitadas. Un pedido puede tener varias pizzas. |
| `domicilios` | Registra el repartidor, las horas de salida y entrega, distancia y costo de envío. |
| `pagos` | Guarda el método, monto y estado del pago asociado a cada pedido. |
| `historial_precios` | Conserva los cambios de precio realizados sobre las pizzas. |

## Funciones

### 1. `calcular_total_pedido(id_pedido)`

Calcula el valor final de un pedido a partir de sus pizzas, el costo de envío y el IVA del 19% aplicado al subtotal de las pizzas.

```sql
SELECT calcular_total_pedido(1) AS total_pedido_1;
```

La función usa los valores almacenados en `detalle_pedidos`; de esta forma, un cambio posterior en el precio actual de una pizza no altera pedidos históricos.

### 2. `calcular_ganancia_neta_diaria(fecha)`

Calcula la ganancia neta de una fecha determinada:

```text
Ganancia neta = ventas de pedidos entregados − costo de ingredientes utilizados
```

```sql
SELECT calcular_ganancia_neta_diaria('2026-09-01') AS ganancia_neta;
```

## Procedimiento almacenado

### `registrar_entrega(id_domicilio, hora_entrega)`

Registra la hora de entrega de un domicilio y cambia automáticamente el estado del pedido relacionado a `entregado`.

```sql
CALL registrar_entrega(10, '2026-09-11 21:05:00');
```

Este procedimiento actualiza primero `domicilios.hora_entrega` y luego localiza el pedido asociado mediante `id_pedido`.

## Triggers

### Actualización automática de inventario

El trigger `actualizar_stock_ingredientes` se ejecuta después de insertar un registro en `detalle_pedidos`. Descuenta del stock la cantidad de ingredientes definida en la receta de la pizza.

Por ejemplo, si se piden dos Hawaianas familiares, se descuenta el doble de masa, salsa, queso, jamón, piña y orégano definidos para esa receta.

### Historial de precios

El trigger `registrar_historial_precio` se ejecuta cuando se actualiza `pizzas.precio_base`. Guarda en `historial_precios` el precio anterior, el precio nuevo y la fecha del cambio.

### Disponibilidad del repartidor

El trigger `liberar_repartidor` se activa cuando `domicilios.hora_entrega` cambia de `NULL` a una fecha válida. Entonces marca al repartidor asignado como `disponible`.

## Consultas realizadas

El proyecto incluye consultas para:

1. Clientes con pedidos entre dos fechas mediante `BETWEEN`.
2. Pizzas más vendidas mediante `GROUP BY`, `COUNT` y `SUM`.
3. Pedidos asignados por repartidor mediante `JOIN`.
4. Tiempo promedio de entrega por zona mediante `AVG` y `TIMESTAMPDIFF`.
5. Clientes que superan un monto de gasto mediante `HAVING`.
6. Búsqueda parcial de pizzas mediante `LIKE`.
7. Clientes frecuentes con más de cinco pedidos mensuales mediante una subconsulta.

## Vistas

| Vista | Información disponible |
|---|---|
| `vista_resumen_pedidos_cliente` | Cliente, cantidad de pedidos entregados y total gastado. |
| `vista_desempeno_repartidores` | Repartidor, zona, número de entregas y tiempo promedio de entrega. |
| `vista_stock_bajo_minimo` | Ingredientes cuyo stock actual está por debajo del mínimo permitido. |


### Función: total de pedido

![Resultado de la función calcular total pedido](imagenes/01_funcion_total_pedido.png)

### Función: ganancia neta diaria

![Resultado de la función ganancia neta diaria](imagenes/02_funcion_ganancia_neta.png)

### Procedimiento: registrar entrega

![Resultado del procedimiento registrar entrega](imagenes/03_procedimiento_registrar_entrega.png)

### Trigger: actualización de stock

![Resultado del trigger de inventario](imagenes/04_trigger_actualizar_stock.png)

### Trigger: historial de precios

![Resultado del trigger de historial de precios](imagenes/05_trigger_historial_precios.png)

### Trigger: repartidor disponible

![Resultado del trigger de repartidor disponible](imagenes/06_trigger_repartidor_disponible.png)

### Consultas y vistas

Guarda una captura individual para cada consulta y vista. Esto permite demostrar claramente el resultado de cada requerimiento.

#### Consulta 1: clientes con pedidos entre fechas

![Clientes con pedidos entre fechas](imagenes/07_consulta_clientes_entre_fechas.png)

#### Consulta 2: pizzas más vendidas

![Pizzas más vendidas](imagenes/08_consulta_pizzas_mas_vendidas.png)

#### Consulta 3: pedidos por repartidor

![Pedidos por repartidor](imagenes/09_consulta_pedidos_por_repartidor.png)

#### Consulta 4: promedio de entrega por zona

![Promedio de entrega por zona](imagenes/10_consulta_promedio_entrega_zona.png)

#### Consulta 5: clientes con gasto superior al monto

![Clientes con gasto superior al monto](imagenes/11_consulta_clientes_mayor_gasto.png)

#### Consulta 6: búsqueda parcial de pizza

![Búsqueda parcial de pizza](imagenes/12_consulta_busqueda_like.png)

#### Consulta 7: clientes frecuentes

![Clientes frecuentes](imagenes/13_consulta_clientes_frecuentes.png)

#### Vista 1: resumen de pedidos por cliente

![Vista resumen de pedidos por cliente](imagenes/14_vista_resumen_pedidos_cliente.png)

#### Vista 2: desempeño de repartidores

![Vista desempeño de repartidores](imagenes/15_vista_desempeno_repartidores.png)

#### Vista 3: ingredientes bajo stock mínimo

![Vista de stock bajo mínimo](imagenes/16_vista_stock_bajo_minimo.png)

## Tecnologías utilizadas

- MySQL 8.0
- MySQL Workbench
- Visual Studio Code

---

Proyecto académico de base de datos para la gestión de pedidos y domicilios de Pizzería Don Piccolo.
