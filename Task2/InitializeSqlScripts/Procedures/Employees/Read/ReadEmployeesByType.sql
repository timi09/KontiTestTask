CREATE PROCEDURE ReadEmployeesByType
    @EmployeeType NVARCHAR(255)  
AS   
    SET NOCOUNT ON;  
    SELECT Employees.Id, FullName, PhoneNumber, Email, EmployeeTypeId, @EmployeeType, Adresses.Id, Country, City, Street, HouseNum, ApartmentNum 
    FROM Employees 
    JOIN Adresses ON Employees.AdressId = Adresses.Id
    WHERE EmployeeTypeId = (SELECT Id FROM EmployeeTypes WHERE EmployeeTypes.Title = @EmployeeType)