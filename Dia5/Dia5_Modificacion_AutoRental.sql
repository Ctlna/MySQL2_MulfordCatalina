-- ##############################
-- ###### DIA 5 - MySQL 2  ######
-- ## AutoRental  Modificación ##
-- ##############################

create database AutoRental;
use AutoRental;

-- Clientes:
create user 'cliente'@'%' identified by 'ClienteClave';

-- Consulta de disponibilidad de vehículos 
delimiter //
create procedure vehiculo_libre 
begin
    select v.*
    from vehiculo v
    left join alquiler a on v.id = a.idVehiculo
    where a.idVehiculo is null;
end ;
delimiter ;

grant select on AutoRental.vehiculo_libre to 'cliente'@'%';
/*
delimiter //
create trigger vehiculo_libre as
    select v.*
    from vehiculo v
    left join alquiler a on v.id = a.idVehiculo
    where a.idVehiculo is null;
delimiter ;
*/


grant select on vehiculo to 'cliente'@'%';

-- para alquiler por tipo de vehículo, rango de precios de alquiler.
delimiter //
create procedure buscador_tipo (in clave varchar)
begin
    select * 
    from vehiculo
    where tipo like concat('%',clave,'%')
end ;
delimiter ;
grant select on AutoRental.buscador_tipo to 'cliente'@'%';

delimiter //
create procedure buscador_num (in primer int,in segun int)
begin
    select * 
    from alquiler
    where valor_dia between primer and segun
    or valor_semana between primer and segun;
end //
delimiter ;
grant select on AutoRental.buscador_tipo to 'cliente'@'%'; 


-- Historial alquiler, el id del cliente es 1 por defecto
delimiter //
create view cliente_alquiler as
	select *
	from alquiler
	when idCliente = 1;
delimiter ;
grant select on AutoRental.cliente_alquiler to 'cliente'@'%';

-- Alquiler de vehículos.
grant insert on AutoRental.cliente_alquiler to 'cliente'@'%';


-- Empleados:
create user 'empleado'@'%' identified by 'EmpleadoClave';

-- Muestra de sucursales, vehículos y empleados
delimiter //
grant select * on AutoRental.sucursal to 'empleado'@'%';
grant select * on AutoRental.vehiculo to 'empleado'@'%';
grant select * on AutoRental.empleado to 'empleado'@'%';
delimiter ;

-- Alquiler de vehículos.
grant update, insert,delete on AutoRental.cliente_alquiler to 'empleado'@'%';

flush privileges;
show grants for 'cliente'@'%';
show grants for 'empleado'@'%';

select * from mysql.user where Host='%';

-- Desarrollado por Catalina Mulford / ID 1.097.490.150
