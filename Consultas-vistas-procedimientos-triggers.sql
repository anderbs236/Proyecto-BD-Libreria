
-- CONSULTAS 
-- Esta consulta nos muestra los libros que se han agotado
select l.ISBN, l.Titulo , l.Stock
from LIBRO_EN_VENTA l inner join DETALLE_VENTA dv
on l.ISBN = dv.ISBN
group by l.ISBN, l.Titulo, l.Stock
having l.Stock = 0;

-- Esta consulta nos muestra los libros que mas se han vendido
select dv.ISBN, lev.Titulo, sum(dv.cantidad) as total_vendido
from DETALLE_VENTA dv inner join LIBRO_EN_VENTA lev
on dv.ISBN = lev.ISBN
group by dv.ISBN, lev.Titulo
order by total_vendido desc
limit 5;

--  Esta consulta nos muestra las fechas con mas ventas
select v.Fecha_venta, count(*) as cantidad_ventas, sum(v.Precio_total) as ingreso_total
from VENTA v
group by v.Fecha_venta
order by ingreso_total desc;

-- Esta consulta muestra los autores cuyos libros han generado más ingreso por ventas
select a.ID_autor, CONCAT_WS(' ', a.Nombre, a.Apellido1, a.Apellido2) as autor,
sum(dv.cantidad * dv.Precio_unitario) as ingresos_totales
from AUTOR a inner join LIBRO_EN_VENTA l
on a.ID_autor = l.id_autor
inner join DETALLE_VENTA dv
on l.ISBN = dv.ISBN
group by a.ID_autor, autor
order by ingresos_totales desc;

-- Esta consulta nos muestra los clientes que mas han comprado
select c.ID_cliente, CONCAT_WS(' ', c.Nombre, c.Apellido1, c.Apellido2 ) as cliente,
sum(dv.cantidad) AS Libros_comprados
from CLIENTE c inner join VENTA v
on c.ID_cliente = v.ID_cliente
inner join DETALLE_VENTA dv
on v.ID_venta = dv.id_venta
group by c.ID_cliente, Cliente
order by Libros_comprados desc;

-- VISTAS
-- Esta vista nos muestra los libros que mas se han vendido
create view libros_mas_vendidos as
select dv.ISBN, lev.Titulo, sum(dv.cantidad) as total_vendido
from DETALLE_VENTA dv inner join LIBRO_EN_VENTA lev
on dv.ISBN = lev.ISBN
group by dv.ISBN, lev.Titulo
order by total_vendido desc;

-- Ejecutar
select * from libros_mas_vendidos limit 5;


-- Esta vista muestra los autores cuyos libros han generado más ingreso por ventas
create view autores_top_ingresos as
select a.ID_autor, CONCAT_WS(' ', a.Nombre, a.Apellido1, a.Apellido2) AS autor,
sum(dv.cantidad * dv.Precio_unitario) AS ingresos_totales
from AUTOR a inner join LIBRO_EN_VENTA l
on a.ID_autor = l.id_autor
inner join DETALLE_VENTA dv
on l.ISBN = dv.ISBN
group by a.ID_autor, autor
order by ingresos_totales desc;

-- Ejecutar
select * from autores_top_ingresos;

-- Funciones
-- Esta función calcula el stock de un libro 
delimiter //
create function stock_libro(isbn_input varchar(20))
returns int
deterministic
begin
	declare stock_actual int;
	select l.Stock into stock_actual
	from LIBRO_EN_VENTA l
	where l.ISBN = isbn_input;
	
	return ifnull(stock_actual, 0);
end //
delimiter ;

-- Ejecutar
select stock_libro('000403210-1');


-- Esta funcion es para obtener el nombre completo de un cliente
delimiter //
create function nombre_completoCL(cliente_id int)
returns varchar(255)
deterministic
begin
	declare nombre_completo varchar(255);
	select CONCAT_WS(' ', c.Nombre, c.Apellido1, c.Apellido2) into nombre_completo
	from CLIENTE c
	where c.ID_cliente = cliente_id;
	
	return nombre_completo;
end //
delimiter ;

-- Ejecutar
select nombre_completoCL(2);


-- Procedimientos
-- Este procedimiento sirve para añadir un nuevo libro
delimiter //
create procedure agregar_libro (
	in p_isbn varchar(20),
	in p_titulo varchar(255),
	in p_id_autor int,
	in p_editorial varchar(100),
	in p_stock int,
	in p_fecha date,
	in p_precio decimal(10,2)
)
begin
	insert into LIBRO_EN_VENTA (ISBN, Titulo, id_autor, Editorial, Stock, Fecha_publicacion, Precio_recomendado)
	values (p_isbn, p_titulo, p_id_autor, p_editorial, p_stock, p_fecha, p_precio);
end //
delimiter ;

-- Ejecutar
-- Primero añadir el libro en guion_libro
call agregar_libro('9788427053083', 'Un verano en el campamento', 2, 'Siruela', 50, '2024-08-04', 20.00);


select *
from LIBRO_EN_VENTA l
where l.Titulo = 'Un verano en el campamento';


-- Este procedimiento es para actualizar el stock de un libro
delimiter //
create procedure actualizar_stock (
	in p_isbn varchar(20),
	in p_nuevo_stock int
)
begin
	update LIBRO_EN_VENTA l
	set Stock = p_nuevo_stock
	where l.ISBN = p_isbn;
end //
delimiter ;

-- Ejecutar
call actualizar_stock('000080142-9', 70);

select *
from LIBRO_EN_VENTA l
where l.ISBN = '000080142-9';


-- Este procedimiento es para mostrar todos los detalles de una venta por id
delimiter //
create procedure detalle_venta (in p_id_venta INT)
begin
	select dv.id_venta , dv.ISBN , lev.Titulo , concat_ws(' ', a.Nombre,
	a.Apellido1, a.Apellido2) as autor, dv.cantidad , dv.Precio_unitario ,
	v.Precio_total as subtotal
	from DETALLE_VENTA dv inner join LIBRO_EN_VENTA lev
	on dv.ISBN = lev.ISBN
	inner join AUTOR a
	on lev.id_autor = a.ID_autor
	inner join VENTA v
	on dv.id_venta = v.ID_venta
	where dv.id_venta = p_id_venta;
end //
delimiter ;

-- Ejecutar
call detalle_venta(100);


-- TRIGGERS
-- Trigger para actualizar el subtotal en DETALLE_VENTA
delimiter //
create trigger actualizar_precioTotal_insert
after insert on DETALLE_VENTA	
for each row
begin
	declare total decimal(10,2);
	select sum(cantidad * precio_unitario) into total
	from DETALLE_VENTA
	where id_venta = new.id_venta;
	update VENTA
	set Precio_total = total
	where ID_venta = new.id_venta;
end //
delimiter ;

-- Ejecutar
insert into DETALLE_VENTA (id_venta, ISBN, cantidad, Precio_unitario)
values (1, '000080142-9', 1, 30.00);


-- Para cuando se actualice
delimiter //
create trigger actualizar_precioTotal_update
after update on DETALLE_VENTA
for each row
begin
	declare total decimal(10,2);
	select sum(cantidad * precio_unitario) into total
	from DETALLE_VENTA
	where id_venta = new.id_venta;
	update VENTA
	set Precio_total = total
	where ID_venta = new.id_venta;
end //
delimiter ;

-- Ejecutar
update DETALLE_VENTA set cantidad = 2
where id_venta = 1 and ISBN = '014223511-3';

-- Evitar que se venda mas stock del disponible
delimiter //
delimiter //
create trigger verificar_stock
before insert on DETALLE_VENTA
for each row
begin
	declare stock_disponible int;
	select Stock into stock_disponible
	from LIBRO_EN_VENTA
	where ISBN = new.ISBN;
	
	if stock_disponible is null then
		signal sqlstate '45000'
		set message_text = 'ISBN no encontrado en el inventario';
	elseif new.cantidad > stock_disponible then
		signal sqlstate '45000'
		set message_text = 'No hay suficiente stock para completar la venta';
	end if;
end //
delimiter ;

-- Ejecutar
-- Opción 1
insert into DETALLE_VENTA (id_venta,ISBN, cantidad, Precio_unitario)
values (502, '050013048-0', 100, 20.00);
-- Opción 2
insert into DETALLE_VENTA (id_venta,ISBN,cantidad, Precio_unitario)
values (502, '050913048-8', 100, 20.00);

-- actualizar el stock automaticamente al vender
delimiter //
create trigger actualizar_stock
after insert on DETALLE_VENTA
for each row
begin
	update LIBRO_EN_VENTA
	set Stock = Stock - new.cantidad
	where ISBN = new.ISBN;
end //
delimiter ;

-- Ejecutar
insert into DETALLE_VENTA (id_venta,ISBN,cantidad, Precio_unitario)
values (500, '000403210-1',3, 20.00);
