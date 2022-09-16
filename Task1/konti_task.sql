USE konti_test_db
GO

/* Создадим функцию чтобы переиспользовать код в Задании 1 и Задании 2*/
CREATE FUNCTION PricesObjects ()
RETURNS TABLE
AS RETURN 
(
	SELECT 
		prices.prl_name AS 'Название прайс-листа', 
		currency.prc_name AS 'Название валюты', 
		entities.ent_name AS 'Название объекта', 
		prc_contents.prc_date AS 'Дата установки цены', 
		prc_contents.prc_value AS 'Цена'
	FROM prc_contents 
		JOIN entities ON prc_contents.ent_id = entities.ent_id	
		JOIN prices ON prc_contents.prl_id = prices.prl_id
		JOIN currency ON prices.prc_id = currency.prc_id
);
GO

/* Задание 1
Вывести из базы информацию в следующем виде:
----------------------------------------------------------------------------------------
|Название прайс-листа | Название валюты | Название объекта | Дата установки цены | Цена|
----------------------------------------------------------------------------------------
*/
SELECT * FROM PricesObjects();
GO

/* Задание 2 
Найти объекты из конкретного прайс-листа (напр прайс России), у которых дата установки цены
меньше или равна текущей дате (название прайс-листа, название валюты, название объекта, дата, цена)
*/
SELECT * FROM PricesObjects() AS objs 
	WHERE objs.[Дата установки цены] <= CAST(GETDATE() AS Date) AND objs.[Название прайс-листа] = N'Прайс России';
GO

/* Задание 3 
Определить количество объектов из нескольких прайс-листов в разрезе прайс-листов на определенную дату
(отобразить код прайс-листа, наименование прайс-листа, дата установки цены, количество объектов)
*/
SELECT 
	prices.prl_id AS 'Код прайс-листа',
	prices.prl_name AS 'Название прайс-листа',
	prc_contents.prc_date AS 'Дата установки цены', 
	COUNT(1) AS 'Количество объектов'
FROM prc_contents JOIN prices ON prc_contents.prl_id = prices.prl_id
GROUP BY prices.prl_id, prices.prl_name, prc_contents.prc_date
GO

/* Задание 4 
Определить максимальную цену из прайс-листа «Прайс России», валюта руб на дату установки цены 01.10.2022г
*/
SELECT 
	MAX(prc_contents.prc_value) AS 'Максимальная цена за 01.10.2022г по прайс-листу «Прайс России», валюта руб'
FROM prc_contents JOIN prices ON prc_contents.prl_id = prices.prl_id
WHERE 
	prices.prl_name = N'Прайс России' 
	AND prices.prc_id = 1 --id валюты RUB, можно сделать join currency и искать по названию валюты currency.prc_name
	AND  prc_contents.prc_date = CAST('2022-10-01' AS Date)
GO

/* Задание 5 
Добавить в таблицу prc_contents новый объект для прайс-листа «Прайс России» (описать последовательность действий)
*/
INSERT INTO entities(ent_id, ent_name) VAlUES (6, N'Конфеты «Timi jam»') --сначала добавим объект, чтобы затем сослаться на него по внешнему ключу ent_id = 6
GO
INSERT INTO prc_contents(pk, prc_value, prc_date, ent_id, prl_id) --затем добавим объект прайс-листа
	VAlUES 
	(
		33, --pk - id нашего нового объекта прайс-листа
		35.0, --prc_value - цена нашего объекта прайс-листа
		'2022-08-21', --prc_date - дата установки цены
		6, --ent_id - внешний ключ ссылающийся на наш созданный выше объект 'Конфеты «Timi jam»' с ent_id = 6 из таблицы entities
		10 --prl_id - внешний ключ ссылающийся на прайс-лист «Прайс России» (у которого prl_id = 10, prl_name = 'Прайс России') из таблицы prices
	)
GO

/* Задание 6 
Удалить дублирующиеся записи из таблицы entities

***Примечание: так как на нашу таблицу entities через внешний ключ ссылаются другие таблицы
у нас не получится просто так удалить дублирующиеся строки в entities, ведь возможно удаляемая запись
"дубликат" связанна с записью из другой таблицы по внешнему ключу, поэтому придется:
	1) определить единственную оригинальную запись, в нашем случае с наименьшим id
	2) найти все записи из других таблиц, ссылающиеся на дубликаты нашей записи
	3) переопределить связи из других таблиц на нашу оригинальную запись
	4) удалить дубликаты
*/

SELECT * FROM entities; --посмотрим на таблицу, убедимся в наличии дубликатов
GO

/* находим оригиналы */
SELECT DISTINCT MIN(ent_id) AS orig_id, ent_name --берем по одному
INTO originals --вставляем в таблицу оригиналов
FROM entities 
GROUP BY ent_name --все записи, где ent_name повторяется
HAVING COUNT(ent_name) > 1 --больше чем один раз 

/* находим дубликаты */
SELECT DISTINCT ent_id as dup_id, ent_name
INTO duplicates --вставляем в таблицу дубликатов
FROM entities
WHERE entities.ent_name IN (SELECT ent_name FROM originals) --если имя есть в таблице оригиналов
AND entities.ent_id NOT IN (SELECT orig_id FROM originals) --и если это не сам оригинал, то это дубликат

SELECT dup_id, orig_id
INTO dup_orig --получаем отображение id дубликата -> id оригинала
FROM duplicates JOIN originals ON duplicates.ent_name = originals.ent_name

/* обновляем связи */
UPDATE prc_contents SET 
	ent_id = (SELECT orig_id FROM dup_orig WHERE dup_orig.dup_id = prc_contents.ent_id) --обновим связь, установим id оригинала
	WHERE ent_id IN (SELECT dup_id FROM dup_orig)--если id находится в списке дубликатов

/* удалим дубликаты */
DELETE FROM entities WHERE ent_id IN (SELECT dup_id FROM duplicates)

DROP TABLE originals, duplicates, dup_orig --удалим вспомогающие таблицы
GO

SELECT * FROM entities; --снова посмотрим на таблицу
GO