RetailPro - Data Analytics SQL Project
Descripción
RetailPro es un proyecto de análisis de datos desarrollado para una empresa ficticia del sector de retail tecnológico. El objetivo es demostrar habilidades en consultas SQL, análisis de información y obtención de indicadores de negocio a partir de una base de datos relacional.
El proyecto permite analizar información relacionada con:
•	Ventas
•	Clientes
•	Productos
•	Categorías
•	Territorios
A través de diferentes consultas SQL se obtienen métricas comerciales que ayudan a la toma de decisiones, como facturación, ticket promedio, productos más vendidos y comportamiento de los clientes.
________________________________________
Objetivos
•	Consultar información desde múltiples tablas relacionadas.
•	Aplicar buenas prácticas de SQL.
•	Utilizar funciones de agregación.
•	Implementar filtros, ordenamientos y agrupamientos.
•	Analizar indicadores comerciales.
•	Generar información útil para la toma de decisiones.
________________________________________
Tecnologías utilizadas
•	PostgreSQL
•	SQL
•	Power BI Desktop
•	GitHub
________________________________________
Estructura del proyecto
DataAnalytics/
│
├── Modulo3/
│   ├── README_Modulo3.md
│   └── ventas_tech_db_JMartinez.sql
├── Modulo4/
│   ├── README_Modulo4.md
│   └── m4_consultas_negocio_JMartinez.sql
├── Modulo5/
│   ├── README_Modulo5.md
│   └── m5_consultas_joins_JMartinez.sql
├── Modulo6/
│   ├── README_Modulo6.md
│   └── Pipeline_ETL_Martinez_Jorge.pbix
├── Modulo8/
│   ├── README_Modulo8.md
│   └── Martinez_Jorge_Checkpoint2.pbix
└── README.md
La estructura puede adaptarse según la organización del repositorio.
________________________________________
Modelo de datos
El proyecto trabaja con las siguientes tablas principales:
•	ventas
•	clientes
•	productos
•	categorias
•	territorios
Las relaciones permiten obtener reportes completos mediante consultas con JOIN.
________________________________________
Indicadores analizados
Entre los indicadores generados se encuentran:
•	Facturación total
•	Cantidad de pedidos
•	Ticket promedio
•	Productos con mayor facturación
•	Productos más vendidos
•	Clientes con mayor gasto
•	Ventas por región
•	Ventas por categoría
•	Comparación de ventas mensuales
________________________________________
Cómo ejecutar el proyecto
A. Archivos SQL:
1. Se requiere tener instalado el software PostgreSQL y pgAdmin.
2. Se ejecutan los archivos individualmente.
Tambien se pueden ejecutar desde cualquier cliente o página web compatible con PostgreSQL.

B. Archivos .pbix:
1. Se requiere tener instalado el software Power Bi Desktop
________________________________________
Ejemplos de análisis
El proyecto permite responder preguntas como:
•	¿Cuál fue la facturación mensual?
•	¿Qué productos generan más ingresos?
•	¿Cuáles son los clientes con mayor gasto?
•	¿Qué regiones presentan mejores resultados?
•	¿Cuál es el ticket promedio por período?
________________________________________
Buenas prácticas aplicadas
•	Uso de INNER JOIN para relacionar tablas.
•	Alias para mejorar la legibilidad.
•	Consultas organizadas por temática.
•	Nombres descriptivos de columnas.
•	Uso de funciones de agregación (SUM, COUNT, AVG).
•	Agrupamiento mediante GROUP BY.
•	Ordenamiento con ORDER BY.
________________________________________
Posibles mejoras futuras
•	Incorporar vistas (VIEW) para reportes frecuentes.
•	Crear procedimientos almacenados.
•	Optimizar consultas mediante índices.
•	Agregar dashboards en Power BI.
•	Automatizar reportes periódicos.
•	Incorporar análisis de tendencias y crecimiento interanual.
________________________________________
Autor
Jorge Martínez
Analista de Sistemas | Data Analytics | SQL | Power BI | PostgreSQL
________________________________________
Licencia
Este proyecto fue desarrollado con fines educativos y como parte de un portafolio personal de análisis de datos.
