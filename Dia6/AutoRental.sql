-- ##############################
-- ###### DIA 5 - MySQL 2  ######
-- ## AutoRental  Modificación ##
-- ##############################

create database AutoRental;
use AutoRental;

-- Gerente
create user 'gerente'@'%' identified by 'gerenteClave';
grant update, insert,delete on *.* to 'gerente'@'%';
show grants for 'gerente'@'%';


-- Clientes:
create user 'cliente'@'%' identified by 'clienteclave';
drop user  'cliente'@'%' ;
flush privileges;
grant select on vehiculos to 'cliente'@'%';


-- Consulta de disponibilidad de vehículos 
delimiter //
create trigger vehiculo_libre 
before update on alquiler
for each row
begin
    select v.*
    from vehiculo v
    left join alquiler a on v.id = a.idVehiculo
    where a.idVehiculo is null;
end ;
delimiter ;
update alquiler set valor_pagado = null where id = 2;
select * from alquiler;

-- Le permite al Cliente ver que carros hay en general
delimiter //
create view cliente_alquiler as
	select *
	from vehiculo;
delimiter ;

# -- para alquiler por tipo de vehículo, rango de precios de alquiler.
delimiter //
create procedure buscador_tipo (in clave varchar)
begin
    select * 
    from vehiculo
    where tipo like concat('%',clave,'%')
end ;
delimiter ;
call buscador_tipo(SUV);
grant select on AutoRental.buscador_tipo to 'cliente'@'%';
select * from vehiculo;
# -- para alquiler por rango de precios de alquiler.
delimiter //
create procedure buscador_num (in primer int,in segun int)
begin
    select * 
    from alquiler
    where valor_dia between primer and segun
    or valor_semana between primer and segun;
end //
delimiter ;
call buscador_num(300,500);
grant select on AutoRental.buscador_tipo to 'cliente'@'%'; 


-- Historial alquiler, el id del cliente es 1 por defecto
create table if not exists historial(
	id_histo int not null primary key auto_increment,
    idAlquiler int,
    idCliente int
);
delimiter //
create view elHistorial as
    select h.*
	from historial h
    join alquiler on h.id_histo = alquiler.id
    join cliente on alquiler.idCliente = cliente.id
	where idCliente = 2;
    insert into historial(id_histo,idAlquiler,idCliente)values (h.id,alquiler.id,cliente.id);
end //
delimiter ;
insert into vehiculo (id, tipo, referencia, modelo, placa, capacidad, sunroof, puertas, color, motor) 
values(101, 'Deportivo', 456, 2023, 654321, 4, 'Si', 4, 'Verde', 'Gasolina');
select * from vehiculo;
select * from historial;

grant select on AutoRental.cliente_alquiler to 'cliente'@'%';


-- Empleados:
create user 'empleado'@'%' identified by 'EmpleadoClave';
drop user  'empleado'@'%' ;
flush privileges;

-- Historial de todo en alquiler
delimiter //
create trigger ver
before insert on alquiler
for each row 
begin
    select *
    from vehiculos;
end //
delimiter ;
insert into alquiler (id, idSucursal_salida, idSucursal_llegada, idEmpleado, idVehiculo, idCliente, valor_semana, valor_dia, fecha_salida, esperada_llegada, fecha_llegada, valor_cotizado, descuento, valor_pagado)
values
(101, 5, 2, 9, 3, 7, 105000, 24000, '2024-05-02', '2024-05-06', '2024-06-27', 822000, 20, null);
select * from alquiler;

Muestra de sucursales, vehículos y empleados
delimiter //
grant select on AutoRental.sucursales to 'empleado'@'%';
grant select * on AutoRental.vehiculo to 'empleado'@'%';
grant select * on AutoRental.empleado to 'empleado'@'%';
delimiter ;

# -- Muestra de sucursales
delimiter //
create procedure ver_sucursales as
	select *
	from sucursal;
end ;
delimiter ;
call ver_sucursales;
# -- Muestra de vehículos
delimiter //
create view ver_vehiculo as
	select *
	from vehiculo;
    end ;
delimiter ;
call ver_vehiculo;
# -- Muestra de empleados
delimiter //
create view ver_empleado as
	select *
	from empleado;
    end ;
delimiter ;
call ver_empleado;


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
-- grant select on AutoRental.alquilando to 'empleado'@'%';

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
