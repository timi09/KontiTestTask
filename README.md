# Задание 1

### Описание БД:

Таблица prices прайс-листы содержит следующие поля:

• prl_id – id прайс-листа

• prl_name - наименование

• prc_id – внешний ключ таблицы currency

</br>

Таблица prc_contents содержит объекты прайс-листа

• pk – первичный ключ

• prl_id – внешний ключ таблицы prices

• ent_id – внешний ключ таблицы entities

• prc_date – дата установки цены

• prc_value – цена

</br>

Таблица entities – объекты

• ent_id – код объекта

• ent_name – наименование объекта

</br>

Таблица currency - валюты

• prc_id – код валюты

• prc_name – краткое наименование валюты


### Задание.
• Вывести из базы информацию в следующем виде:

```
------------------------------------------------------------------------------------------
| Название прайс-листа | Название валюты | Название объекта | Дата установки цены | Цена |
------------------------------------------------------------------------------------------
```

Пример:

```
------------------------------------------------------------------
| Прайс России | руб | Печенье супер-контик | 01.01.2021 | 10.54 |
------------------------------------------------------------------
```

1. Найти объекты из конкретного прайс-листа (напр прайс России), у которых дата установки
цены меньше или равна текущей дате (название прайс-листа, название валюты, название
объекта, дата, цена)

2. Определить количество объектов из нескольких прайс-листов в разрезе прайс-листов на
определенную дату (отобразить код прайс-листа, наименование прайс-листа, дата
установки цены, количество объектов)

3. Определить максимальную цену из прайс-листа «прайс России», валюта руб на дату
установки цены 01.10.2022г.

4. Добавить в таблицу prc_contents новый объект для прайс-листа «Прайс России» (описать
последовательность действий)

5. Удалить дублирующиеся записи из таблицы entities

### Требования

Решение представить в виде набора файлов *.sql – cкрипты на T-SQL, исполняемые в
Microsoft SQL Server Management Studio.

a. Создание структуры

b. Наполнение тестовыми данными

c. Решение задачи

</br>

# Задание 2

Необходимо разработать web приложение со следующим функционалом:

1. Рабочее окно состоит из списка сотрудников

2. Список полей таблицы: ID, ФИО, Телефон, Адрес, E-mail, Тип сотрудника (выпадающий
список).

Типы сотрудников:

    1) Директор.
    
    2) РМ (региональный менеджер).
    
    3) ТМ (территориальный менеджер).
    
    4) МП (менеджер продаж).
    
    5) ТА (Торговый агент).

3. Реализовать CRUD операции над справочником с использованием хранимых процедур
БД.

4. Реализовать фильтр по полю тип сотрудника.

5. Предусмотреть возможность экспорта справочника в MS Excel.

При разработке использовать:
- в качестве СУБД – MS SQL Server (версия не важна)
- язык программирования  - C# ASP.NET MVC или Web Forms

В качестве решения прислать проект приложения и sql файлы экспорта таблиц и процедур.
