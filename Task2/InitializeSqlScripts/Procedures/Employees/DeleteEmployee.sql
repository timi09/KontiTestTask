CREATE PROCEDURE DeleteEmployee
    @Id INT
AS   
    SET NOCOUNT ON;  
    DELETE FROM Employees  
    WHERE Id = @Id
