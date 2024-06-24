-- ################################
-- ####    DIA 4 - EJERCICIO 1  ###
-- ################################

show databases;
create database mysql2_dia4;
use mysql2_dia4;

-- Creación de usuarios con acceso desde cualquier parte
create user 'camper'@'%' identified by 'campus2023';

-- VER PERMISOS DE USUARIO ESPECIFICO
show grants for 'camper'@'%';
-- Permite acceder pero no tiene permiso completo!!!

-- Crear una tabla de personas
create table persona (id int primary key, nombre varchar(225),apellido varchar(225));
insert into persona(id,nombre,apellido)values(1,'Juan','Perez');
insert into persona(id,nombre,apellido)values(2,'Andres','Pastrana');
insert into persona (id,nombre,apellido) values (3,'Pedro','Gómez');
insert into persona (id,nombre,apellido) values (4,'Camilo','Gonzalez');
insert into persona (id,nombre,apellido) values (5,'Stiven','Maldonado');
insert into persona (id,nombre,apellido) values (6,'Ardila','Perez');
insert into persona (id,nombre,apellido) values (7,'Ruben','Gómez');
insert into persona (id,nombre,apellido) values (8,'Andres','Portilla');
insert into persona (id,nombre,apellido) values (9,'Miguel','Carvajal');
insert into persona (id,nombre,apellido) values (10,'Andrea','Gómez');

-- Asignar permisos a usuario para que acceda a la tabla y BBDD
grant select on mysql2_dia4.persona to 'camper'@'%';

-- Refrescar BBDD
flush privileges;

-- Permite CRUD
grant update, insert, delete on mysql2_dia4.persona to 'camper'@'%';

-- Crear otra tabla
create table persona2 (id int primary key, nombre varchar(225),apellido varchar(225));
insert into persona(id,nombre,apellido)values(1,'Juan','Perez');
insert into persona(id,nombre,apellido)values(2,'Andres','Pastrana');
insert into persona (id,nombre,apellido) values (3,'Pedro','Gómez');
insert into persona (id,nombre,apellido) values (4,'Camilo','Gonzalez');
insert into persona (id,nombre,apellido) values (5,'Stiven','Maldonado');
insert into persona (id,nombre,apellido) values (6,'Ardila','Perez');
insert into persona (id,nombre,apellido) values (7,'Ruben','Gómez');
insert into persona (id,nombre,apellido) values (8,'Andres','Portilla');
insert into persona (id,nombre,apellido) values (9,'Miguel','Carvajal');
insert into persona (id,nombre,apellido) values (10,'Andrea','Gómez');

-- Crea un usuario a permiso para TODO desde cualquier lado con contraseña
-- PELIGROSO ---> NO USAR
create user 'todito'@'%' identified by 'todito';
grant all on *.* to 'todito'@'%' ;
show grants for 'todito'@'%';

-- Quitar todos los permisos -- Muestra error pero aún así sirve
revoke all on *.* from 'todito'@'%' ;

-- Crear un acceso unico de ip establecida
create user 'deivid'@'ip' identified by 'clave';
grant select, update, insert, delete on mysql2_dia4.persona to 'usuario'@'%';

-- Crear un acceso unico SIN NECESIDAD de ip establecida
create user 'deivid'@'%' identified by 'clave';
grant select on mysql2_dia4.* to 'usuario'@'%';

-- Crear un limite para hacer solo X consultas por hora
alter user 'camper'@'%' with max_queries_per_hour 5;
flush privileges;

-- Revisar límites o permisos de usuario a nivel motor
select * from mysql.user where host = '%';

-- Eliminar usuario
drop user 'deivid'@'%';
drop user 'deivid'@'ip' ;
drop user 'todito'@'%';

-- Revocar permisos de camper
revoke all on * from 'camper'@'%';

-- Permisos para consultar una base de datos especifica
grant select (nombre) on mysql2_dia4.persona to 'camper'@'%';

-- Desarrollado por Catalina Mulford / ID 1.097.490.150
