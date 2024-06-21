-- ##############################
-- ###### DIA 2 - MySQL 2  ######
-- ##############################

-- Titulo: Consultas avanzadas
create database Ejercicio2;
use Ejercicio2;

CREATE TABLE departamento (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL,
	presupuesto DOUBLE UNSIGNED NOT NULL,
	gastos DOUBLE UNSIGNED NOT NULL
);
INSERT INTO departamento VALUES(1, 'Desarrollo', 120000, 6000);
INSERT INTO departamento VALUES(2, 'Sistemas', 150000, 21000);
INSERT INTO departamento VALUES(3, 'Recursos Humanos', 280000, 25000);
INSERT INTO departamento VALUES(4, 'Contabilidad', 110000, 3000);
INSERT INTO departamento VALUES(5, 'I+D', 375000, 380000);
INSERT INTO departamento VALUES(6, 'Proyectos', 0, 0);
INSERT INTO departamento VALUES(7, 'Publicidad', 0, 1000);

CREATE TABLE empleado (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	nif VARCHAR(9) NOT NULL UNIQUE,
	nombre VARCHAR(100) NOT NULL,
	apellido1 VARCHAR(100) NOT NULL,
	apellido2 VARCHAR(100),
	id_departamento INT UNSIGNED,
	FOREIGN KEY (id_departamento) REFERENCES departamento(id)
);
INSERT INTO empleado VALUES(1, '32481596F', 'Aarón', 'Rivero', 'Gómez', 1);
INSERT INTO empleado VALUES(2, 'Y5575632D', 'Adela', 'Salas', 'Díaz', 2);
INSERT INTO empleado VALUES(3, 'R6970642B', 'Adolfo', 'Rubio', 'Flores', 3);
INSERT INTO empleado VALUES(4, '77705545E', 'Adrián', 'Suárez', NULL, 4);
INSERT INTO empleado VALUES(5, '17087203C', 'Marcos', 'Loyola', 'Méndez', 5);
INSERT INTO empleado VALUES(6, '38382980M', 'María', 'Santana', 'Moreno', 1);
INSERT INTO empleado VALUES(7, '80576669X', 'Pilar', 'Ruiz', NULL, 2);
INSERT INTO empleado VALUES(8, '71651431Z', 'Pepe', 'Ruiz', 'Santana', 3);
INSERT INTO empleado VALUES(9, '56399183D', 'Juan', 'Gómez', 'López', 2);
INSERT INTO empleado VALUES(10, '46384486H', 'Diego','Flores', 'Salas', 5);
INSERT INTO empleado VALUES(11, '67389283A', 'Marta','Herrera', 'Gil', 1);
INSERT INTO empleado VALUES(12, '41234836R', 'Irene','Salas', 'Flores', NULL);
INSERT INTO empleado VALUES(13, '82635162B', 'Juan Antonio','Sáez', 'Guerrero',
NULL);

--                 ## Consultas sobre tabla

-- Lista el primer apellido de todos los empleados.
select apellido1 as Primer_Apellido
from empleado;

-- primer apellido de los empleados eliminando los apellidos que estén repetidos.
select distinct apellido1 as Primer_Apellido
from empleado;

-- Lista todas las columnas de la tabla empleado.
select *
from empleado;

-- nombre y los apellidos de todos los empleados.
select nombre,apellido1 as Primer_Apellido, apellido2 as Segundo_Apellido
from empleado;

-- identificador de los departamentos de los empleados que aparecen en la tabla empleado.
select nombre,apellido1 as Primer_Apellido, id_departamento
from empleado;

-- identificador de los departamentos de los empleados que aparecen en la tabla 
-- empleado, eliminando los identificadores que aparecen repetidos.
select distinct nombre,apellido1 as Primer_Apellido, id_departamento
from empleado;

-- el nombre y apellidos de los empleados en una única columna.
delimiter //
create function Nombre_Apellidos(nombre varchar(100),apellido1 varchar(100), apellido2 varchar(100))
returns varchar(255) deterministic
begin
    if apellido2 is null then
        return CONCAT(nombre," ",apellido1);
    else
        return CONCAT(nombre," ",apellido1," ",apellido2);
    end if;
end//
delimiter ;
select Nombre_Apellidos(nombre,apellido1,apellido2) as Empleados
from empleado;

-- nombre y apellidos en una única columna, convirtiendo todos los caracteres en mayúscula.
delimiter //
create function Nombre_Apellidos_Mayuscula(nombre varchar(100),apellido1 varchar(100), apellido2 varchar(100))
returns varchar(255) deterministic
begin
    if apellido2 is null then
        return upper(CONCAT(nombre," ",apellido1));
    else
        return upper(CONCAT(nombre," ",apellido1," ",apellido2));
    end if;
end//
delimiter ;
select Nombre_Apellidos_Mayuscula(nombre,apellido1,apellido2) as Empleados
from empleado;

-- nombre y apellidos en una única columna, convirtiendo todos los caracteres en minúscula.
delimiter //
create function Nombre_Apellidos_Minuscula(nombre varchar(100),apellido1 varchar(100), apellido2 varchar(100))
returns varchar(255) deterministic
begin
    if apellido2 is null then
        return lower(CONCAT(nombre," ",apellido1));
    else
        return lower(CONCAT(nombre," ",apellido1," ",apellido2));
    end if;
end//
delimiter ;
select Nombre_Apellidos_Minuscula(nombre,apellido1,apellido2) as Empleados
from empleado;

-- identificador de los empleados junto al nif, pero el nif deberá aparecer en dos columnas,
-- una mostrará únicamente los dígitos del nif y la otra la letra.
delimiter //
create procedure separa_nif()
begin
     select id,
          left(nif,length(nif)-1) as Numeros
          right(nif,1) as Letras
     from empleado;
end //
delimiter ;
call separa_nif();


-- nombre de cada departamento y el presupuesto actual del que dispone. Para calcular
-- este dato tendrá que restar al valor del presupuesto inicial (columna presupuesto)
-- los gastos que se han generado(columna gastos). Tenga en cuenta que en algunos casos 
-- pueden existir valores negativos. Utilice un alias apropiado para la nueva columna que 
-- está calculando.
delimiter //
create function calcula_presupuesto(presupuesto DOUBLE,gastos DOUBLE)
returns DOUBLE deterministic
begin
	 return presupuesto - gastos;
end//
delimiter ;
select nombre, calcula_presupuesto(presupuesto,gastos) as Total
from departamento;

-- nombre de los departamentos y el valor del presupuesto actual ordenado de forma ascendente.
delimiter //
create function calcula_presupuesto(presupuesto DOUBLE,gastos DOUBLE)
returns DOUBLE deterministic
begin
	declare total double;
        return presupuesto - gastos;
end//
delimiter ;
select nombre, calcula_presupuesto(presupuesto,gastos) as Total
from departamento
order by Total asc;

-- nombre de todos los departamentos ordenados de forma ascendente.
select nombre
from departamento
order by Total asc;

-- nombre de todos los departamentos ordenados de forma descendente.
select nombre
from departamento
order by Total desc;




-- Desarrollado por Catalina Mulford / ID 1.097.490.150
