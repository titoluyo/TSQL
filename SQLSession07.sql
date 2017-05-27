-- TEMPORARY TABLES

-- variabe tipo table (dura en un batch)
DECLARE @mitable AS TABLE (cod INT, name VARCHAR(10))
INSERT INTO @mitable VALUES (1, 'Tito')

SELECT * FROM @mitable

GO

SELECT * FROM @mitable
GO

-- tabla temporal (dura en una sesion)
-- se graba en la BD tempdb
IF OBJECT_ID('tempdb..#mitable') IS NOT NULL
	DROP TABLE #mitable
CREATE TABLE #mitable (
	cod INT,
	name VARCHAR(10)
)
GO

INSERT INTO #mitable VALUES (1, 'Tito')
GO
SELECT * FROM #mitable
GO
USE LFS
SELECT * FROM #mitable
GO

-- tabla temporal global (vive en todas las sesiones, hasta que todas se desconecten)
CREATE TABLE ##mitable (
	cod INT,
	name VARCHAR(10)
)
GO
INSERT INTO ##mitable VALUES (1, 'Tito')
GO
SELECT * FROM ##mitable
GO

-- COLLATES
-- CI: Case Insentive	A = a
-- CC: Case Sensitve	A <> a
-- AI: Accent Insensitive  á = a
-- AS: Accent Sensitive  á <> a

-- UDF : Funciones definidas por el usuario
-- Scalar-valued
USE Northwind
GO
CREATE FUNCTION dbo.ufn_Edad(@FecNac DATETIME)
RETURNS SMALLINT
BEGIN
	RETURN DATEDIFF(YEAR,@FecNac,GETDATE()) + CASE WHEN CAST(YEAR(GETDATE()) AS CHAR(4)) +  RIGHT(CONVERT(CHAR(8),@FecNac,112),4) < GETDATE() THEN 1 ELSE 0 END
END
GO
SELECT dbo.ufn_Edad('19990530')
GO

-- Table-valued
USE Northwind
GO
CREATE FUNCTION [dbo].[ufn_SplitString] 
( 
    @string NVARCHAR(MAX), 
    @delimiter CHAR(1) 
    -- http://www.sqlservercentral.com/blogs/querying-microsoft-sql-server/2013/09/19/how-to-split-a-string-by-delimited-char-in-sql-server/
    
) 
RETURNS @output TABLE(splitdata NVARCHAR(MAX) 
) 
BEGIN 
    DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
    WHILE @start < LEN(@string) + 1 BEGIN 
        IF @end = 0  
            SET @end = LEN(@string) + 1
       
        INSERT INTO @output (splitdata)  
        VALUES(SUBSTRING(@string, @start, @end - @start)) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @string, @start)
        
    END 
    RETURN 
END
GO

DECLARE @productos VARCHAR(255) 
SET @productos = '1,4,13'
SELECT splitdata FROM dbo.ufn_SplitString(@productos,',')

SELECT *
FROM Saldos 
WHERE CodProducto IN (SELECT splitdata FROM dbo.ufn_SplitString(@productos,','))
--WHERE CodProducto IN (1,4,13)
--WHERE CodProducto IN ('1,4,13')
GO


-- Aggregate Functions
-- Necesita CLR (Common laguage runtime) (dll creada con C#)

-- VIEWS
USE Northwind
GO
CREATE VIEW uvw_OrdersF
AS

	SELECT O.OrderID, O.CustomerID, C.CompanyName
	FROM Orders O WITH (NOLOCK)
	JOIN Customers C WITH (NOLOCK) ON O.CustomerID = C.CustomerID

GO

SELECT * FROM uvw_OrdersF

-- STORED PROCEDURE
USE Northwind
GO
ALTER PROCEDURE usp_Proc1 (
@Customer VARCHAR(100),
@CantidadOrders INT OUTPUT
)
AS
BEGIN
	SELECT * FROM Customers C WITH (NOLOCK) WHERE C.CustomerID = @Customer

	SELECT * FROM ORders O WITH (NOLOCK) WHERE O.CustomerID = @Customer

	SET @CantidadOrders = (SELECT COUNT(1) FROM ORders O WITH (NOLOCK) WHERE O.CustomerID = @Customer)
END
GO --<<< !!!! IMPORTANTE CERRAR EL SP

DECLARE @Cant INT
EXEC usp_Proc1 'ALFKI', @Cant OUTPUT
SELECT @Cant
GO

-- CUSTOM TYPES
-- Data type
CREATE TYPE udt_Tipo1
FROM
int NOT NULL;
GO

DECLARE @var udt_Tipo1
SET @var = 1
PRINT @var
GO

-- Table Type
CREATE TYPE udt_Tabla1 AS TABLE (
	valor INT
)
GO


USE Northwind
GO
ALTER PROCEDURE usp_Proc2 (
	@Customer VARCHAR(10),
	@mitabla udt_Tabla1 READONLY
)
/*
usp_Proc2: Devolver orders por cliente y empleados
2017-05-27 - Tito Luyo - Creacion inicial
2017-05-30 - Jose - Agregar Nombre de empleado

Ejemplo:
	DECLARE @mitabla udt_Tabla1
	INSERT INTO @mitabla VALUES (1),(2),(3)
	EXEC usp_Proc2 'ALFKI', @mitabla
 */
AS
BEGIN
	SELECT * 
	FROM Orders 
	WHERE CustomerID = @Customer
		AND EmployeeID IN (SELECT valor FROM @mitabla)
END
GO


DECLARE @mitabla udt_Tabla1
INSERT INTO @mitabla VALUES (1),(2),(3)
SELECT * FROM @mitabla

EXEC usp_Proc2 'ALFKI', @mitabla
