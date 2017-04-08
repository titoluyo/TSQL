--RESOLUCION: CALCULO DE LA FECHA

DECLARE @BirthDays AS TABLE (
Nombre VARCHAR(100),
FecNac SMALLDATETIME
)

INSERT INTO @BirthDays 	VALUES 
	('Pedro', '19930101'),
	('Pablo', '19931231')

SELECT *,
	DATEDIFF(YEAR,FecNac,GETDATE()),
	DATEADD(YEAR,DATEDIFF(YEAR,FecNac,GETDATE()),FecNac),
	DATEDIFF(DAY,DATEADD(YEAR,DATEDIFF(YEAR,FecNac,GETDATE()),FecNac),GETDATE()),
	SIGN(SIGN(DATEDIFF(DAY,DATEADD(YEAR,DATEDIFF(YEAR,FecNac,GETDATE()),FecNac),GETDATE()))+1),
	DATEDIFF(YEAR,FecNac,GETDATE())+SIGN(SIGN(DATEDIFF(DAY,DATEADD(YEAR,DATEDIFF(YEAR,FecNac,GETDATE()),FecNac),GETDATE()))+1)
FROM @BirthDays

SELECT *,
	DATEDIFF(YEAR,FecNac,GETDATE()),
	CONVERT(CHAR(8),FecNac,112),
	CAST(YEAR(GETDATE()) AS CHAR(4)) +  RIGHT(CONVERT(CHAR(8),FecNac,112),4),
	DATEDIFF(YEAR,FecNac,GETDATE()) + CASE WHEN CAST(YEAR(GETDATE()) AS CHAR(4)) +  RIGHT(CONVERT(CHAR(8),FecNac,112),4) < GETDATE() THEN 1 ELSE 0 END
FROM @BirthDays

-- TAREA: CALCULO DE FECHA 25 Años,12 meses, 30 dias
SELECT *,
	DATEDIFF(YEAR,FecNac,GETDATE()),
	DATEDIFF(MONTH,FecNac,GETDATE()),
	DATEDIFF(DAY,FecNac,GETDATE())

FROM @BirthDays

-- SESION III

-- ORDER
SELECT LEFT(phone,3) Prefix, address + '' + city AS Address, * FROM authors
--ORDER BY city -- Column name
--ORDER BY 6	-- Column index
--ORDER BY Prefix	-- Alias
--ORDER BY address	-- Error: Ambiguous columns

SELECT LEFT(phone,3) Prefix, address + '' + city AS Address FROM authors
ORDER BY state	-- orden por columna (no mostrada)

-- GROUP
SELECT state,COUNT(0)
FROM authors
GROUP BY state

SELECT DISTINCT ProductID, UnitPrice
FROM [Northwind].dbo.[Order Details]
ORDER BY ProductID

SELECT ProductID, COUNT(0) Qty, COUNT(DISTINCT(UnitPrice)) PriceDistinct
	,SUM(Quantity) TotalCantidad
	,SUM(UnitPrice * Quantity) TotalVendido
	,SUM(UnitPrice) * SUM(Quantity) VendidError -- error
	,SUM(UnitPrice - Discount) Neto1
	,SUM(UnitPrice) - SUM(Discount) Neto2
	,MAX(Quantity) MaxQty, MIN(Quantity) MinQty
FROM [Northwind].dbo.[Order Details]
GROUP BY ProductID
ORDER BY ProductID

SELECT TOP 1 ProductID, TotalCantidad
--SELECT A.ProductID,MAX(A.TotalCantidad)
FROM (
	SELECT ProductID, COUNT(0) Qty, COUNT(DISTINCT(UnitPrice)) PriceDistinct
		,SUM(Quantity) TotalCantidad
		,SUM(UnitPrice * Quantity) TotalVendido
		,SUM(UnitPrice) * SUM(Quantity) VendidError -- error
		,SUM(UnitPrice - Discount) Neto1
		,SUM(UnitPrice) - SUM(Discount) Neto2
		,MAX(Quantity) MaxQty, MIN(Quantity) MinQty
	FROM [Northwind].dbo.[Order Details]
	GROUP BY ProductID
	--ORDER BY ProductID
) A
--GROUP BY A.ProductID
--ORDER BY ProductID
ORDER BY TotalCantidad DESC

DECLARE @Planilla AS TABLE (ID INT, PagoMes1 DECIMAL(10,2),PagoMes2 DECIMAL(10,2))
INSERT INTO @Planilla VALUES
	(1, 100.12, 200.33),
	(2, 99.3, 34.44),
	(3, 23.35,NULL),
	(4, NULL, NULL)

SELECT * FROM @Planilla
SELECT COUNT(1) CantidadCliente
	,COUNT(PagoMes1) CantidadPagosMes1
	,COUNT(PagoMes2) CantidadPagosMes2
FROM @Planilla 

-- HAVING
SELECT ProductID, SUM((UnitPrice - Discount)*Quantity), MAX(Quantity), COUNT(0)
--,MAX(SUM((UnitPrice - Discount)*Quantity)) -- Error 
FROM [Northwind].dbo.[Order Details]
WHERE --ProductID < 10
	UnitPrice > 20
--WHERE SUM((UnitPrice - Discount)*Quantity) > 20000 -- Error
GROUP BY ProductID
--HAVING SUM((UnitPrice - Discount)*Quantity) > 20000
--HAVING MAX(Quantity) > 100
--HAVING COUNT(0) > 10
--HAVING MAX(SUM((UnitPrice - Discount)*Quantity)) -- Error
ORDER BY ProductID
GO


-- JOIN --
SELECT * FROM [Northwind].dbo.[Order Details]
SELECT * FROM Northwind.dbo.Products
SELECT * FROM Northwind.dbo.Categories

SELECT P.ProductName, C.CategoryName, OD.*
FROM [Northwind].dbo.[Order Details] OD
INNER JOIN Northwind.dbo.Products P ON P.ProductID = OD.ProductID
JOIN Northwind.dbo.Categories C ON P.CategoryID = C.CategoryID


DECLARE @Personas AS TABLE (ID INT, Nombre VARCHAR(100), ConyugeID INT)
INSERT INTO @Personas VALUES
(1, 'Pedro', NULL),
(2, 'Pablo', 3),
(3, 'Maria', 2)

SELECT T.*, C.* 
FROM @Personas T
LEFT JOIN @Personas C ON T.ConyugeID = C.ID
WHERE C.ConyugeID IS NULL

SELECT T.*, C.* 
FROM @Personas T
RIGHT JOIN @Personas C ON T.ConyugeID = C.ID

SELECT T.*, C.* 
FROM @Personas T
FULL JOIN @Personas C ON T.ConyugeID = C.ID




DECLARE @Pagos AS TABLE (PersonaID INT, Mes VARCHAR(20), Pago DECIMAL(10,2))
INSERT INTO @Pagos VALUES
(1, 'Enero', 100),
(1, 'Febrero', 200),
(1, 'Marzo', 150),
(2, 'Enero', 140),
(2, 'Febrero', 220),
(3, 'Enero', 160),
(3, 'Febrero', 280),
(3, 'Marzo', 120)

SELECT PersonaID, Mes, Pago FROM @Pagos

SELECT PersonaID,
	[Enero], [Febrero], [Marzo]
FROM
(SELECT PersonaID, Mes, Pago FROM @Pagos) P
PIVOT
(
	SUM(Pago)
	FOR Mes IN ( [Enero], [Febrero], [Marzo])
) AS pvt
ORDER BY PersonaID





