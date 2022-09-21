CREATE PROCEDURE ReadAdress
    @Id INT
AS   

    SET NOCOUNT ON;  
    SELECT Country, City, Street, HouseNum, ApartmentNum FROM Adresses  
    WHERE Id = @Id