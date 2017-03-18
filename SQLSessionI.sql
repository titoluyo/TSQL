USE Pruebas
GO

-- Esto es una linea
/*
linea 1
linea 2
*/

SELECT 1 -- Comentario

SELECT 1 
FROM Data 
WHERE x =1 
--AND y = 2
AND z = 4

DECLARE @estado CHAR(1)
DECLARE @dni CHAR(8)
DECLARE @mensaje VARCHAR(100)
DECLARE @mensajex NVARCHAR(100)
DECLARE @condicion BIT --0. 1
DECLARE @datos1 TINYINT -- 0, 255
DECLARE @lista SMALLINT -- -32000,+32000
DECLARE @cuota INT
DECLARE @cuota2 BIGINT
DECLARE @saldo FLOAT
DECLARE @saldo2 REAL
DECLARE @saldo4 NUMERIC(5,2) = 125.317
DECLARE @saldo3 DECIMAL(5,2) = 125.317
SET @saldo3 = 125.30
SELECT @saldo3 = 234.56--,@saldo4 -- no se debe combinar assignacion con retorno de datos
SELECT @saldo4
PRINT @saldo3
DECLARE @fecha SMALLDATETIME = GETDATE()
DECLARE @fecha2 DATETIME = GETDATE()
SELECT @fecha, @fecha2
DECLARE @solofecha DATE = GETDATE(),
	 @solotiempo TIME = GETDATE()

SET DATEFORMAT DMY
DECLARE @fecha5 DATETIME = '01/12/2016'
PRINT @fecha5
PRINT MONTH(@fecha5)

DECLARE @fecha6 DATETIME = '20161201'
PRINT @fecha6
PRINT MONTH(@fecha6)

DECLARE @periodo CHAR(6)
--SET @periodo = LEFT(CONVERT(CHAR(8),@fecha6,112),6)
SET @periodo = CONVERT(CHAR(6),@fecha6,112)
PRINT @periodo

DECLARE @text CHAR(4) = 'Pepito'
PRINT @text

DECLARE @n1 INT = 5 , @n2 INT = 2
PRINT @n1 / CONVERT(DECIMAL(5,2),@n2)

PRINT @N1 / @n2
PRINT @n1 % @n2 -- Modulo, residuo

DECLARE @n3 DECIMAL(5,2) = 27
PRINT CONVERT(INT,@n3)
PRINT FLOOR(@n3)
PRINT CEILING(@n3)
PRINT ROUND(@n3, 2)

PRINT POWER(@n3, 1.0/3.0)

IF (1 = 1 AND NOT(1 = 3) AND (3 BETWEEN 1 AND 2) AND 1 <> 3) -- <> igual a !=
	PRINT 'SI'
ELSE 
	PRINT 'NO'

DECLARE @a TINYINT = 2
PRINT @a | 1
PRINT @a | 3

PRINT @a & 1
PRINT @a & 3

PRINT 'Hola mundo' + ' adios'
GO
PRINT 'Hola ''mundo'''
GO
