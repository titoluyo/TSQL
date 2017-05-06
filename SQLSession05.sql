-- CONTROL OF FLOW

USE RCC
GO 

DECLARE @fecha DATETIME = '20101222'-- GETDATE()

SELECT @fecha Fecha

IF YEAR(@fecha) = 2010 AND
	MONTH(@fecha) = 12
BEGIN
	SELECT TOP 10 * FROM Clientes201012
	SELECT COUNT(0) FROM Clientes201012
END

SELECT 'Fin' FIN


USE LFSCierre201502
GO
--GOTO LOQUEQUIERAS -- SALTA HASTA ETIQUETA
DECLARE @contador INT = 0
WHILE  @contador < 10
BEGIN
	--SELECT RIGHT('00'+CAST(@contador AS VARCHAR),3)
	SET @contador = @contador + 1
	IF @contador = 3
		CONTINUE -- IGNORA EL RESTO | CONTINUE EL BUCLE
	IF @contador = 8
		BREAK -- IGNORA EL RESTO | DETIENE EL BUCLE
	SELECT TOP 10 * FROM credppg WHERE cnrocuo = RIGHT('00'+CAST(@contador AS VARCHAR),3)

END

LOQUEQUIERAS: -- DEFINICION DE ETIQUETA (: AL FINAL)
SELECT GETDATE()

GO

USE RCC
GO
--DROP TABLE mitabla
CREATE TABLE mitabla (
	codigo INT IDENTITY(1,1) NOT NULL , --  PRIMARY KEY,
	nombre VARCHAR(10) NULL,
	dni CHAR(8) NOT NULL,
	CONSTRAINT pk_mitabla PRIMARY KEY CLUSTERED (codigo ASC)
)

INSERT INTO mitabla VALUES 
('Pedro', '12345678'),
('Pablo', '12345679')

SELECT  * FROM mitabla

ALTER TABLE mitabla ADD direccion VARCHAR(30) NOT NULL -- ERROR
ALTER TABLE mitabla ADD direccion VARCHAR(30) NULL
ALTER TABLE mitabla DROP COLUMN direccion
ALTER TABLE mitabla ADD direccion VARCHAR(30) NOT NULL DEFAULT ('nada')
ALTER TABLE mitabla DROP CONSTRAINT DF__mitabla__direcci__55C0849F

INSERT INTO mitabla (nombre, dni) VALUES 
('Luis', '12345610'),
('Javier', '12345611')

INSERT INTO mitabla (nombre,dni,direccion) VALUES 
('Luis', '12345610', '123456789012345678901234567890')

SELECT MAX(LEN(direccion)) FROM mitabla -- 30

ALTER TABLE mitabla ALTER COLUMN direccion VARCHAR(10) NOT NULL -- ERROR: TRUNCADO

UPDATE mitabla
SET direccion = LEFT(direccion,10) --'1234567890' -- AJUSTAR LONGITUD A 10
WHERE nombre = 'Luis'

SELECT MAX(LEN(direccion)) FROM mitabla -- 10

ALTER TABLE mitabla ALTER COLUMN direccion VARCHAR(10) NOT NULL -- OK!


-- RECURSOS
--https://blog.sqlauthority.com
-- SQL Developer Edition (2016?) FREE!!!
-- https://myprodscussu1.app.vssubscriptions.visualstudio.com/Downloads?q=SQL%20Server%202016%20Developer

USE BASE_CARTERA
GO
SELECT * FROM mitabla