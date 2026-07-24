-- Base de datos ventas_Tech_Db para TechStore

-- Limpieza (orden inverso de dependencias)
-- ************************************************************
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;


-- 1 Definicion de esquema DDL -1ro dimension desp tabla ventas-
-- ************************************************************
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


/* 2 Restricciones de Integridad, ya aplicadas en DDL
-- ************************************************************
   PRIMARY KEY en tablas
   FOREIGN KEY clienteID, productoID, categoriaID
   NOT NULL en campos criticos (nombreCliente, precio, otros)
   DECIMAL(10,2) para valores monetarios, precio
*/


-- 3 Carga Inicial de Datos (DML) 
-- 1ro categorias y clientes, luego productos y ventas
-- ************************************************************
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

-- Consulta de validacion, 10 filas con datos de 4 tablas
-- ****************************************************************
SELECT
    v.ventaID,
    v.fecha,
    c.nombreCliente,
    p.nombreProducto,
    cat.nombreCategoria,
    v.cantidad,
    p.precio
FROM ventas v
JOIN clientes c ON v.clienteID = c.clienteID
JOIN productos p ON v.productoID = p.productoID
JOIN categorias cat ON p.categoriaID = cat.categoriaID
ORDER BY v.ventaID;
