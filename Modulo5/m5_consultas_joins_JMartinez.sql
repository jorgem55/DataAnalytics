-- m5_consultas_joins.sql
-- Ejemplos guiados: combinar consultas y limpiar columnas compatibles

-- El esquema de BD anterior no incluye territorios, segmento de cliente, region, ni canal de venta. Para poder resolver las consultas se agregan tablas, atributos y registros al modelo.


--****** CODIGO CREACION DB MOD3 ******
--*************************************
-- TINYINT no es compatible con postgresql, se utiliza BOOLEAN
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


-- AGREGADO de tabla territorios, registros segmento, region y canal
-- **************************************************************
DROP TABLE IF EXISTS territorios;

CREATE TABLE territorios (
    territorioID INT PRIMARY KEY,
    region VARCHAR(80) NOT NULL
);

-- AGREGADO nuevos atributos
ALTER TABLE clientes ADD COLUMN segmento VARCHAR(50);
ALTER TABLE clientes ADD COLUMN territorioID INT REFERENCES territorios(territorioID);
ALTER TABLE ventas ADD COLUMN canal VARCHAR(20);

-- AGREGADO nuevos registros
INSERT INTO territorios (territorioID, region) VALUES
(1, 'Centro'), (2, 'Patagonia'), (3, 'Litoral'), (4, 'Cuyo');
UPDATE clientes SET segmento='Pyme', territorioID=1 WHERE id_cliente=1;
UPDATE clientes SET segmento='Particular', territorioID=2 WHERE id_cliente=2;
UPDATE clientes SET segmento='Pyme', territorioID=3 WHERE id_cliente=3;
UPDATE clientes SET segmento='Pyme', territorioID=3 WHERE id_cliente=4;
UPDATE clientes SET segmento='Particular', territorioID=2 WHERE id_cliente=5;
UPDATE ventas SET canal='Online' WHERE id_venta IN (1,3,4,6,8,10,13,14,15);
UPDATE ventas SET canal='Presencial' WHERE id_venta IN (2,5,7,9,11,12);

-- AGREGADO Cliente sin venta relacionada
INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro, segmento, territorioID) VALUES
(6, 'Luis Perez', 'luis@gmail.com', 'Mendoza', '2026-01-01', 'Pyme', 4);

-- AGREGADO Producto sin venta relacionada
INSERT INTO productos VALUES (7, 'Joystick pepito',    1,   205.00, 9, true);


-- Consulta 1 Vista base del proyecto (INNER JOIN)
-- Combiná ventas, clientes, productos y territorios para obtener en una sola fila: fecha, nombre cliente, segmento, region, nombre producto, categoría, cantidad, precio, total de venta y canal.
-- ************************************************
SELECT
    v.fecha_venta AS fechaVenta,
    c.nombre AS nombreCliente,
    c.segmento,
    t.region,
    p.nombre_producto AS nombreProducto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS totalVenta,
    v.canal AS canalVenta
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN territorios t ON c.territorioID = t.territorioID
JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;


-- Consulta 2 Clientes sin ventas (LEFT JOIN)
-- ****************************************************************
SELECT
    c.nombre,
    c.email,
    c.fecha_registro AS fechaRegistro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;


-- Consulta 3 Productos sin ventas (LEFT JOIN)
-- ****************************************************************
SELECT
    p.nombre_producto AS nombreProducto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;


-- Consulta 4 Consolidado por canal (UNION ALL + GROUP BY)
-- ****************************************************************
SELECT
    canalVenta,
    SUM(cantidad * precioUnitario) AS totalPorCanal
FROM (
    SELECT v.canal AS canalVenta, v.cantidad AS cantidad, v.precio_unitario AS precioUnitario
    FROM ventas v
    JOIN productos p ON v.id_producto = p.id_producto
    WHERE v.canal = 'Online'
    UNION ALL
    SELECT v.canal AS canalVenta, v.cantidad AS cantidad, v.precio_unitario AS precioUnitario
    FROM ventas v
    JOIN productos p ON v.id_producto = p.id_producto
    WHERE v.canal = 'Presencial'
)
GROUP BY canalVenta