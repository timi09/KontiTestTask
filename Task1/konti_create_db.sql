/* ������� ���� */
CREATE DATABASE konti_test_db 
GO
USE konti_test_db
GO

/* ������� ������� �������� */
CREATE TABLE entities 
(
	ent_id INT UNIQUE NOT NULL, --��� �������
	ent_name NVARCHAR(255) NOT NULL --������������ �������
)
GO

/* ������� ������� ����� */
CREATE TABLE currency  
(
	prc_id INT UNIQUE NOT NULL, --��� ������
	prc_name NVARCHAR(255) NOT NULL --������� ������������ ������
)
GO

/* ������� ������� �����-������ */
CREATE TABLE prices 
(
	prl_id INT UNIQUE NOT NULL, --id �����-�����
	prc_id INT NOT NULL, --������� ���� ������� currency
	prl_name NVARCHAR(255) NOT NULL, --������������
	FOREIGN KEY(prc_id) REFERENCES currency(prc_id) --������ ������� ���� �� ������
)
GO

/* ������� ������� �������� �����-����� */
CREATE TABLE prc_contents 
(
	pk INT PRIMARY KEY NOT NULL, --��������� ����
	prl_id INT NOT NULL, --������� ���� ������� prices
	ent_id INT NOT NULL, --������� ���� ������� entities
	prc_date DATE NOT NULL, --���� ��������� ����
	prc_value FLOAT NOT NULL,--����
	FOREIGN KEY(prl_id) REFERENCES prices(prl_id), --������ ������� ���� �� �����-����
	FOREIGN KEY(ent_id) REFERENCES entities(ent_id) --������ ������� ���� �� ������
)
GO



