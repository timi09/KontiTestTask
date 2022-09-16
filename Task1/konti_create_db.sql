/* Создаем базу */
CREATE DATABASE konti_test_db 
GO
USE konti_test_db
GO

/* Создаем таблицу объектов */
CREATE TABLE entities 
(
	ent_id INT UNIQUE NOT NULL, --код объекта
	ent_name NVARCHAR(255) NOT NULL --наименование объекта
)
GO

/* Создаем таблицу валют */
CREATE TABLE currency  
(
	prc_id INT UNIQUE NOT NULL, --код валюты
	prc_name NVARCHAR(255) NOT NULL --краткое наименование валюты
)
GO

/* Создаем таблицу прайс-листов */
CREATE TABLE prices 
(
	prl_id INT UNIQUE NOT NULL, --id прайс-листа
	prc_id INT NOT NULL, --внешний ключ таблицы currency
	prl_name NVARCHAR(255) NOT NULL, --наименование
	FOREIGN KEY(prc_id) REFERENCES currency(prc_id) --задаем внешний ключ на валюту
)
GO

/* Создаем таблицу объектов прайс-листа */
CREATE TABLE prc_contents 
(
	pk INT PRIMARY KEY NOT NULL, --первичный ключ
	prl_id INT NOT NULL, --внешний ключ таблицы prices
	ent_id INT NOT NULL, --внешний ключ таблицы entities
	prc_date DATE NOT NULL, --дата установки цены
	prc_value FLOAT NOT NULL,--цена
	FOREIGN KEY(prl_id) REFERENCES prices(prl_id), --задаем внешний ключ на прайс-лист
	FOREIGN KEY(ent_id) REFERENCES entities(ent_id) --задаем внешний ключ на объект
)
GO



