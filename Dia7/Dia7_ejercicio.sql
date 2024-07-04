##################### 
# Dia 7 - MySQL 2 ##
#####################

use Dia3;

/*
los clientes de todos los empleados cuyo puesto sea responsable de ventas. Se requiere que 
la consulta muestre: Nombre del cliente, teléfono, la ciudad, nombre y primer apellido del
responsable de ventas y su email.
*/
create index idx_cliente on cliente(nombre_cliente,telefono,ciudad);
create index idx_empleado on empleado(nombre, apellido1, email);

select c.nombre_cliente,c.telefono,c.ciudad, e.nombre, e.apellido1, e.email
from cliente c
join empleado e on e.codigo_empleado = c.codigo_empleado_rep_ventas
where e.puesto = 'Representante Ventas';

/*
registros de los pedidos entre el 15 de marzo del 2009 y el 15 de julio del 2009, para 
todos los clientes que sean de la ciudad de Sotogrande. Se requiere mostrar el código del 
pedido, la fecha del pedido, fecha de entrega, estado, los comentarios y el condigo del 
cliente que realizo dicho pedido.
*/
create index idx_pedido on pedido(codigo_pedido,fecha_pedido,fecha_entrega,estado,comentarios,codigo_cliente);

select codigo_pedido,fecha_pedido,fecha_entrega,estado,comentarios,codigo_cliente
from pedido
where fecha_pedido between '2009-03-15' and '2009-07-15';

/*
productos cuya gama pertenezca a las frutas y que el proveedor sea Frutales Talavera S.A, 
se desea mostrar el código, nombre, descripción, cantidad en stock, y su precio con 10% de 
descuento, de igual forma se pide la cantidad en los distintos pedidos que se han hecho.
*/
create index idx_producto on producto (gama,codigo_producto, nombre, descripcion, cantidad_en_stock);
create index idx_detalle_pedido on ‎detalle_pedido(cantidad,codigo_producto);

select p.codigo_producto, p.nombre, p.descripcion, p.cantidad_en_stock, d.cantidad,
p.precio_venta * 0.10 as Descuento
from producto p
join ‎detalle_pedido‎ d on d.codigo_producto = p.codigo_producto
where p.gama = 'Frutales' and p.proveedor = 'Frutales Talavera S.A';

-- Desarrollado por Catalina Mulford / ID 1.097.490.150
