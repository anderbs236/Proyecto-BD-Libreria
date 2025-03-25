
-- CONSULTAS 

-- Una consulta de una tabla con where
SELECT *
FROM CLIENTE c 
WHERE c.Nombre = 'Lana';

-- Una consulta de mas de una tabla
SELECT v.ID_venta , c.Nombre , c.Apellido1 , c.Apellido2 , v.Total 
from VENTA v inner join CLIENTE c 
on v.ID_cliente = c.ID_cliente 
where v.Total > 100;


-- Una consulta con agrupación
SELECT g.Genero , COUNT(*) as Total_Libros 
FROM GUION_LIBRO gl inner join GENERO g 
on gl.GENERO_ID_genero = g.ID_genero 
group by g.Genero 
HAVING COUNT(*) > 5; 

-- Una consulta con subconsultas
SELECT c.Nombre , CONCAT_WS(' ', c.Apellido1,c.Apellido2) as Apellidos 
FROM CLIENTE c 
where c.ID_cliente IN (
					SELECT ID_cliente 
					FROM VENTA v
					WHERE v.Total > (
							SELECT AVG(v.Total) 
							FROM VENTA v));

-- Una consulta que combine las anteriores
SELECT c.Nombre , CONCAT_WS(' ', c.Apellido1, c.Apellido2) as Apellidos, SUM(v.Total) as Total_compras 
FROM CLIENTE c inner join VENTA v 
on c.ID_cliente = v.ID_cliente 
where v.Fecha_venta >= '2024-01-01'
GROUP BY c.Nombre , Apellidos
HAVING SUM(v.Total) >200; 



-- VISTAS
-- Clientes que han realizado compras mayores a 100
create view vista_clientes_compras as
select v.id_venta, c.nombre, c.apellido1, c.apellido2, v.total 
from VENTA v 
inner join CLIENTE c on v.id_cliente = c.id_cliente 
where v.total > 100;

-- Total de libros por género con más de 5 libros
create view vista_libros_por_genero as
select g.genero, count(*) as total_libros 
from GUION_LIBRO gl 
inner join GENERO g on gl.GENERO_ID_genero = g.ID_genero 
group by g.genero 
having count(*) > 5;


-- FUNCIONES
-- Obtener el total gastado por un cliente
delimiter $$
create function totalgastadoporcliente(cliente_id int) returns decimal(10,2) deterministic
begin
    declare total decimal(10,2);
    select sum(v.total) into total from VENTA v where v.id_cliente = cliente_id;
    return ifnull(total, 0);
end $$
delimiter ;

-- Obtener la cantidad de ventas realizadas en un mes específico
delimiter $$
create function ventasenmes(año int, mes int) returns int deterministic
begin
	declare total int;
	select count(*) into total from VENTA v where year(v.fecha_venta) = año and month(v.fecha_venta) = mes;
	return total;
end $$
delimiter ;


-- PROCEDIMIENTOS
-- Insertar un nuevo cliente
delimiter $$
create procedure insertarcliente(in nombre varchar(50), in apellido1 varchar(50), in apellido2 varchar(50), in email varchar(100), in telefono varchar(20))
begin
	insert into cliente (nombre, apellido1, apellido2, email, telefono)
	values (nombre, apellido1, apellido2, email, telefono);
end $$
delimiter ;

-- Consultar total gastado por un cliente
delimiter $$ 
create procedure consultartotalgastado(in cliente_id int, out total decimal(10,2))
begin
	set total = totalgastadoporcliente(cliente_id);
end $$
delimiter ;

-- Actualizar el email de un cliente dado su id
delimiter $$
create procedure actualizaremailcliente(in cliente_id int, in nuevo_email varchar(100))
begin
    update CLIENTE set email = nuevo_email where id_cliente = cliente_id;
end $$
delimiter ;


-- TRIGGERS
-- Evitar ventas con total negativo
create table

delimiter $$
create trigger verificartotalventa before insert on VENTA
for each row
begin
    if new.total < 0 then
        signal sqlstate '45000' set message_text = 'el total de la venta no puede ser negativo';
    end if;
end $$
delimiter ;

-- PRUEBA
insert into VENTA (ID_venta, Fecha_venta, Total, ID_cliente) values (1, '2024-03-05', -50, 1);


-- Registrar historial de cambios en stock de libros
create table HISTORIAL_STOCK (
	id_historico INT auto_increment primary key,
	isbn varchar(20),
	stock_anterior int,
	stock_nuevo int,
	fecha_cambio datetime                         
);

delimiter $$
create trigger historialstock after update on LIBRO_EN_VENTA
for each row
begin 
	insert into HISTORIAL_STOCK (isbn, stock_anterior, stock_nuevo, fecha_cambio)
	values (old.isbn, old.stock, new.stock, now());
end $$
delimiter ;

-- PRUEBA
update LIBRO_EN_VENTA set stock = stock - 1 where isbn = '021464491-X';
select * from HISTORIAL_STOCK;


