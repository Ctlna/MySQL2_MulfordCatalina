-- ##############################
-- ###### DIA 2 - MySQL 2  ######
-- ##############################

-- Titulo: Consultas avanzadas
create database dia2;
use dia2;

create table productos(
	id int auto_increment,
    nombre varchar(100),
    precio decimal(10,2),
    primary key(id)
);
 insert into productos values
    (1,"Pepito",23.2),
    (2,"MousePad",100000.21),
    (3,"Espionap",2500.25),
    (4,"BOB-ESPONJA",1500.25),
    (5,"Cary",23540000.23),
    (6,"OvulAPP",198700.23),
    (7,"PapayAPP",2000.00),
    (8,"Menosprecio",3800.00),
    (9,"PerfumeMascotas",2300.00),
    (10,"Perfume La Cumbre", 35000.25),
    (11,"Nevera M800",3000.12),
    (12,"Crema Suave", 2845.00),
    (13,"juego de mesa La Cabellera",9800.00),
    (14,"Cargador iPhone",98000.00);
    
    
delimiter //
-- Crear función que retorne el nombre del producto con IVA(19%)
-- Si vale más de 1000 tendra descuento de 20%
create function TotalConIVA(precio decimal(10,2),iva decimal(5,3))
returns varchar(255) deterministic
begin
    if precio > 1000 then
        return CONCAT("Tu precio con el descuento es de: ",(precio+(precio*iva))-((precio+(precio*iva))*0.2));
    else
        return CONCAT("Tu precio completo es de: ",precio+(precio*iva));
    end if;
end//
delimiter ;
-- Usa la función total con IVA
select TotalConIVA(25000,0.19);

-- Eliminar función
drop function obtener_precio_producto_prom;

-- Extrapolar función con datos de la BBDD
select TotalConIVA(precio,0.19) 
from productos;

-- Obtener precio por medio del nombre del producto
delimiter //
create function obtener_precio_producto(nombre_producto varchar(100))
returns decimal (10,2)
deterministic
begin
	declare precio_producto decimal (10,2);
    select precio into precio_producto from productos
    where nombre = nombre_producto;
    return precio_producto;
end //
delimiter ;
-- Usar función
select obtener_precio_producto("PerfumeMascota");

-- Función para obtener el precio de un producto (con su iva y promoción) por el nombre
delimiter //
Create function obtener_precio_producto_prom(nombre_producto varchar(100),iva decimal(5,3))
returns decimal (10,2)
deterministic
begin
    declare precio_producto decimal(10,2);
    select precio into precio_producto from productos
    where nombre = nombre_producto;
    if precio_producto > 1000 then
        return precio_producto+(precio_producto*iva)-(precio_producto+(precio_producto*iva))*0.2;
    else
        return precio_producto+(precio_producto*iva);
    end if;
end//
delimiter ;
-- Usar
select obtener_precio_producto_prom('Pepito',0.19) as Precio;

-- Precio promedio productos
delimiter //
create function precio_promedio_productos()
returns decimal (10,2)
deterministic
begin
	declare promedio decimal (10,2);
    select avg(precio) into promedio from productos;
    return promedio;
end//
delimiter ;
-- Usar
select precio_promedio_productos();

-- Procedimiento insertar un nuevo producto
delimiter //
create procedure insertar_producto(in nombre_producto varchar(100),
in precio_producto decimal(10,2))
begin
	insert into productos (nombre,precio)
    values (nombre_producto,precio_producto);
end//
delimiter ;
-- Usa
call insertar_producto('Gorra',1000.53);
select * from productos;

-- Eliminar producto por nombre
delimiter //
create procedure eliminar_producto (in nombre_producto varchar(100))
begin
	delete from productos where nombre = nombre_producto;
end//
delimiter ;
 -- SIEMPRE WHERE O ELIMINA TODO
-- Usa
call eliminar_producto('Gorra');


-- Determinista = Siempre devolvera los mismos resultados si tiene los mismos valores
-- No determinista = Los resultados cambian pq hay un dato externo, incluso si tiene los mismos valores
-- Delimiter = Avisa al sistema que lo que este dentro seran funciones internas del sistema
-- Para eliminar se reconfigura workbench

-- Desarrollado por Catalina Mulford / ID 1.097.490.150
