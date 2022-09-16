USE konti_test_db
GO

/* �������� ������� ����� ���������������� ��� � ������� 1 � ������� 2*/
CREATE FUNCTION PricesObjects ()
RETURNS TABLE
AS RETURN 
(
	SELECT 
		prices.prl_name AS '�������� �����-�����', 
		currency.prc_name AS '�������� ������', 
		entities.ent_name AS '�������� �������', 
		prc_contents.prc_date AS '���� ��������� ����', 
		prc_contents.prc_value AS '����'
	FROM prc_contents 
		JOIN entities ON prc_contents.ent_id = entities.ent_id	
		JOIN prices ON prc_contents.prl_id = prices.prl_id
		JOIN currency ON prices.prc_id = currency.prc_id
);
GO

/* ������� 1
������� �� ���� ���������� � ��������� ����:
----------------------------------------------------------------------------------------
|�������� �����-����� | �������� ������ | �������� ������� | ���� ��������� ���� | ����|
----------------------------------------------------------------------------------------
*/
SELECT * FROM PricesObjects();
GO

/* ������� 2 
����� ������� �� ����������� �����-����� (���� ����� ������), � ������� ���� ��������� ����
������ ��� ����� ������� ���� (�������� �����-�����, �������� ������, �������� �������, ����, ����)
*/
SELECT * FROM PricesObjects() AS objs 
	WHERE objs.[���� ��������� ����] <= CAST(GETDATE() AS Date) AND objs.[�������� �����-�����] = N'����� ������';
GO

/* ������� 3 
���������� ���������� �������� �� ���������� �����-������ � ������� �����-������ �� ������������ ����
(���������� ��� �����-�����, ������������ �����-�����, ���� ��������� ����, ���������� ��������)
*/
SELECT 
	prices.prl_id AS '��� �����-�����',
	prices.prl_name AS '�������� �����-�����',
	prc_contents.prc_date AS '���� ��������� ����', 
	COUNT(1) AS '���������� ��������'
FROM prc_contents JOIN prices ON prc_contents.prl_id = prices.prl_id
GROUP BY prices.prl_id, prices.prl_name, prc_contents.prc_date
GO

/* ������� 4 
���������� ������������ ���� �� �����-����� ������ ������, ������ ��� �� ���� ��������� ���� 01.10.2022�
*/
SELECT 
	MAX(prc_contents.prc_value) AS '������������ ���� �� 01.10.2022� �� �����-����� ������ ������, ������ ���'
FROM prc_contents JOIN prices ON prc_contents.prl_id = prices.prl_id
WHERE 
	prices.prl_name = N'����� ������' 
	AND prices.prc_id = 1 --id ������ RUB, ����� ������� join currency � ������ �� �������� ������ currency.prc_name
	AND  prc_contents.prc_date = CAST('2022-10-01' AS Date)
GO

/* ������� 5 
�������� � ������� prc_contents ����� ������ ��� �����-����� ������ ������ (������� ������������������ ��������)
*/
INSERT INTO entities(ent_id, ent_name) VAlUES (6, N'������� �Timi jam�') --������� ������� ������, ����� ����� ��������� �� ���� �� �������� ����� ent_id = 6
GO
INSERT INTO prc_contents(pk, prc_value, prc_date, ent_id, prl_id) --����� ������� ������ �����-�����
	VAlUES 
	(
		33, --pk - id ������ ������ ������� �����-�����
		35.0, --prc_value - ���� ������ ������� �����-�����
		'2022-08-21', --prc_date - ���� ��������� ����
		6, --ent_id - ������� ���� ����������� �� ��� ��������� ���� ������ '������� �Timi jam�' � ent_id = 6 �� ������� entities
		10 --prl_id - ������� ���� ����������� �� �����-���� ������ ������ (� �������� prl_id = 10, prl_name = '����� ������') �� ������� prices
	)
GO

/* ������� 6 
������� ������������� ������ �� ������� entities

***����������: ��� ��� �� ���� ������� entities ����� ������� ���� ��������� ������ �������
� ��� �� ��������� ������ ��� ������� ������������� ������ � entities, ���� �������� ��������� ������
"��������" �������� � ������� �� ������ ������� �� �������� �����, ������� ��������:
	1) ���������� ������������ ������������ ������, � ����� ������ � ���������� id
	2) ����� ��� ������ �� ������ ������, ����������� �� ��������� ����� ������
	3) �������������� ����� �� ������ ������ �� ���� ������������ ������
	4) ������� ���������
*/

SELECT * FROM entities; --��������� �� �������, �������� � ������� ����������
GO

/* ������� ��������� */
SELECT DISTINCT MIN(ent_id) AS orig_id, ent_name --����� �� ������
INTO originals --��������� � ������� ����������
FROM entities 
GROUP BY ent_name --��� ������, ��� ent_name �����������
HAVING COUNT(ent_name) > 1 --������ ��� ���� ��� 

/* ������� ��������� */
SELECT DISTINCT ent_id as dup_id, ent_name
INTO duplicates --��������� � ������� ����������
FROM entities
WHERE entities.ent_name IN (SELECT ent_name FROM originals) --���� ��� ���� � ������� ����������
AND entities.ent_id NOT IN (SELECT orig_id FROM originals) --� ���� ��� �� ��� ��������, �� ��� ��������

SELECT dup_id, orig_id
INTO dup_orig --�������� ����������� id ��������� -> id ���������
FROM duplicates JOIN originals ON duplicates.ent_name = originals.ent_name

/* ��������� ����� */
UPDATE prc_contents SET 
	ent_id = (SELECT orig_id FROM dup_orig WHERE dup_orig.dup_id = prc_contents.ent_id) --������� �����, ��������� id ���������
	WHERE ent_id IN (SELECT dup_id FROM dup_orig)--���� id ��������� � ������ ����������

/* ������ ��������� */
DELETE FROM entities WHERE ent_id IN (SELECT dup_id FROM duplicates)

DROP TABLE originals, duplicates, dup_orig --������ ������������ �������
GO

SELECT * FROM entities; --����� ��������� �� �������
GO