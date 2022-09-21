CREATE PROCEDURE CreateAdress
    @Country NVARCHAR(255),   
    @City NVARCHAR(255),   
    @Street NVARCHAR(255),   
    @HouseNum INT,   
    @ApartmentNum INT  
AS   

    SET NOCOUNT ON;  
    INSERT INTO Adresses (Country, City, Street, HouseNum, ApartmentNum) 
    VALUES (@Country, @City, @Street, @HouseNum, @ApartmentNum)