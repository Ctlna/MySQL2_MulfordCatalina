#####################
# Dia 7 - MySQL 2 ##
#####################

use mysql2_dia5;

/*
# subconsultas: Se usa para realizar operaciones que requieren un conjunto de datos 
que se obtiene por medio de otra consulta.


- subconsulta escalar: devuelve un solo valor (fila y columna);
EJ: Devuelva el país con mayor población*/
select name
from country
where Population= (select max(Population)from country);

/*
#  subconsulta de columna única: Devuelve una columna de múltiples filas 
EJ: Nombre de las ciudades en los paises con área mayor a 100000 km2*/
select name
from city
where CountryCode in (select code from country where SurfaceArea > 1000000);

/*
# subconsulta de múltiples columnas: Devuelve múltiples columnas de múltiples filas.
EJ: Ciudades con misma población y distrito de cualquier país  ‘USA’*/
select name,CountryCode,District,Population
from city
where(District,Population) in (select District,Population from city where CountryCode = 'USA');

/*
# subconsulta Correlacionada: Depende de consulta externa para fila procesada
EJ: ciudades con población mayor al promedio de las otras ciudades del mismo pais*/
select name,CountryCode,Population
from city c1
where Population > (select avg (Population) from city c2 where c1.CountryCode = c1.CountryCode);

/*#  subconsulta Múltiple: Devuelve una columna de múltiples filas 
EJ: lista ciudades que tengan la misma población de la capital del pais 'JPN'(Japon)*/
select name
from city
where Population= (select Population from city where ID=(
select Capital from country where code = 'JPN'));

-- INDEXACIÓN
select * from city;
create index idx_city_name on city(Name);
select name from city;

-- crea indice de las columnas district y popultaion
create index idx_city_district_population on city(District,Population);

-- datos para ver indices creados

select * from city;

-- Crear índice en la columna 'NAME' de City
create index idx_city_name on city(Name);
select * from city;
select Name from city;

-- Crear índice compuesto de las columnas 'District' y 'Population'
create index idx_city_district_population on city(District,Population);

-- Datos estadísticos para ver los índices creados
SELECT 
    TABLE_NAME, 
    INDEX_NAME, 
    SEQ_IN_INDEX, 
    COLUMN_NAME, 
    CARDINALITY, 
    SUB_PART, 
    INDEX_TYPE, 
    COMMENT
FROM 
    information_schema.STATISTICS
WHERE 
    TABLE_SCHEMA = 'mysql2_dia5';
-- Revisar tamaño de Indexaciones creadas
SELECT 
    TABLE_NAME, 
    INDEX_LENGTH 
FROM 
    information_schema.TABLES 
WHERE 
    TABLE_SCHEMA = 'mysql2_dia5';
    

/* transacciones
Secuencias de 1 ó más SQL, se ejecuta como una única unidad. Se asegura que todos 
las operaciones se realicen de manera correcta antes de ejecutarse en la bbdd real, busca 
cumplir las propiedades ACID.(Atomicidad, Consistencia, Aislamiento, Durabilidad).

1er paso. Inicia la transacción*/
start transaction;

-- 2do.paso. Hacer Comandos
# EJ: Actualiza poblacion new york
update city
set Population = 9000000
where name = 'New York';

select * from city where name= 'New York';

-- 3er paso. Si quiero mantener los cambios 'COMMIT' y si me arrepiento 'ROLLBACK'
commit; -- Aceptar cambios
rollback; -- Revetir cambios

-- Desarrollado por Catalina Mulford / ID 1.097.490.150
