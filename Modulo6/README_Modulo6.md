# Pipeline_ETL_Martinez_Jorge.pbix - Entrega Modulo 6 - Jorge Martinez
Pipeline ETL desde SQL con Power Query y M

## Contenido
Basado en el archivo .xlsx provisto se realizan transformaciones de datos y uso del Editor Avanzado:
1- Conexión a la fuente de datos
2- Perfilado de datos
3- Transformaciones avanzadas
4- Documentación en lenguaje M
5- Verificación y cierre


- Paso 2, Justificacion de nulos:
Tabla clientes:
Decidí reemplazar los registros nulos de email y ciudad con un valor por defecto, "Sin dato", ya que no participan de ninguna relación del resto de las tablas y borrarlos generaría ventas huérfanas al perder el cliente.

Tabla productos,
Al producto con precio nulo y al producto con categoria nula les asigné un registro existente inferido a traves de otras tablas. Precio, de ventas registradas del mismo producto y Categoria de subcategorias iguales con su categorias correspondiente de otros productos.

NOTA: Para mejora del modelo elimine los registros con todas las columnas vacias.


## Conclusión
En esta entrega aplicamos conceptos de Power Query con lenguaje M, a través de la plataforma de Power BI y utilizando GitHub.