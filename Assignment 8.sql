
EXEC SP_changedbowner [DESKTOP-FGQ1OBR\fired]
CREATE FUNCTION uf_LNFN (@FN nvarchar(50), @LN nvarchar(50)) RETURNS nvarchar(102)
BEGIN
RETURN RTRIM(@LN) + ', ' + @FN
END

SELECT dbo.uf_LNFN('John','Smith')



SELECT dbo.uf_LNFN('John', 'Smith') AS EmployeeName, HRD.Name AS Department, JobTitle
FROM HumanResources.Employee AS HRE
	JOIN HumanResources.EmployeeDepartmentHistory AS HREDH ON HRE.BusinessEntityID = HREDH.BusinessEntityID
	JOIN HumanResources.Department AS HRD ON HREDH.DepartmentID = HRD.DepartmentID;

SELECT *
FROM Person.Address;

SELECT *
FROM Person.AddressType;

SELECT *
FROM Person.Person;

SELECT *
FROM HumanResources.Employee;

SELECT *
FROM HumanResources.EmployeeDepartmentHistory;

SELECT *
FROM HumanResources.Department;

SELECT dbo.uf_LNFN(LastName, FirstName) AS EmployeeName, HRD.Name AS Department, JobTitle
FROM HumanResources.Employee AS HRE
	JOIN HumanResources.EmployeeDepartmentHistory AS HREDH ON HRE.BusinessEntityID = HREDH.BusinessEntityID
	JOIN Person.Person AS PP ON HREDH.BusinessEntityID = PP.BusinessEntityID
	JOIN HumanResources.Department AS HRD ON HREDH.DepartmentID = HRD.DepartmentID
WHERE EndDate IS NULL;

SELECT dbo.uf_LNFN(LastName, FirstName) AS EmployeeName, HRD.Name AS Department, JobTitle, City, PostalCode, SpatialLocation
FROM HumanResources.Employee AS HRE
	JOIN HumanResources.EmployeeDepartmentHistory AS HREDH ON HRE.BusinessEntityID = HREDH.BusinessEntityID
	JOIN Person.Person AS PP ON HREDH.BusinessEntityID = PP.BusinessEntityID
	JOIN HumanResources.Department AS HRD ON HREDH.DepartmentID = HRD.DepartmentID
	JOIN Person.BusinessEntityAddress AS PBEA ON PP.BusinessEntityID = PBEA.BusinessEntityID
	JOIN Person.AddressType AS PAT ON PBEA.AddressTypeID = PAT.AddressTypeID
	JOIN Person.Address AS PA ON PBEA.AddressID = PA.AddressID
WHERE EndDate IS NULL AND
	 PAT.Name = 'Home';
Order By EmployeeName;

SELECT dbo.uf_LNFN(LastName, FirstName) AS EmployeeName, HRD.Name AS Department, JobTitle, City, PostalCode, SpatialLocation
FROM HumanResources.Employee AS HRE
	JOIN HumanResources.EmployeeDepartmentHistory AS HREDH ON HRE.BusinessEntityID = HREDH.BusinessEntityID
	JOIN Person.Person AS PP ON HREDH.BusinessEntityID = PP.BusinessEntityID
	JOIN HumanResources.Department AS HRD ON HREDH.DepartmentID = HRD.DepartmentID
	JOIN Person.BusinessEntityAddress AS PBEA ON PP.BusinessEntityID = PBEA.BusinessEntityID
	JOIN Person.AddressType AS PAT ON PBEA.AddressTypeID = PAT.AddressTypeID
	JOIN Person.Address AS PA ON PBEA.AddressID = PA.AddressID
WHERE EndDate IS NULL AND
	 PAT.AddressTypeID = 2
	 Order By EmployeeName;

SELECT dbo.uf_LNFN(LastName, FirstName) AS EmployeeName, HRD.Name AS Department, JobTitle, City, PostalCode, SpatialLocation
FROM Person.Person AS PP
	JOIN HumanResources.EmployeeDepartmentHistory AS HREDH ON PP.BusinessEntityID = HREDH.BusinessEntityID
	JOIN HumanResources.Employee AS HRE ON HREDH.BusinessEntityID = HRE.BusinessEntityID
	JOIN HumanResources.Department AS HRD ON HREDH.DepartmentID = HRD.DepartmentID
	JOIN Person.BusinessEntityAddress AS PBEA ON PP.BusinessEntityID = PBEA.BusinessEntityID
	JOIN Person.AddressType AS PAT ON PBEA.AddressTypeID = PAT.AddressTypeID
	JOIN Person.Address AS PA ON PBEA.AddressID = PA.AddressID
WHERE EndDate IS NULL AND
	 PAT.Name = 'Home';

SELECT dbo.uf_LNFN(LastName, FirstName) AS EmployeeName, HRD.Name AS Department, JobTitle, City, PostalCode, SpatialLocation, SpatialLocation.Lat AS Latitude, SpatialLocation.Long AS Longitude
FROM HumanResources.Employee AS HRE
	JOIN HumanResources.EmployeeDepartmentHistory AS HREDH ON HRE.BusinessEntityID = HREDH.BusinessEntityID
	JOIN Person.Person AS PP ON HREDH.BusinessEntityID = PP.BusinessEntityID
	JOIN HumanResources.Department AS HRD ON HREDH.DepartmentID = HRD.DepartmentID
	JOIN Person.BusinessEntityAddress AS PBEA ON PP.BusinessEntityID = PBEA.BusinessEntityID
	JOIN Person.AddressType AS PAT ON PBEA.AddressTypeID = PAT.AddressTypeID
	JOIN Person.Address AS PA ON PBEA.AddressID = PA.AddressID
WHERE EndDate IS NULL AND
	 PAT.Name = 'Home';

SELECT dbo.uf_LNFN(LastName, FirstName) AS EmployeeName, HRD.Name AS Department, JobTitle, City, PostalCode, SpatialLocation, SpatialLocation.Lat AS Latitude, SpatialLocation.Long AS Longitude
INTO #T1
FROM HumanResources.Employee AS HRE
	JOIN HumanResources.EmployeeDepartmentHistory AS HREDH ON HRE.BusinessEntityID = HREDH.BusinessEntityID
	JOIN Person.Person AS PP ON HREDH.BusinessEntityID = PP.BusinessEntityID
	JOIN HumanResources.Department AS HRD ON HREDH.DepartmentID = HRD.DepartmentID
	JOIN Person.BusinessEntityAddress AS PBEA ON PP.BusinessEntityID = PBEA.BusinessEntityID
	JOIN Person.AddressType AS PAT ON PBEA.AddressTypeID = PAT.AddressTypeID
	JOIN Person.Address AS PA ON PBEA.AddressID = PA.AddressID
WHERE EndDate IS NULL AND
	 PAT.Name = 'Home';

ALTER TABLE #T1
	ADD Distance float

DECLARE @g geography
SET @g = geography::STGeomFromText('POINT(-122.136626 47.642275)', 4326)
UPDATE #T1
SET Distance = SpatialLocation.STDistance(@g)/1609.344

SELECT EmployeeName, Department, City, Latitude, Longitude, Distance
FROM #T1


	