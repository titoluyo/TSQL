/*
 * CAPACITACION T-SQL
 *
 * 
 *
 */

USE pubs -- Cambiar la BD en uso
GO

-- Comentarios:
-- Esto es una linea
/*
Multilinea
linea 1
linea 2
*/

SELECT 1 -- Comentario

SELECT * 
FROM authors 
WHERE au_lname = 'Ringer' 
--AND au_fname = 'Anne' -- Comentando parte del código
AND contract = 1
GO

-- Variables
-- DECLARE @mivariable1 <TipoDeDato>([<longitud]>)
-- Variables declaracion multiple
DECLARE @mivariable1 CHAR(10), @mivariable2 INT 

-- Asignación de variables
-- 1. En la declaracion
DECLARE @mivar1 CHAR(8) = '12345678', @mivar2 INT = 1, @mivar3 VARCHAR(10) = NULL
-- 2. Usando SET
SET @mivar1 = '12345678'
SET @mivar2 = 5
-- 3. USando SELECT
SELECT @mivar2 = 1, @mivar3 = 'Hola'

-- Conversión implicita
DECLARE @texto VARCHAR(10), @numero INT
SET @texto = 1234.56
SET	@numero = '12345'
SELECT @texto, @numero

-- Presentacion de datos
PRINT 'Hola mundo' + ' adios'
PRINT 'Hola ''mundo'''
DECLARE @var1 VARCHAR(10) = 'mundo', @var2 INT = 10
PRINT 'Hola ' + @var1
PRINT @var2
SELECT 1, @var2, 'Hola ' + @var1
GO -- Terminacion de Batch
PRINT @var2 -- la variable "vive" dentro de un batch, acá ya no está declarada

-- Un SELECT de asignación NO se puede MEZCLAR con uno de obtencion de datos
DECLARE @var1 INT, @var2 VARCHAR(10) = 'ejemplo'
SELECT @var1 = 1, @var2 -- Error

-- Tipos de datos
DECLARE @estado CHAR(1) -- (1 BYTE/caracter) Cadena de caracteres de longitud fija
DECLARE @dni CHAR(8)
DECLARE @mensaje VARCHAR(100) -- (1 BYTE/caracter) Cadena de longitud variable
DECLARE @mensajex NVARCHAR(100) -- (2 BYTES/caracter) Cadena de tipo UNICODE (caracteres especiales internacional, ocupa el doble de espacio)
DECLARE @estado2 NCHAR(1)  -- (2 BYTES/caracter) 
DECLARE @textoMuyLargo VARCHAR(MAX) -- MAX indica que es un texto sin límite de longitud (contratos, cartas, descripciones largas, etc.)
DECLARE @textoMuyLargo2 TEXT -- (OBSOLETO) igual que el anterior, solo por compatibilidad con versiones anteriores
DECLARE @binario BINARY(10) -- Contenido binario de longitud fija
DECLARE @binario2 VARBINARY(10) -- Contenido binario de longitud variable 

-- Numericos
DECLARE @condicion BIT	-- (1 BIT) Solo 0 o 1
DECLARE @datos1 TINYINT	-- (1 BYTE (8bit)) Valores -2^15 (-32,768) a 2^15-1 (32,767)
DECLARE @lista SMALLINT	-- (2 BYTES) Valores desde -32,768 a 32,67
DECLARE @cuota INT		-- (4 BYTES) Valores desde --2^31 (-2,147,483,648) a 2^31-1 (2,147,483,647)
DECLARE @cuota2 BIGINT	-- (8 BYTES) Valores desde -2^63 (-9,223,372,036,854,775,808) a 2^63-1 (9,223,372,036,854,775,807)
DECLARE @saldo FLOAT	-- Valores decimales aproximados
DECLARE @saldo2 REAL	-- similar a float
DECLARE @saldo4 NUMERIC(5,2) = 125.317	-- Valor decimal exacto (5 digito, 2 decimales)
DECLARE @saldo3 DECIMAL(5,2) = 125.317	-- Similar al anterior
SET @saldo3 = 125.30

-- Fecha / Hora
DECLARE @fecha SMALLDATETIME = GETDATE()-- (4 BYTES) precisión: minutos, desde 1900 hasta 2079 
DECLARE @fecha2 DATETIME = GETDATE()	-- (8 BYTES) presicion: milisegundos (redondeados a incrementos de .000, .003 o .007), desde 1753 hasta 9999
SELECT @fecha, @fecha2
DECLARE @solofecha DATE = GETDATE(),	-- (3 BYTES) presicion: dia, desde 0000 hasta 9999
	 @solotiempo TIME = GETDATE()		-- (5 BYTES) precision: 100nanosegundos a 1 milisegundo
DECLARE @fecha3 DATETIME2 = GETDATE()	-- precision: 100 ns, desde 0001 hasta 9999

SET DATEFORMAT DMY
-- No recomendado, depende mucho del entorno, del idioma del usuario, 
-- puede tener resultados distintos, en distintas PCs
-- puede interpretarse MM/DD/YYYY (US) o DD/MM/YYYY (UK,FR)
DECLARE @fecha5 DATETIME = '01/12/2016' -- Usando la conversión implicita
PRINT @fecha5
PRINT MONTH(@fecha5)

-- No hay ambiguedad para el SQL siempre sera YYYYMMDD
DECLARE @fecha6 DATETIME = '20161201' -- Usando el formato ISO (style:112)
PRINT @fecha6
PRINT MONTH(@fecha6)

DECLARE @text CHAR(4) = 'Pepito' -- Truncado de datos
PRINT @text 

DECLARE @periodo CHAR(6)
SET @periodo = LEFT(CONVERT(CHAR(8),@fecha6,112),6)
PRINT @periodo
SET @periodo = CONVERT(CHAR(6),@fecha6,112) -- aprovechando el truncado de datos
PRINT @periodo

DECLARE @n1 INT = 5 , @n2 INT = 2
PRINT @N1 / @n2 -- Division entera
PRINT @n1 % @n2 -- Modulo, residuo
PRINT @n1 / CONVERT(DECIMAL(5,2),@n2)

DECLARE @n3 DECIMAL(5,2) = 27.456
PRINT CONVERT(INT,@n3)
PRINT FLOOR(@n3) -- menor valor entero
PRINT CEILING(@n3) -- siguiente valor entero
PRINT ROUND(@n3, 2) -- clasico redondeo matematico, a 2 decimales
PRINT ROUND(@n3, 2, 0) -- sin redondeo, trunca a 2 decimales

PRINT POWER(@n3, 3) -- @n3 elevado al cubo 
PRINT POWER(@n3, 1/3) -- 1/3 = 0 (division entera) @n3 elevado a la 0 es igual a 1
PRINT POWER(@n3, 1.0/3.0)  -- raiz cubica de @n3

-- Expresiones booleanas AND, OR, NOT
-- Desigualdad (<> o !=  , el primero es el mas conocido)
-- Numero en rango (BETWEEN) en un intervalo cerrado
IF (1 = 1 AND NOT(1 = 3) AND (3 BETWEEN 1 AND 2) AND 1 <> 3) -- <> igual a !=
	PRINT 'SI'
ELSE -- "Sino" es opcional
	PRINT 'NO'

-- Operadores BITWISE (AND, OR a nivel de bits)
DECLARE @a TINYINT = 2
-- OR a nivel de bits
PRINT @a | 1 
PRINT @a | 3
-- AND a nivel de bits
PRINT @a & 1
PRINT @a & 3


