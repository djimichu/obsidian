# Всё о функциях в SQL.

[[learn/00. postgreSQL/07. Функции SQL/Введение|Введение]]

[[Простые функций]]
[[Функции с аргументами]]
[[Возврат набора данных]]
[[PL.pgSQL|PL/pgSQL]] - самая большая тема по функциям


---

> [!question]- Задачи по функциям
> 
> > [!example]- Задание  №1
> > 1. Создайте функцию, которая делает бэкап таблицы customers (копирует все данные в другую таблицу), предварительно стирая таблицу для бэкапа, если такая уже существует (чтобы в случае многократного запуска таблица для бэкапа перезатиралась).
> 
> > [!example]- Задание  №2
> > 2. Создать функцию, которая возвращает средний фрахт (freight) по всем заказам
> 
> > [!example]- Задание  №3
> > 3. Написать функцию, которая принимает два целочисленных параметра, используемых как нижняя и верхняя границы для генерации случайного числа в пределах этой границы (включая сами граничные значения).
> > 
> > 	 - Функция random генерирует вещественное число от 0 до 1.
> > 
> > 	 - Необходимо вычислить разницу между границами и прибавить единицу.
> > 
> > 	 - На полученное число умножить результат функции random() и прибавить к результату значение нижней границы.
> > 
> > 	 - Применить функцию floor() к конечному результату, чтобы не "уехать" за границу и получить целое число.
> 
> > [!example]- Задание  №4
> > 4. Создать функцию, которая возвращает самые низкую и высокую зарплаты среди сотрудников заданного города
> 
> > [!example]- Задание  №5
> > 5. Создать функцию, которая корректирует зарплату на заданный процент,  но не корректирует зарплату, если её уровень превышает заданный уровень при этом верхний уровень зарплаты по умолчанию равен 70, а процент коррекции равен 15%.
> 
> > [!example]- Задание  №6
> > 6. Модифицировать функцию, корректирующую зарплату таким образом, чтобы в результате коррекции, она так же выводила бы изменённые записи.
> 
> > [!example]- Задание  №7
> > 7. Модифицировать предыдущую функцию так, чтобы она возвращала только колонки last_name, first_name, title, salary
> 
> > [!example]- Задание  №8
> > 8. Написать функцию, которая принимает метод доставки и возвращает записи из таблицы orders в которых freight меньше значения, определяемого по следующему алгоритму:
> > 
> > 	- ищем максимум фрахта (freight) среди заказов по заданному методу доставки
> > 	
> > 	- корректируем найденный максимум на 30% в сторону понижения
> > 	
> > 	- вычисляем среднее значение фрахта среди заказов по заданному методому доставки
> > 	
> > 	- вычисляем среднее значение между средним найденным на предыдущем шаге и скорректированным максимумом
> > 	
> > 	- возвращаем все заказы в которых значение фрахта меньше найденного на предыдущем шаге среднего
> > 
> 
> > [!example]- Задание  №9
> > 9. Написать функцию, которая принимает:
> > 
> > 	уровень зарплаты, максимальную зарплату (по умолчанию 80) минимальную зарплату (по умолчанию 30), коээфициет роста зарплаты (по умолчанию 20%)
> > 	
> > 	Если зарплата выше минимальной, то возвращает false
> > 	
> > 	Если зарплата ниже минимальной, то увеличивает зарплату на коэффициент роста и проверяет не станет ли зарплата после повышения превышать максимальную.
> > 	
> > 	Если превысит - возвращает false, в противном случае true.
> > 	
> > 	Проверить реализацию, передавая следующие параметры
> > 	
> > 	(где c - уровень з/п, max - макс. уровень з/п, min - минимальный уровень з/п, r - коэффициент):
> > 	
> > 	c = 40, max = 80, min = 30, r = 0.2 - должна вернуть false
> > 	
> > 	c = 79, max = 81, min = 80, r = 0.2 - должна вернуть false
> > 	
> > 	c = 79, max = 95, min = 80, r = 0.2 - должна вернуть true

> [!success]- Решение задач
> 
> > [!example]- Решение задачи №1
> > ```sql
> > CREATE OR REPLACE FUNCTION backup_customers() RETURNS void AS $$
> > 	DROP TABLE IF EXISTS copy_customers;
> > 	
> > 	CREATE TABLE copy_customers AS
> > 	SELECT * FROM customers;
> > 
> > $$ LANGUAGE sql;
> > 
> > SELECT backup_customers()
> > 
> > SELECT * FROM copy_customers
> > ```
> > Тут строки создания и получения объединяются благодаря AS, и мы полностью получаем копию таблицы из SELECT
> 
> > [!example]- Решение задачи №2
> > ```sql
> > CREATE OR REPLACE FUNCTION avg_freight_ord() RETURNS float8 AS $$
> > 	SELECT AVG(freight) FROM orders;
> > $$ LANGUAGE sql;
> > 
> > SELECT avg_freight_ord()
> > -- функция AVG всегда возвращает float8
> > ```
> 
> > [!example]- Решение задачи №3
> > ```sql
> > CREATE OR REPLACE FUNCTION rand_int(upp int, low int) RETURNS real AS $$
> > DECLARE
> > 	result_int real;
> > 	start_int float8 = RANDOM();
> > 	diff_upp_low int;
> > BEGIN
> > 	diff_upp_low = upp - low + 1;
> > 	result_int = diff_upp_low * start_int + low;
> > 	RETURN FLOOR(result_int);
> > END;
> > $$ LANGUAGE plpgsql;
> > 
> > SELECT rand_int(1000, 970)
> > FROM generate_series(1, 10) -- вызвать сразу 10 раз
> > ```
> 
> > [!example]- Решение задачи №4
> > ```sql
> > CREATE OR REPLACE FUNCTION max_min_salary_in_city
> > (
> > 	city_arg varchar,
> > 	OUT max_sal  numeric,
> > 	OUT min_sal numeric
> > ) AS $$
> > 
> > SELECT MAX(salary), MIN(salary)
> > FROM employees
> > WHERE city = city_arg;
> > 
> > $$ LANGUAGE SQL;
> > 
> > SELECT * FROM max_min_salary_in_city('London')
> > ```
> > 
> 
> > [!example]- Решение задачи №5
> > ```sql
> > CREATE OR REPLACE FUNCTION max_min_salary_in_city
> > (
> > 	level_salary numeric DEFAULT 70,
> > 	percentage numeric DEFAULT 0.15
> > ) RETURNS VOID AS $$
> > 
> > 	UPDATE employees
> > 	SET salary = salary * (1 + percentage)
> > 	WHERE salary <= level_salary;
> > 
> > $$ LANGUAGE sql;
> > 
> > SELECT max_min_salary_in_city(120, 100);
> > 
> > SELECT city, salary
> > FROM employees
> > ```
> > 
> 
> > [!example]- Решение задачи №6()
> > ```sql
> > 
> > ```
> > 
> 
> > [!example]- Решение задачи №7
> > ```sql
> > CREATE OR REPLACE FUNCTION max_min_salary_in_city_return_table
> > (
> > 	level_salary numeric DEFAULT 70,
> > 	percentage numeric DEFAULT 0.15
> > ) RETURNS TABLE (
> > 	last_name text,
> > 	first_name text,
> > 	title text,
> > 	salary numeric
> > ) AS $$
> > 
> > 	UPDATE employees
> > 	SET salary = salary * (1 +percentage)
> > 	WHERE salary <= level_salary
> > 	RETURNING last_name, first_name, title, salary;
> > 
> > $$ LANGUAGE sql;
> > 
> > SELECT * FROM max_min_salary_in_city_return_table(50, 25);
> > ```
> > 
> 
> > [!example]- Решение задачи №8
> > ```sql
> > CREATE OR REPLACE FUNCTION get_orders_avarage_freight
> > (
> > 	ship_method int
> > ) RETURNS SETOF orders AS $$
> > DECLARE
> > 	max_freight real;
> > 	avg_feight real;
> > 	max_avg_freight real;
> > BEGIN
> > 	SELECT MAX(freight), AVG(freight)
> > 	INTO max_freight, avg_feight
> > 	FROM orders
> > 	WHERE ship_via = ship_method;
> > 	
> > 	max_freight = max_freight * 0.7;
> > 	max_avg_freight = (max_freight + avg_feight) / 2;
> > 	
> > 	RETURN QUERY
> > 	SELECT *
> > 	FROM orders
> > 	WHERE freight < max_avg_freight AND ship_via = ship_method;
> > END;
> > $$ LANGUAGE plpgsql;
> > 
> > SELECT * FROM get_orders_avarage_freight(3);
> > ```
> 
> > [!example]- Решение задачи №9
> > ```sql
> > CREATE OR REPLACE FUNCTION is_low_salary
> > (
> > 	salary real,
> > 	max_salary real DEFAULT 80,
> > 	min_salary real DEFAULT 30,
> > 	coefficient real DEFAULT 0.2
> > ) RETURNS bool AS $$
> > BEGIN
> > 	IF coefficient > 1 THEN
> > 		RETURN false;
> > 	END IF;
> > 	
> > 	IF salary > min_salary THEN
> > 		RETURN false;
> > 	ELSEIF 	salary < min_salary THEN
> > 		salary = salary * (1 + coefficient);
> > 		IF salary > max_salary THEN
> > 			RETURN false;
> > 		ELSE 
> > 			RETURN true;
> > 		END IF;
> > 	END IF;
> > END;
> > $$ LANGUAGE plpgsql;
> > 
> > SELECT is_low_salary(79, 95, 80, 0.2);
> > ```
> 