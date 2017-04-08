USE pubs
GO

SELECT au_id, au_lname, au_fname, phone, address, city, state, zip, contract
FROM [dbo].[authors] A
--FROM [dbo].[authors] AS A -- A is an ALIAS

SELECT A.au_fname AS Name, B.au_lname LastName, MyLastName = B.au_lname
FROM authors A WITH (NOLOCK), authors B WITH (NOLOCK)  -- read uncommited

SELECT * FROM 
authors --WITH (NOLOCK)
WHERE au_id = '341-22-1782'

USE Northwind
GO
SELECT * FROM Categories

USE pubs
GO
SELECT TOP 10 * 
FROM authors, Northwind..Categories -- a otra BD

SELECT TOP 3 * 
FROM  Northwind..Categories -- a otra BD

SELECT DISTINCT UPPER(city) AS MyCity FROM authors 
--ORDER BY city DESC
ORDER BY mycity DESC
--ORDER BY 1 DESC

SELECT * 
FROM  Northwind..Products -- a otra BD
WHERE CategoryID = 2

IF EXISTS(SELECT 0 FROM  Northwind..Products WHERE CategoryID = 2) --Si:2, No:99
BEGIN --bloque de codigo
PRINT 'Si'
PRINT 'xxxx'
END
ELSE
PRINT 'NO'

SELECT *
FROM Northwind..Products
WHERE
-- ProductName LIKE '[A-J]%'
-- ProductName LIKE 'AJ%'
-- ProductName LIKE 'C_e%'
--CategoryID IN (6,8)
CategoryID IN (SELECT CategoryID FROM Northwind..Categories WHERE CategoryName LIKE 'C%')

SELECT ISNULL(state,'XX'),* FROM publishers 
WHERE 
	State IS NULL
--state IS NOT NULL

SELECT NULL + 10
SELECT ISNULL(NULL,0) + 10

SELECT 
	CASE state
	WHEN 'MA' THEN 'Massachussets'
	WHEN 'CA' THEN 'California'
	ELSE 'Others'
	END AS X,
	CASE
	WHEN country	= 'USA'		THEN 'US'
	WHEN state		= 'MA'		THEN 'Massachussets'
	WHEN country	= 'Germany'	THEN 'G'
	ELSE 'XX'
	END AS B,
*
FROM publishers 

DECLARE @col1 INT = NULL, @col2 INT = NULL, @col3 INT = NULL
SELECT ISNULL(@col1,0), COALESCE(@col1,@col2,@col3)
SELECT NULLIF(3,2),NULLIF(2,2)

/* shorcuts
ALT + SHift -- Columm Mode edit
Ctrl + F -- Find
Ctrl + H -- Find & Replace
*/

DECLARE @order INT = 1
SELECT * FROM publishers
ORDER BY
	CASE @order
	WHEN 1 THEN pub_name
	WHEN 2 THEN city
	ELSE pub_id
	END

SELECT CAST(1 AS VARCHAR(10)), CONVERT(VARCHAR(10), 1)
SELECT SIGN(-10), SIGN(0), SIGN(10)
SELECT CHARINDEX('mu','Hola Mundo')
SELECT PATINDEX('%[LM]%', 'Hola Mundo')
SELECT '-' + SUBSTRING('Hola Mundo',6,10) + '-'
SELECT STUFF('Hola Mundo',1,2,'')
SELECT STUFF('Hola Mundo',1,2,'xxxx')
SELECT REPLACE('Hola Mundo',' ','')
SELECT '-' + RTRIM('     Hola Mundo     ') + '-'
SELECT '-' + LTRIM('     Hola Mundo     ') + '-'
SELECT '-' + LTRIM(RTRIM('     Hola Mundo     ')) + '-'
SELECT ASCII('A'),ASCII('a')
SELECT CHAR(64),CHAR(97)
SELECT STR(1345)
SELECT LEN('Hola Mundo')

SELECT GETDATE()
SELECT DATEDIFF(year, '19720625', GETDATE())
--TAREA: calcular la edad
--TAREA: calcular el primer y ultimo dia del mes de la columna X 
--	(buscar una columna con fecha hora)
--	Ej: 2017-03-25 17:34:22 ---> 2017-03-01 12:00:00
SELECT DATEADD(day,10, GETDATE())

--DATEPART
SELECT	GETDATE() Fecha
	,DATEPART(year, GETDATE()) [Año]
	,YEAR(GETDATE()) [Año]
	,DATEPART(quarter, GETDATE()) Semestre
	,DATEPART(month, GETDATE()) Mes
	,MONTH(GETDATE()) Mes
	,DATEPART(day, GETDATE()) Dia
	,DAY(GETDATE()) Dia
	,DATEPART(dayofyear, GETDATE()) [DiadelAño]
	,DATEPART(week, GETDATE()) [Semana]
	,DATEPART(weekday, GETDATE()) [DiaDeLaSemana] -- Domingo:1, Sabado:7
	,DATEPART(hour, GETDATE()) [Hora]
	,DATEPART(minute, GETDATE()) [Minuto]
	,DATEPART(second, GETDATE()) [Segundo]
GO

SET DATEFIRST 1 -- Lunes
SELECT DATEPART(weekday,GETDATE()), DATEPART(week, GETDATE())
SET DATEFIRST 7 -- Domingo (US)
SELECT DATEPART(weekday,GETDATE()), DATEPART(week, GETDATE())
GO


SELECT DATENAME(month, GETDATE()), DATENAME(weekday, GETDATE()), DATENAME(day, GETDATE())

SELECT * FROM sys.syslanguages
SET LANGUAGE 'Korean'
SELECT DATENAME(MM, GETDATE()), DATENAME(weekday, GETDATE()), DATENAME(day, GETDATE())
SET LANGUAGE 'Spanish'
SELECT DATENAME(month, GETDATE()), DATENAME(weekday, GETDATE()), DATENAME(day, GETDATE())
GO




