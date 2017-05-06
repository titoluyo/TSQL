--CONSTRAINTS


USE RCC
GO

--DROP TABLE mitabla
CREATE TABLE mitabla (
	codPadre INT IDENTITY(1,1) NOT NULL , --  PRIMARY KEY,
	nombre VARCHAR(10) NULL,
	dni CHAR(8) NOT NULL,
	edad INT NOT NULL,
	direccion VARCHAR(30) NOT NULL, --DEFAULT ('nada')
	fecha_creacion DATETIME NOT NULL DEFAULT GETDATE()
--	CONSTRAINT pk_mitabla PRIMARY KEY CLUSTERED (codigo ASC)
)

sp_help mitabla -- selecccionar texto ALT + F1 
ALTER TABLE mitabla ADD CONSTRAINT pk_mitabla PRIMARY KEY NONCLUSTERED (codPadre)
--ALTER TABLE mitabla DROP CONSTRAINT pk_mitabla

ALTER TABLE mitabla ADD CONSTRAINT df_mitabla_direccion DEFAULT ('nada') FOR direccion

ALTER TABLE mitabla ADD CONSTRAINT un_mitabla_nombre UNIQUE (nombre) -- nombre con valores unicos

ALTER TABLE mitabla ADD CONSTRAINT ch_mitabla_edad CHECK (edad > 18)
ALTER TABLE mitabla ADD CONSTRAINT ch_mitabla_edad CHECK (edad > 18)

CREATE CLUSTERED INDEX idx_mitabla_nombre ON mitabla(nombre)
CREATE NONCLUSTERED INDEX idx_mitabla_edad ON mitabla(edad)
CREATE CLUSTERED INDEX idx_mitabla_dni ON mitabla(dni) -- ERROR solo un clustered
CREATE NONCLUSTERED INDEX idx_mitabla_dni_nombre ON mitabla(dni DESC, nombre) 


SELECT * FROM mitabla

GO

USE Northwind
GO

SELECT * FROM Products
SELECT * FROM Categories

ALTER TABLE mitabla ADD CONSTRAINT df_mitabla_direccion DEFAULT ('nada') FOR direccion

ALTER TABLE Products  
	ADD  CONSTRAINT FK_Products_Categories 
	FOREIGN KEY(CategoryID) 
	REFERENCES Categories (CategoryID)
	
ALTER TABLE Products DROP CONSTRAINT FK_Products_Categories

--DELETE Categories WHERE CategoryID = 2
INSERT Products VALUES ('Pruba', 1, 20, 'unidades', 10, 0,0,0,0)
DELETE Products WHERE ProductName = 'Pruba'


-- INDEXES
USE Northwind
GO

CREATE CLUSTERED INDEX idx_Products_ProductName  ON Products(ProductName)

USE [RCC]
GO

/****** Object:  Index [idx_Clus]    Script Date: 05/06/2017 11:23:52 ******/
CREATE CLUSTERED INDEX [idx_Clus] ON [dbo].[Saldos201703] 
(
	[COD_ENT] ASC,
	[COD_CTA] ASC,
	[COD_SBS] ASC,
	[TIP_CRED] ASC,
	[SALDO] ASC,
	[CALIF] ASC
)
GO


SELECT TOP 10 * FROM Saldos201310 WHERE COD_SBS = '0008960950'
SELECT COD_ENT, CANT = COUNT(0)  FROM Saldos201310 GROUP BY COD_ENT

GO
--DROP VIEW uvw_Saldos
CREATE VIEW uvw_Saldos 
AS
SELECT '201010' Periodo, COD_SBS, COD_ENT, TIP_CRED, COD_CTA, ATRASO, SALDO, CALIF FROM dbo.Saldos201010
UNION ALL
SELECT '201011' Periodo, COD_SBS, COD_ENT, TIP_CRED, COD_CTA, ATRASO, SALDO, CALIF FROM dbo.Saldos201011

GO

SELECT TOP 10 * FROM uvw_Saldos WHERE Periodo = '201011'

select * from rcc.klo.TablaPeriodos

SELECT * FROM Saldos201010 a WHERE a.COD_CTA like '14[1-2][1-6]%' and a.COD_ENT=104
SELECT * FROM Saldos201010 a WHERE a.COD_ENT=104 and a.COD_CTA like '14[1-2][1-6]%'


DECLARE @MesIni CHAR(6) = '201012',
	@MesFin CHAR(6) = '201610',
	@Entidad INT = 104
select  --MesID=@MesIni
		a.Periodo
	   ,a.COD_SBS
	   ,a.TIP_CRED
	   ,a.CALIF
	   ,sum(Saldo/100.0) Saldo
from rcc.dbo.uvw_Saldos as a
where a.COD_CTA like '14[1-2][1-6]%' and COD_ENT=@Entidad,
	a.Periodo BETWEEN @MesIni AND @MesFin
group by a.COD_SBS,a.CALIF,a.TIP_CRED

