CREATE PROCEDURE ReadEmployeeById
    @Id INT
AS   
    SET NOCOUNT ON;  
    SELECT Employees.Id, FullName, PhoneNumber, Email, EmployeeTypes.Id, Title, Adresses.Id, Country, City, Street, HouseNum, ApartmentNum 
    FROM Employees 
    JOIN Adresses ON Employees.AdressId = Adresses.Id 
    JOIN EmployeeTypes ON Employees.EmployeeTypeId = EmployeeTypes.Id
    WHERE Employees.Id = @Id