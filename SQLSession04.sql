-- SESSION 4

--SELECT TOP 100 * FROM ca.DataRCC_201212
USE RCC
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE name = 'ufn_Edad' AND type = 'FN')
BEGIN
	DROP FUNCTION dbo.ufn_Edad
END
GO
CREATE FUNCTION dbo.ufn_Edad (@dnacimi DATETIME)
RETURNS INT
AS
BEGIN
	RETURN DATEDIFF(year,@dnacimi,GETDATE()) + CASE WHEN DATEADD(year,DATEDIFF(year,@dnacimi,GETDATE()),@dnacimi) > GETDATE() THEN -1 ELSE 0 END 
END
GO

SELECT dbo.ufn_Edad('19770315')

SELECT TOP 100 
	dnacimi,
	--DATEDIFF(year,dnacimi,GETDATE()) AS YearsBase,
	--CAST(0 AS DATETIME) AS YearInitial,
	--DATEADD(year,DATEDIFF(year,dnacimi,GETDATE()),dnacimi) AS BirthDayThisYear,
	--DATEDIFF(day,0,DATEADD(year,DATEDIFF(year,dnacimi,GETDATE()),dnacimi)) DiasHastaSuActualCumpleanos,
	--DATEDIFF(day,0,GETDATE()) AS DiasHastaHoy,
	--DATEDIFF(day,0,DATEADD(year,DATEDIFF(year,dnacimi,GETDATE()),dnacimi)) - DATEDIFF(day,0,GETDATE()) Diferencia,
	--DATEDIFF(year,dnacimi,GETDATE()) + CASE WHEN DATEADD(year,DATEDIFF(year,dnacimi,GETDATE()),dnacimi) > GETDATE() THEN -1 ELSE 0 END AS Edad,
	
	dbo.ufn_Edad(dnacimi) AS Edad,
	CAST(YEAR(dnacimi) AS CHAR(4)) + RIGHT('0' + CAST(MONTH(dnacimi) AS VARCHAR),2) + '01',
	CONVERT(SMALLDATETIME,CAST(YEAR(dnacimi) AS CHAR(4)) + RIGHT('0' + CAST(MONTH(dnacimi) AS VARCHAR),2) + '01',112) PrimerDiaMes,
	DATEADD(day,-DAY(dnacimi)+1,dnacimi) PrimerDiaMes2, -- forma corta
	DATEADD(day,-1,DATEADD(month,1,DATEADD(day,-DAY(dnacimi)+1,dnacimi))) AS UltimoDiaMes,
	DATEADD(month,1,DATEADD(day,-DAY(dnacimi)+1,dnacimi))-1 AS UltimoDiaMes2, -- Restando -1 dia
	
	CAST(0 AS DATETIME), -- Dia 0: 1900-01-01
	CAST(1 AS DATETIME), -- 1 dia
	CAST(0.5 AS DATETIME), -- medio dia (12 horas)

	cnomusu
FROM LFS.dbo.tabtusu
--WHERE YEAR(dnacimi) = 1972

-- COMENTAR BLOQUES SHORTCUT : CTRL + K, CTRL + C
-- UNCOMMENT : CTRL + K, CTRL + U

SELECT 
	2.0/3.0,
	CAST(2.0/3.0 AS DECIMAL(5,4)), -- CAST (REDONDEA)
	ROUND(2.0/3.0,4),  -- REDONDEO NORMAL
	ROUND(2.0/3.0,4,1) -- TRUNCADO
GO


-- IDENTITY
-- FORMAS DE BORRADO
CREATE TABLE mitabla (
	cod INT  IDENTITY (1,1),
	nombre VARCHAR(100),
	CONSTRAINT pk_mitabla PRIMARY KEY CLUSTERED (cod ASC)
)
GO
-- DELETE con condicion
INSERT mitabla (nombre)
SELECT name FROM sys.objects

DELETE mitabla WHERE nombre LIKE 'S%' -- con condicion
SELECT * FROM mitabla -- observar que cod no el numero del registro
GO
DELETE mitabla -- borra todos los registros, mantiene el IDENTITY
SELECT * FROM mitabla
GO
INSERT mitabla (nombre)
SELECT name FROM sys.objects

TRUNCATE TABLE mitabla -- borra todos los registros, resetea el IDENTITY
SELECT * FROM mitabla
GO

DROP TABLE mitabla -- borra la tabla como objeto
GO

-----------------------
-- SELF REFRERENCE --
SELECT TIT.ccodcli,TIT.cnomcli,TIT.ccodcon, ISNULL(CON.cnomcli,'')
FROM LFSCierre201502.dbo.climide TIT
LEFT JOIN LFSCierre201502.dbo.climide CON ON TIT.ccodcon = CON.ccodcli
GO

-- UNION --
SELECT TOP 1000 * INTO #Saldos201011 FROM dbo.Saldos201011 
SELECT TOP 1000 * INTO #Saldos201012 FROM dbo.Saldos201012

-- SOLO DISTINTOS
SELECT * FROM #Saldos201011 WHERE COD_SBS IN ('0002773732','0002873621')
UNION
SELECT * FROM #Saldos201012 WHERE COD_SBS IN ('0002773732','0002873621')

-- TRAE TODOS INCLUSO REPETIDOS (MAS RAPIDO)
SELECT * FROM #Saldos201011 WHERE COD_SBS IN ('0002773732','0002873621')
UNION ALL
SELECT * FROM #Saldos201012 WHERE COD_SBS IN ('0002773732','0002873621')

-- DIFERENCIAR POR PER
SELECT '201011',* FROM #Saldos201011 WHERE COD_SBS IN ('0002773732','0002873621')
UNION ALL
SELECT '201012',* FROM #Saldos201012 WHERE COD_SBS IN ('0002773732','0002873621')
GO


DROP TABLE mitabla
GO
CREATE TABLE mitabla (
	-- INDENTITY (inicio o seed, incremento)
	cod INT  IDENTITY (5,3) NOT NULL, -- IDENTITY y PRIMARY KEY no pueden ser NULL
	nombre VARCHAR(100) NOT NULL,
	edad INT NULL,
	CONSTRAINT pk_mitabla PRIMARY KEY CLUSTERED (cod ASC)
)
GO

INSERT mitabla  VALUES ('Pedro', 20) 
INSERT INTO mitabla (nombre) VALUES ('Pablo') -- con lista de columnas
INSERT INTO mitabla VALUES ('Luis',31)

-- multiples filas
INSERT INTO mitabla VALUES 
('Pedro',10),
('Pablo',20),
('Luis',21),
('Javier',34)

-- insertar en la columna IDENTITY con valor especifico
SET IDENTITY_INSERT mitabla ON 
INSERT INTO mitabla (cod,nombre,edad) VALUES (10,'Pepe',50)
SET IDENTITY_INSERT mitabla OFF

INSERT INTO mitabla VALUES ('Paco',11)

-- INSERTA REGISTROS DE OTRO SELECT
INSERT INTO mitabla
SELECT name, [OBJECT_ID] FROM sys.objects

-- 1ero CREATE TABLE
-- 2do INSERTA REGISTROS
SELECT [OBJECT_ID], NAME 
INTO temp
FROM sys.objects

DROP TABLE temp


SELECT * FROM mitabla


--- UPDATE --
UPDATE mitabla
SET nombre = 'Hola',
	edad = edad + 1
WHERE cod = 10

SELECT * FROM mitabla


UPDATE mitabla
SET nombre = 'Paco'
WHERE nombre = 'Hola'

SELECT * FROM mitabla


-- UPDATE FROM --
SELECT *
FROM mitabla T
LEFT JOIN sys.objects O ON T.nombre = O.name 

UPDATE mitabla
SET nombre = nombre + ' (' + O.type COLLATE Modern_Spanish_CI_AS  + ')'
FROM mitabla T
JOIN sys.objects O ON T.nombre = O.name 

SELECT * FROM mitabla

