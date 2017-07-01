-- SESSION 09
-- Parametrizacion de Query '2.Cartera Simulada CMAC 00 PROCEDURE- Completo - Segun Producto.sql'

SELECT  * 
INTO #Saldos
FROM RCC.dbo.uvw_Saldos
WHERE COD_SBS = '0001197258'


-- Common Table Expressions
-- Recursive
WITH query_Saldo 
AS (
	-- Caso base
	SELECT *,A.Saldo / 100.00 AS SaldoAcum 
	FROM #Saldos A 
	WHERE A.MesId = 34
	
	UNION ALL
	
	SELECT *,B.SALDO / 100.00 + C.SaldoAcum  As SaldoAcum  
	FROM #Saldos B 
	INNER JOIN query_Saldo C ON B.MesId = C.MesId + 1
)
SELECT * FROM query_Saldo

-------------------------------------------

USE AdventureWorks;
GO
-- Create an Employee table.
CREATE TABLE #MyEmployees
(
	EmployeeID smallint NOT NULL,
	FirstName nvarchar(30)  NOT NULL,
	LastName  nvarchar(40) NOT NULL,
	Title nvarchar(50) NOT NULL,
	DeptID smallint NOT NULL,
	ManagerID int NULL,
 CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC) 
);
-- Populate the table with values.
INSERT INTO #MyEmployees VALUES 
 (1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL)
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1)
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273)
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274)
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274)
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273)
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285)
,(16,  N'David',N'Bradley', N'Marketing Manager', 4, 273)
,(23,  N'Mary', N'Gibson', N'Marketing Specialist', 4, 16);

SELECT * FROM #MyEmployees

WITH DirectReports (ManagerID, EmployeeID, Title, Level,LineaComando)
AS
(
-- Anchor member definition
    SELECT e.ManagerID, e.EmployeeID, e.Title, 
        0 AS Level, CAST(e.FirstName + ' ' + e.LastName AS VARCHAR(MAX)) AS LineaComando
    FROM #MyEmployees AS e
    WHERE ManagerID IS NULL
    UNION ALL
-- Recursive member definition
    SELECT e.ManagerID, e.EmployeeID, e.Title,
        d.Level + 1, CAST(LineaComando + ' | ' + e.FirstName + ' ' + e.LastName AS VARCHAR(MAX)) AS LineaComando
    FROM #MyEmployees AS e
    INNER JOIN DirectReports AS d
        ON e.ManagerID = d.EmployeeID
)
-- Statement that executes the CTE
SELECT ManagerID, EmployeeID, Title, Level, LineaComando
FROM DirectReports
--WHERE dp.GroupName = N'Sales and Marketing' OR Level = 0;
GO
