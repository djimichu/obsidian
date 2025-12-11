## COALESCE и NULLIF

Помимо тех двух функций, что мы разобрали, есть еще две, позволяющие ветвить логику.

- COALESCE(arg1, arg2, ...) - вернет [^1]первый аргумент, который != null, если все
	аргументы = null, то вернет null
	- Используется, чтобы налету поменять значение с null, на какое нам удобно, передаем в arg2

- NULLIF(arg1, arg2) - сравнивает два аргумента, и если они равны, то вернет null, а если не равны, вернет arg1

К примерам.

> [!example] COALESCE
> ```sql
> SELECT order_id, order_date, COALESCE(ship_region, 'unknown') AS ship_region
> FROM orders
> LIMIT 10
> ```
> Хотим получить ID, дату и регион заказов, но если регион = null, то запишем в эту колонку 'unknown'

> [!example]- Еще один пример
> ```sql
> SELECT last_name, first_name, COALESCE(region, 'not region') as region
> FROM employees;
> ```
> Если регион не указан, в нашу колонку region также запишем 'not region'

> То есть COALESCE подменяет данные, в случае если значение не указано(null)
> NULLIF же работает иначе, мы можем заменить ненужное нам значение на null, то есть как раз для нашего COALESCE. За счет их смежной работы, мы можем менять значения как нам угодно.

Например, нам надо исправить пустую строку. Как мы знаем, [^2] '' != null. Значит COALESCE нам уже не поможет изменить данные. Но и NULLIF не меняет данные, он сравнивает. Следовательно мы можем использовать их в симбиозе. Сравнить NULLIF(значение, ''), и если вернет null, то заменить с помощью COALESCE:
```sql
SELECT contact_name, COALESCE(NULLIF(city, ''), 'not city') AS city
FROM customers
```

> [!tip]- Подробное объяснение
> Мы хотим получить имя и город из условной таблицы. Мы берем имя, а в городе допустим много пропусков (null), нам надо эти null'ы заменить на 'not city', мы создаем с помощью AS city новую колонку в результирующем наборе, и в случае, если NULLIF скажет, что данных нет, то COALESCE запишет в нашу колонку 'not city'. Если же city != null, то NULLIF вернет название этого города и COALESCE запишет его в нашу колонку. Мб звучит тяжело, но тут всё на самом деле легко понять.


---

> [!question]- Создадим новую таблицу и вставим данные
> ```sql
> CREATE TABLE budget
> (
> 	dept serial,
> 	current_year decimal,
> 	previous_year decimal
> );
> INSERT INTO budget (current_year, previous_year) VALUES(100000, 150000);
> INSERT INTO budget (current_year, previous_year) VALUES(NULL, 300000);
> INSERT INTO budget (current_year, previous_year) VALUES(0, 100000);
> INSERT INTO budget (current_year, previous_year) VALUES(NULL, 150000);
> INSERT INTO budget (current_year, previous_year) VALUES(300000, 250000);
> INSERT INTO budget (current_year, previous_year) VALUES(170000, 170000);
> INSERT INTO budget (current_year, previous_year) VALUES(150000, null);
> ```

> Наша задача - сравнить зпшки прошлого года и текущего года, если зп одинаковая - вернем 'same as last year', если нет, ничего не вернуть.

> [!example]-  Теперь пример
> 
> ```sql
> SELECT dept, COALESCE(NULLIF(current_year, previous_year)::TEXT,
> 	'same as last year') AS string
> FROM budget
> WHERE current_year IS NOT NULL
> 
> -- по сути это то же что и:
> 
> CASE 
>     WHEN current_year = previous_year THEN 'same as last year'
>     ELSE current_year::TEXT
> END
> -- на деле этот вариант даже предпочтительней
> ```
> Первая проблема: у нас NULLIF возвращает current_year, у него тип - *decimal*, а COALESCE ожидает строку. 
> Для этого придется воспользоваться **::TEXT**, приводим decimal к TEXT
> Также в наглядность я привел пример решения методом из прошлой темы и на самом деле, так даже лучше решать


[^2]:  пустая строка: ''

[^1]: первый попавшийся аргумент, то есть тот аргумент, который будет стоять первее

---

> [!question]- Задачи по теме
> 
> > [!example]- Задание 1
> > 1. Выполните следующий код (записи необходимы для тестирования корректности выполнения ДЗ):
> > 
> > ```sql
> > insert into customers(customer_id, contact_name, city, country, company_name)
> > values 
> > ('AAAAA', 'Alfred Mann', NULL, 'USA', 'fake_company'),
> > ('BBBBB', 'Alfred Mann', NULL, 'Austria','fake_company');
> > ```
> > 
> > После этого выполните задание:
> > 
> > Вывести имя контакта заказчика, его город и страну, отсортировав по возрастанию по имени контакта и городу,
> > 
> > а если город равен NULL, то по имени контакта и стране. Проверить результат, используя заранее вставленные строки.
> 
> > [!example]- Задание 2
> > 2. Вывести наименование продукта, цену продукта и столбец со значениями
> > 
> > too expensive если цена >= 100
> > 
> > average если цена >=50 но < 100
> > 
> > low price если цена < 50
> > 
> 
> > [!example]- Задание 3
> > 3. Найти заказчиков, не сделавших ни одного заказа. Вывести имя заказчика и значение 'no orders' если order_id = NULL.
> 
> > [!example]- Задание 4
> > 1. Вывести ФИО сотрудников и их должности. В случае если должность = Sales Representative вывести вместо неё Sales Stuff.

> [!success]- Решение задач
> 
> > [!example]- Решение 1
> > ```sql
> > SELECT contact_name, city, country
> > FROM customers
> > ORDER BY contact_name, 
> > (
> > 	CASE WHEN city IS null THEN  country
> > 	ELSE city
> > 	END
> > )
> > ```
> 
> > [!example]- Решение 2
> > ```sql
> > SELECT product_name, unit_price,
> > (
> > 	CASE
> > 		WHEN unit_price >= 100 THEN 'too expensive'
> > 		WHEN unit_price >= 50 AND unit_price < 100 THEN 'average '
> > 		ELSE'low price'
> > 	END 	
> > ) AS string
> > FROM products
> > ORDER BY unit_price
> > ```
> 
> > [!example]- Решение 3
> > ```sql
> > SELECT contact_name, COALESCE(order_id::TEXT, 'no orders') AS orders
> > FROM customers
> > LEFT JOIN orders USING(customer_id)
> > WHERE order_id IS NULL
> > ```
> > 
> 
> > [!example]- Решение 4
> > ```sql
> > SELECT CONCAT(first_name, ' ', last_name),
> > 	COALESCE(NULLIF(title, 'Sales Representative'), 'Sales Stuff') AS title_emp
> > FROM employees
> > --Важно первым аргументов ставить то, что мы хотим вывести: title, 'arg2'
> > ```
> > 


