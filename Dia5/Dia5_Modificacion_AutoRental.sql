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
before update on alquiler
for each row
begin
    select v.*
    from vehiculo v
    left join alquiler a on v.id = a.idVehiculo
    where a.idVehiculo is null;
end ;
delimiter ;

grant select on AutoRental.vehiculo_libre to 'cliente'@'%';

-- Le permite al Cliente ver que carros hay en general
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

-- Carros que estan en alquiler
delimiter //
create event alquilando
on schedule every 1 day
do
begin
    select v.id, v.tipo, v.placa
    from vehiculo v
    join alquiler a on a.idVehiculo = v.id
    where a.fecha_llegada > curdate() or a.fecha_llegada is null ;
end //
delimiter ;
grant select on AutoRental.alquilando to 'empleado'@'%';

-- Cobro
delimiter //
create trigger cobro
before insert on alquiler
for each row
begin
    declare general int;
    declare semanas int;
    declare dia int;
    set general = DATEDIFF(NEW.esperada_llegada, NEW.fecha_salida);
    set semanas = floor(general/7);
    set dia = floor(general/7);
    set NEW.valor_cotizado = (semanas * NEW.valor_semana) + (dias * NEW.valor_dia);
end //
delimiter ; 
grant select on AutoRental.cobro to 'empleado'@'%';

-- Días extra
delimiter //
create trigger dia_extra
after update on alquiler
for each row
begin
    declare dias_demas int;
    declare extra int;

    if NEW.fecha_llegada > NEW.esperada_llegada then
         set dias_demas = DATEDIFF(NEW.fecha_llegada, NEW.esperada_llegada);
         set cargo_adicional = dias_adicionales * NEW.valor_dia * 1.08;
         set NEW.valor_pagado = NEW.valor_pagado + cargo_adicional;
       end if;
end //
delimiter ; 
grant select on AutoRental.dia_extra to 'empleado'@'%';

-- Alquiler de vehículos.
grant update, insert,delete on AutoRental.cliente_alquiler to 'empleado'@'%';

flush privileges;
show grants for 'cliente'@'%';
show grants for 'empleado'@'%';

select * from mysql.user where Host='%';

-- Desarrollado por Catalina Mulford / ID 1.097.490.150
