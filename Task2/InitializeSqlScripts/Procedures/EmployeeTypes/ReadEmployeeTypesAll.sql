CREATE PROCEDURE ReadEmployeeTypesAll
AS   
    SET NOCOUNT ON;  
    SELECT Id, Title
    FROM EmployeeTypes