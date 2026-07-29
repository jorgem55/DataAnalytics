-- m4_consultas_negocio.sql


--****** CODIGO CREACION DB MOD3 ******
--*************************************
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

CREATE TABLE categorias (
    id_categoria	INT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
	descripcion VARCHAR(200)
);

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email  VARCHAR(100) UNIQUE,
    ciudad VARCHAR(50),
	fecha_registro DATE NOT NULL
);

CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria INT NOT NULL,
	precio DECIMAL(10,2) NOT NULL,    
    CONSTRAINT FK_productos_categorias
		FOREIGN KEY (id_categoria) 
		REFERENCES categorias(id_categoria),
	stock INT DEFAULT 0,
	activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    cantidad INT NOT NULL,
    CONSTRAINT FK_ventas_clientes
		FOREIGN KEY (id_cliente) 
		REFERENCES clientes(id_cliente),
    CONSTRAINT FK_ventas_productos
		FOREIGN KEY (id_producto) 
		REFERENCES productos(id_producto),
	precio_unitario DECIMAL(10,2) NOT NULL,
	fecha_venta DATE NOT NULL
);

INSERT INTO categorias VALUES (1, 'Computación', 'Laptops, PCs y monitores');
INSERT INTO categorias VALUES (2, 'Accesorios', 'Periféricos y complementos');
INSERT INTO categorias VALUES (3, 'Audio', 'Auriculares y parlantes');
INSERT INTO categorias VALUES (4, 'Almacenamiento', 'Discos y memorias');

INSERT INTO clientes VALUES (1, 'María López',   'maria@mail.com',   'Buenos Aires', '2024-01-05');
INSERT INTO clientes VALUES (2, 'Carlos Ruiz',   'carlos@mail.com',  'Córdoba',      '2024-01-10');
INSERT INTO clientes VALUES (3, 'Ana Gómez',     'ana@mail.com',     'Rosario',      '2024-02-01');
INSERT INTO clientes VALUES (4, 'Pedro Sanz',    'pedro@mail.com',   'Mendoza',      '2024-02-15');
INSERT INTO clientes VALUES (5, 'Laura Torres',  'laura@mail.com',   'Tucumán',      '2024-03-01');

INSERT INTO productos VALUES (1, 'Laptop Pro 15',       1, 1200.00, 15, true);
INSERT INTO productos VALUES (2, 'Mouse Inalámbrico',   2,   28.00, 80, true);
INSERT INTO productos VALUES (3, 'Monitor 4K 27"',      1,  450.00, 12, true);
INSERT INTO productos VALUES (4, 'Auriculares BT Pro',  3,  120.00, 35, true);
INSERT INTO productos VALUES (5, 'SSD Externo 1TB',     4,  130.00, 18, true);
INSERT INTO productos VALUES (6, 'Teclado Mecánico',    2,   95.00, 40, true);

INSERT INTO ventas VALUES (1, 1, 1, 2, 1200.00, '2024-03-05');
INSERT INTO ventas VALUES (2, 2, 2, 5,   28.00, '2024-03-06');
INSERT INTO ventas VALUES (3, 3, 3, 1,  450.00, '2024-03-07');
INSERT INTO ventas VALUES (4, 1, 4, 2,  120.00, '2024-03-08');
INSERT INTO ventas VALUES (5, 4, 5, 3,  130.00, '2024-03-10');
INSERT INTO ventas VALUES (6, 2, 6, 4,   95.00, '2024-03-11');
INSERT INTO ventas VALUES (7, 5, 1, 1, 1200.00, '2024-03-12');
INSERT INTO ventas VALUES (8, 3, 2, 8,   28.00, '2024-03-13');
INSERT INTO ventas VALUES (9, 4, 4, 1,  120.00, '2024-03-14');
INSERT INTO ventas VALUES (10, 5, 3, 2,  450.00, '2024-03-15');
--****** CODIGO CREACION DB MOD3 ******
--*************************************


-- Consulta 1 Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes
-- *************************************************************************
SELECT
    EXTRACT(MONTH FROM v.fecha_venta) AS mes,
    SUM(v.cantidad * p.precio) AS totalFacturado,
    COUNT(*) AS cantidadPedidos,
    ROUND(SUM(v.cantidad * p.precio) / COUNT(*), 2) AS ticketPromedio
FROM ventas v
JOIN productos p ON v.id_producto = p.id_producto
GROUP BY mes;


-- Consulta 2 Ranking de productos, 
-- Top 5 por total facturado
-- ******************************************************************
SELECT
    v.id_producto,
    p.nombre_producto,
    SUM(v.cantidad * p.precio) AS totalFacturado,
    SUM(v.cantidad) AS unidadesVendidas
FROM ventas v
JOIN productos p ON v.id_producto = p.id_producto
GROUP BY v.id_producto, p.nombre_producto
ORDER BY totalFacturado DESC
LIMIT 5;


-- Consulta 3 Clientes recurrentes
-- Cantidad de pedidos y total gastado, pedido > 1
-- ******************************************************************
SELECT
    v.id_cliente,
    c.nombre,
    COUNT(*) AS cantidadPedidos,
    SUM(v.cantidad * p.precio) AS totalGastado
FROM ventas v
JOIN clientes c  ON v.id_cliente = c.id_cliente
JOIN productos p ON v.id_producto = p.id_producto
GROUP BY v.id_cliente, c.nombre
HAVING COUNT(*) > 1
ORDER BY totalGastado DESC;


-- Consulta 4 Meses por encima/por debajo del promedio
-- Total facturado por mes
-- ******************************************************************
WITH facturacionMensual AS (
    SELECT
        EXTRACT(MONTH FROM v.fecha_venta) AS mes,
        SUM(v.cantidad * p.precio) AS totalFacturado
    FROM ventas v
    JOIN productos p ON v.id_producto = p.id_producto
    GROUP BY mes
)
SELECT
    mes,
    totalFacturado,
    CASE
        WHEN totalFacturado > (SELECT AVG(totalFacturado) FROM facturacionMensual)
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM facturacionMensual


-- Hallazgos
-- ****************************************************************
-- 1. La notebook Pro 15 concentra aproximadamente un 60% de la facturación total, lo que confirma que la categoria Computacion es el principal ingreso.
-- 2. Mouse Inalámbrico es el producto mas vendido, presenta una diferencia notoria con respecto a los demas productos e indica que se debe aumentar el stock.
-- 3. Maria Lopez es la clienta con mayor monto en sus compras.

-- Conclusion
-- ****************************************************************
-- En esta entrega necesitamos mayor comprension para realizar consultas a través de script SQL y continuamos utilizando repositorio de GitHub.