-- m4_consultas_negocio.sql
-- Se usan los nombres fecha, productoID, clienteID, precio, tal como en M3, en lugar de fecha_venta, id_producto, id_cliente y precio_unitario

/* 
--****** CODIGO CREACION DB MOD3 ******
--*************************************

DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;
CREATE TABLE categorias (
    categoriaID	INT PRIMARY KEY,
    nombreCategoria VARCHAR(80) NOT NULL
);

CREATE TABLE clientes (
    clienteID INT PRIMARY KEY,
    nombreCliente VARCHAR(120) NOT NULL,
    email  VARCHAR(120) NOT NULL,
    ciudad VARCHAR(80)
);

CREATE TABLE productos (
    productoID INT PRIMARY KEY,
    nombreProducto VARCHAR(120) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    categoriaID INT NOT NULL,
    CONSTRAINT FK_productos_categorias
		FOREIGN KEY (categoriaID) 
		REFERENCES categorias(categoriaID)
);

CREATE TABLE ventas (
    ventaID INT PRIMARY KEY,
    fecha DATE,
    clienteID INT NOT NULL,
    productoID INT NOT NULL,
    cantidad INT NOT NULL,
    CONSTRAINT FK_ventas_clientes
		FOREIGN KEY (clienteID) 
		REFERENCES clientes(clienteID),
    CONSTRAINT FK_ventas_productos
		FOREIGN KEY (productoID) 
		REFERENCES productos(productoID)
);

INSERT INTO categorias (categoriaID, nombreCategoria) VALUES
(1, 'Notebooks'),
(2, 'Celulares'),
(3, 'Accesorios');

INSERT INTO clientes (clienteID, nombreCliente, email, ciudad) VALUES
(1, 'Julian Alvarez', 'julianalvarez@gmail.com', 'Cordoba'),
(2, 'Laura Perez', 'lauraperez@gmail.com', 'Neuquen'),
(3, 'Lionel Messi','lionelmessi@gmail.com','Rosario');

INSERT INTO productos (productoID, nombreProducto, precio, categoriaID) VALUES
(1, 'Notebook Hp', 750000, 1),
(2, 'Notebook Dell', 880000, 1),
(3, 'Celular Samsung', 400000, 2),
(4, 'Celular Iphone', 950000, 2),
(5, 'Teclado Dell', 15000, 3);

INSERT INTO ventas (ventaID, fecha, clienteID, productoID, cantidad) VALUES
(1, '2026-01-05', 1, 1, 1),
(2, '2026-01-08', 2, 3, 1),
(3, '2026-01-10', 3, 5, 2),
(4, '2026-01-15', 1, 4, 1),
(5, '2026-01-20', 2, 2, 1),
(6, '2026-02-05', 3, 3, 1),
(7, '2026-02-08', 1, 5, 3),
(8, '2026-02-10', 2, 1, 1),
(9, '2026-02-15', 3, 4, 1),
(10, '2026-02-20', 1, 2, 1),
(11, '2026-03-05', 3, 3, 1),
(12, '2026-03-08', 3, 5, 3),
(13, '2026-03-10', 2, 1, 1),
(14, '2026-03-15', 3, 4, 2),
(15, '2026-03-20', 1, 2, 1);

--****** CODIGO CREACION DB MOD3 ******
--*************************************
*/



-- Consulta 1 Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio, agrupados por mes
-- *************************************************************************
SELECT
    EXTRACT(MONTH FROM v.fecha) AS mes,
    SUM(v.cantidad * p.precio) AS totalFacturado,
    COUNT(*) AS cantidadPedidos,
    ROUND(SUM(v.cantidad * p.precio) / COUNT(*), 2) AS ticketPromedio
FROM ventas v
JOIN productos p ON v.productoID = p.productoID
GROUP BY mes;


-- Consulta 2 Ranking de productos, 
-- Top 5 por total facturado
-- ******************************************************************
SELECT
    v.productoID,
    p.nombreProducto,
    SUM(v.cantidad * p.precio) AS totalFacturado,
    SUM(v.cantidad) AS unidadesVendidas
FROM ventas v
JOIN productos p ON v.productoID = p.productoID
GROUP BY v.productoID, p.nombreProducto
ORDER BY totalFacturado DESC
LIMIT 5;


-- Consulta 3 Clientes recurrentes
-- Cantidad de pedidos y total gastado, pedido > 1
-- ******************************************************************
SELECT
    v.clienteID,
    c.nombreCliente,
    COUNT(*) AS cantidadPedidos,
    SUM(v.cantidad * p.precio) AS totalGastado
FROM ventas v
JOIN clientes c  ON v.clienteID = c.clienteID
JOIN productos p ON v.productoID = p.productoID
GROUP BY v.clienteID, c.nombreCliente
HAVING COUNT(*) > 1
ORDER BY totalGastado DESC;


-- Consulta 4 Meses por encima/por debajo del promedio
-- Total facturado por mes
-- ******************************************************************
WITH facturacionMensual AS (
    SELECT
        EXTRACT(MONTH FROM v.fecha) AS mes,
        SUM(v.cantidad * p.precio) AS totalFacturado
    FROM ventas v
    JOIN productos p ON v.productoID = p.productoID
    GROUP BY mes
	),
	promedioGeneral AS (
		SELECT ROUND(AVG(totalFacturado),2) AS promedioMensual
		FROM facturacionMensual
	)
	SELECT
		mes,
		totalFacturado,
		promedioMensual,
    CASE
        WHEN totalFacturado > promedioMensual 
		THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacionPromedio
FROM facturacionMensual
CROSS JOIN promedioGeneral
ORDER BY mes;


-- Hallazgos
-- ****************************************************************
-- 1. El celular Iphone es el producto que más facturó, representa casi el 30% del total del período con 4 unidades vendidas.
-- 2. Las notebooks concentran aproximadamente un 50% de la facturación total, lo que confirma que la categoria Notebooks es el principal ingreso por sobre Celulares y Accesorios.
-- 3. Marzo es el mes con mayor facturacion registrada, presenta una diferencia notoria con respecto a meses anteriores, en cambio en Enero y febrero la facturación es muy similar. Este dato podria indicar una tendencia en aumento o determinar que en Marzo las personas necesitan de estos productos.
-- 4. Los tres clientes son recurrentes, mas de un pedido cada uno.
-- 5. Se observa un monto alto de ingresos en pocos productos, el volumen de unidades es bajo pero significante para el total de facturacion.

-- Conclusion
-- ****************************************************************
-- En esta entrega necesitamos mayor comprension para realizar consultas a través de script SQL y continuamos utilizando repositorio de GitHub.