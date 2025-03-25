
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
CREATE VIEW Vista_Clientes_Compras AS
SELECT v.ID_venta, c.Nombre, c.Apellido1, c.Apellido2, v.Total 
FROM VENTA v 
INNER JOIN CLIENTE c ON v.ID_cliente = c.ID_cliente 
WHERE v.Total > 100;

-- Total de libros por género con más de 5 libros
CREATE VIEW Vista_Libros_Por_Genero AS
SELECT g.Genero, COUNT(*) AS Total_Libros 
FROM GUION_LIBRO gl 
INNER JOIN GENERO g ON gl.GENERO_ID_genero = g.ID_genero 
GROUP BY g.Genero 
HAVING COUNT(*) > 5;

-- FUNCIONES
-- Obtener el total gastado por un cliente
delimiter //
create function TotalGastadoPorCliente(cliente_ID int) returns decimal(10,2) deterministic
begin
		declare total decimal(10,2);
		select sum(Total)
end







































