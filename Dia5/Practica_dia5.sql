#####################
# Dia 5 - MySQL 2 ##
#####################
create database mysql2_dia5;
use mysql2_dia5;
select * from country;
select * from city;

-- Trigger para insertar o actualizar una ciudad
delimiter //
create trigger after_city_insert_update
after insert on city
for each row 
begin
	update country
    set Population = Population + NEW.Population
    where Code = NEW.CountryCode;
end //
delimiter ;
-- Test
insert into city (Name,CountryCode,District,Population)
values ("Artemis","AFG","Piso 6",1250000);

-- Trigger para cuando se elimina una ciudad, pq se va la información
delimiter //
create trigger after_city_delete_update
after delete on city
for each row 
begin
	update country
    set Population = Population + OLD.Population -- Ese old, y el new de antes es cuando se acciona
    where Code = OLD.CountryCode;
end //
delimiter ;
-- Test
select * from country;
select * from city where Name = "Artemis";
delete from city where ID = 4080;

-- Crear una tabla para auditoria de ciudad
create table if not exists city_audit(
	audit_id int auto_increment primary key,
    city_id int,
    action varchar(10),
    old_population int,
    new_population int,
    change_time timestamp default current_timestamp
);

-- Trigger para auditoria de ciudades cuando se inserta
delimiter //
create trigger  after_city_insert_audit
after insert on city
for each row 
begin
	insert into city_audit(city_id,action,new_population)
    values (NEW.ID,'INSERT',NEW.Population);
end //
delimiter ;
-- TEST
select * from city_audit;
insert into city (Name,CountryCode,District,Population) 
values ("Artemis","AFG","Piso 6",1250000);

-- Trigger para auditoria de ciudades cuando se actualiza
delimiter //
create trigger after_city_update_audit
after update on city
for each row
begin
    insert into city_audit(city_id,action,old_population,new_population)
    values (OLD.ID,'UPDATE',OLD.Population,NEW.Population);
end //
delimiter ;
-- Test
update city set Population = 1550000 where ID=4081;
select * from city_audit;

drop trigger after_city_update_audit;

-- EVENTOS
-- Creación de tabla para BK de ciudades
create table if not exists city_backup(
	ID int not null,
    Name char(35) not null,
    CountryCode char(3) not null,
    District char(20) not null,
    Population int not null,
    primary key (ID)
) ENGINE = InnoDB DEFAULT CHARSET=utf8mb4;

delimiter //
create event if not exists weekly_city_backup
on schedule every 1 week
do
begin
	truncate table city_backup;
    insert into city_backup(ID,Name,CountryCode,District,Population)
    select ID,Name,CountryCode,District,Population from city;
end ;
delimiter ;


/*
#### DEFINICIONES
* timestamp: Coje todo incluso Dia-Hora mientras  el datatime coje solo mes-dia-año
* tigger: funcionalidad que se ocurre automáticamente cuando se 
realiza una operación de tipo Insert, Update o Delete

-- Desarrollado por Catalina Mulford / ID 1.097.490.150   */
