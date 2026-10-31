-- Caso 2: Modelo de constelación · ContosoRetailDW
-- Consultas SQL utilizadas en la exploración de la base de datos
-- Autora: Daniela Mora Aguilar

-- A.1 Tablas y número de filas
SELECT t.name AS tabla, SUM(p.rows) AS filas
FROM sys.tables t
JOIN sys.partitions p ON p.object_id = t.object_id AND p.index_id IN (0,1)
GROUP BY t.name
ORDER BY t.name;

-- A.2 Llaves foráneas de las tablas de hechos
SELECT OBJECT_NAME(fk.parent_object_id) AS tabla_hecho,
       COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS columna,
       OBJECT_NAME(fk.referenced_object_id) AS dimension
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
WHERE OBJECT_NAME(fk.parent_object_id) LIKE 'Fact%'
ORDER BY tabla_hecho;

-- A.3 Rango de fechas por tabla de hechos
SELECT 'FactSales' AS tabla, MIN(DateKey) AS desde, MAX(DateKey) AS hasta FROM FactSales
UNION ALL
SELECT 'FactOnlineSales', MIN(DateKey), MAX(DateKey) FROM FactOnlineSales
UNION ALL
SELECT 'FactInventory', MIN(DateKey), MAX(DateKey) FROM FactInventory;

-- A.4 Relaciones entre dimensiones
SELECT OBJECT_NAME(fk.parent_object_id) AS tabla,
       COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS columna,
       OBJECT_NAME(fk.referenced_object_id) AS referencia
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
WHERE OBJECT_NAME(fk.parent_object_id) LIKE 'Dim%'
ORDER BY tabla;
