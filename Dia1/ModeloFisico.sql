-- #########################
-- # Dia 1 # Normalizacion #
-- #########################

create database dia1;
use dia1;

create table medico(
     id int primary key not null,
     nombre varchar(100) not null,
     direccion varchar(15) not null,
     telefono int(10) not null,
     poblacion varchar(15) not null,
     provincia varchar(15) not null,
     codigo_postal varchar(15) not null,
     nif int not null,
     seguridad_social int not null,
     colegiado int not null,
     tipo enum('médico titular','médico interino','médico sustituto')
);
INSERT INTO medico VALUES (1,'Juliana Mendoza','Cra.13 Calle 20',246809751,'vulnerable','Metropolitana','12ls',7587,98765,34,'médico interino');
INSERT INTO medico VALUES (2,'Einstein','Calle 10',943167852,'viva','Metropolitana','13g',932,123,45,'médico titular');
INSERT INTO medico VALUES (3,'Guillermo Gomez','Pan azucar',546897213,'s','Metropolitana','46h');
INSERT INTO medico VALUES ();
INSERT INTO medico VALUES ();
INSERT INTO medico VALUES ();
INSERT INTO medico VALUES ();
INSERT INTO medico VALUES ();

create table sustituciones(
     id_medico int,
     fecha_alta date,
     fecha_baja date,
     foreign key(id_medico) references medico(id)
);


create table empleado(
     id int primary key not null,
     nombre varchar(100) not null,
     direccion varchar(15) not null,
     telefono int(10) not null,
     poblacion varchar(15) not null,
     provincia varchar(15) not null,
     codigo_postal varchar(15) not null,
     nif int not null,
     seguridad_social int not null,
     tipo enum('ATS','ATS de zona','auxiliar de enfermería','celador','administrativo')
);
-- INSERT INTO medico VALUES

create table paciente(
     id int primary key not null,
     nombre varchar(100) not null,
     direccion varchar(15) not null,
     telefono int(10) not null,
     codigo_postal varchar(15) not null,
     nif int not null,
     seguridad_social int not null,
     id_medico int not null,
     foreign key(id_medico) references medico(id)
);
create table consultas(
     id int primary key not null,
     id_medico int not null,
     dia date not null,
     hora_inicio time not null,
     hora_fin time not null,
     foreign key(id_medico) references medico(id)
);
create table vacaciones(
     id int primary key not null,
     id_empleado int,
     fecha_inicio date not null,
     fecha_fin date not null,
     foreign key(id_empleado) references medico(id),
     foreign key(id_empleado) references empleado(id)
);

--     ##### Consultas

-- 1. Número de pacientes atendidos por cada médico
select m.nombre as Medico, count(p.id) as Num_Pacientes
from medico m
left join paciente p on p.id_medico = m.id
group by (m.id);

--  2. Total de días de vacaciones planificadas y disfrutadas por cada empleado
select e.nombre, sum(datediff(v.fecha_inicio, v.fecha_fin)) as Vacaciones
from vacaciones v
inner join empleado e on e.id = v.id_empleado
inner join medico m on m.id = v.id_empleado
group by v.id_empleado;

-- 3. Médicos con mayor cantidad de horas de consulta en la semana
-- select m.nombre, sum(TIMESTAMPDIFF(hour,c.hora_inicio,c.hora_fin)) as Horas
-- from consultas c


-- 4. Número de sustituciones realizadas por cada médico sustituto


-- 5. Número de médicos que están actualmente en sustitución


-- 6. Horas totales de consulta por médico por día de la semana


-- 7. Médico con mayor cantidad de pacientes asignados


-- 8. Empleados con más de 10 días de vacaciones disfrutadas


-- 9. Médicos que actualmente están realizando una sustitución


-- 10. Promedio de horas de consulta por médico por día de la semana



-- Desarrollado por Catalina Mulford / ID 1.097.490.150
