CREATE PROCEDURE DeleteAdress
    @Id INT
AS   

    SET NOCOUNT ON;  
    DELETE FROM Adresses  
    WHERE Id = @Id