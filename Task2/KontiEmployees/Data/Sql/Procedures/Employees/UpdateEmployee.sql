CREATE PROCEDURE UpdateEmployee
    @Id INT,
    @FullName NVARCHAR(255),   
    @PhoneNumber NVARCHAR(20),   
    @Email NVARCHAR(50),
    @EmployeeType NVARCHAR(255),
    @Country NVARCHAR(255),   
    @City NVARCHAR(255),   
    @Street NVARCHAR(255),   
    @HouseNum INT,   
    @ApartmentNum INT
AS   
    SET NOCOUNT ON;  
    
    IF @FullName IS NULL OR @EmployeeType IS NULL OR @Country IS NULL OR @City IS NULL OR @Street IS NULL OR @HouseNum IS NULL OR @ApartmentNum IS NULL
        THROW 50010, N'One of the fields is null', 1;

    DECLARE @FindedTypeID AS INT;
    SET @FindedTypeID = (SELECT Id FROM EmployeeTypes WHERE Title = @EmployeeType);

    IF @FindedTypeID IS NULL
        THROW 50005, N'Incorrect employee type', 1;

    DECLARE @FindedAdressID AS INT;
    SET @FindedAdressID = (SELECT Id FROM Adresses WHERE Country = @Country AND City = @City AND Street = @Street AND HouseNum = @HouseNum AND ApartmentNum = @ApartmentNum);

    IF @FindedAdressID IS NULL
        BEGIN
            INSERT INTO Adresses (Country, City, Street, HouseNum, ApartmentNum) 
            VALUES (@Country, @City, @Street, @HouseNum, @ApartmentNum);
            SET @FindedAdressId = (SELECT SCOPE_IDENTITY());
        END;

    UPDATE Employees SET FullName = @FullName, PhoneNumber = @PhoneNumber, Email = @Email, EmployeeTypeId = @FindedTypeID, AdressId = @FindedAdressID 
    WHERE Employees.Id = @Id;