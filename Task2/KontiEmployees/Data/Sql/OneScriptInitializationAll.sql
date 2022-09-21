CREATE TABLE Adresses
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Country NVARCHAR(255) NOT NULL,
	City NVARCHAR(255) NOT NULL,
	Street NVARCHAR(255) NOT NULL,
	HouseNum INT NOT NULL,
	ApartmentNum INT NOT NULL,
);
GO

CREATE TABLE EmployeeTypes
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Title NVARCHAR(255) UNIQUE NOT NULL,	
);
GO

CREATE TABLE Employees
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	FullName NVARCHAR(255) NOT NULL,
	PhoneNumber NVARCHAR(20) NOT NULL UNIQUE,
	Email NVARCHAR(50) NOT NULL UNIQUE,
	AdressId INT NOT NULL,
	EmployeeTypeId INT NOT NULL,
	FOREIGN KEY(AdressId) REFERENCES Adresses(Id), 
	FOREIGN KEY(EmployeeTypeId) REFERENCES EmployeeTypes(Id)
);
GO

CREATE PROCEDURE CreateEmployee
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

    INSERT INTO Employees (FullName, PhoneNumber, Email, EmployeeTypeId, AdressId) 
            VALUES (@FullName, @PhoneNumber, @Email, @FindedTypeID, @FindedAdressID);
GO

CREATE PROCEDURE DeleteEmployee
    @Id INT
AS   
    SET NOCOUNT ON;  
    DELETE FROM Employees  
    WHERE Id = @Id;
GO

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
GO

CREATE PROCEDURE ReadEmployeeById
    @Id INT
AS   
    SET NOCOUNT ON;  
    SELECT Employees.Id, FullName, PhoneNumber, Email, EmployeeTypes.Id, Title, Adresses.Id, Country, City, Street, HouseNum, ApartmentNum 
    FROM Employees 
    JOIN Adresses ON Employees.AdressId = Adresses.Id 
    JOIN EmployeeTypes ON Employees.EmployeeTypeId = EmployeeTypes.Id
    WHERE Employees.Id = @Id;
GO

CREATE PROCEDURE ReadEmployeesAll
AS   
    SET NOCOUNT ON;  
    SELECT Employees.Id, FullName, PhoneNumber, Email, EmployeeTypes.Id, Title, Adresses.Id, Country, City, Street, HouseNum, ApartmentNum 
    FROM Employees 
    JOIN Adresses ON Employees.AdressId = Adresses.Id 
    JOIN EmployeeTypes ON Employees.EmployeeTypeId = EmployeeTypes.Id;
GO

CREATE PROCEDURE ReadEmployeesByType
    @EmployeeType NVARCHAR(255)  
AS   
    SET NOCOUNT ON;  
    SELECT Employees.Id, FullName, PhoneNumber, Email, EmployeeTypeId, @EmployeeType, Adresses.Id, Country, City, Street, HouseNum, ApartmentNum 
    FROM Employees 
    JOIN Adresses ON Employees.AdressId = Adresses.Id
    WHERE EmployeeTypeId = (SELECT Id FROM EmployeeTypes WHERE EmployeeTypes.Title = @EmployeeType);
GO

CREATE PROCEDURE ReadEmployeeTypesAll
AS   
    SET NOCOUNT ON;  
    SELECT Id, Title
    FROM EmployeeTypes;
GO

INSERT INTO EmployeeTypes (Title) 
    VALUES (N'Äèðåêòîð'), (N'ÐÌ'), (N'ÒÌ'), (N'ÌÏ'), (N'ÒÀ');
GO