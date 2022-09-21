CREATE PROCEDURE UpdateAdress  
    @Id INT,
    @NewCountry NVARCHAR(255),   
    @NewCity NVARCHAR(255),   
    @NewStreet NVARCHAR(255),   
    @NewHouseNum INT,   
    @NewApartmentNum INT  
AS   

    SET NOCOUNT ON;  
    UPDATE Adresses SET Country = @NewCountry, City = @NewCity, Street = @NewStreet, HouseNum = @NewHouseNum, ApartmentNum = @NewApartmentNum
    WHERE Id = @Id