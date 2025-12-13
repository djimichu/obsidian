## PL/pgSQL. BEGIN - END

В чистом SQL мы не можем делать ряд вещей:
- Создавать переменные
- Нет процедурного языка
- Нет прогонки циклов и и не можем создавать развитую логику
- Выбрасывать исключения и т.д.

В PL/pgSQL:
- BEGIN / END - тело метода(не транзакции)
- Можем создавать переменные :=
- Прогон циклов и развитая логика
- Возврат значения через RETURN (вместо SELECT) или RETURN QUERY (в дополнение к SELECT)

> [!example]- `RETURN значение`
> ```sql
> CREATE OR REPLACE FUNCTION get_total_number_of_goods() RETURNS bigint AS $$
> BEGIN
> 	RETURN SUM(units_in_stock)
> 	FROM products;
> END;
> $$ LANGUAGE plpgsql;
> 
> SELECT get_total_number_of_goods();
> ```
> Сумма товаров в продаже
> **`RETURN значение`** — когда функция возвращает ОДНО значение

> [!example]- `RETURN значение` 2
> ```sql
> CREATE OR REPLACE FUNCTION get_max_price_discontinued() RETURNS AS real $$
> BEGIN
> 	RETURN MAX(units_in_stock)
> 	FROM products
> 	WHERE discontinued = 1;
> END;
> $$ LANGUAGE plpgsql;
> 
> SELECT get_total_number_of_goods()
> ```
> Максимальная цена товара в наличии
> **`RETURN значение`** — когда функция возвращает ОДНО значение

> [!example]- `SELECT ... INTO ...`
> 
> ```sql
> CREATE OR REPLACE FUNCTION get_price_boundaries(OUT max_price real, OUT min_price real) AS $$
> BEGIN
> 	SELECT MAX(unit_price), MIN(unit_price)
> 	INTO max_price, min_price
> 	FROM products;
> END;
> $$ LANGUAGE plpgsql
> ```
> Максимальная и минимальная цена товара 
> Если есть `OUT` параметры → `RETURN` не обязателен (автоматически в конце), с помощью `INTO` мы присваиваем нашим OUT параметрам значения указанные в SELECT 

> [!example]- `RETURN;`
> ```sql
> CREATE OR REPLACE FUNCTION get_sum(x int, y int, OUT result int) AS $$
> BEGIN
> 	result := x + y --присвоение через :=
> 	RETURN; -- можем не ставить, а можем поставить для наглядности
> END;
> $$ LANGUAGE plpgsql;
> 
> SELECT * FROM get_sum(2, 3); --5
> ```
> Результат суммы двух чисел
> **`RETURN;`** — когда функция использует `OUT` параметры

> [!example]-  `RETURN QUERY`
> ```sql
> CREATE OR REPLACE FUNCTION get_customer_by_country(customer_country varchar) RETURNS SETOF customers AS $$
> BEGIN
> 	RETURN QUERY
> 	SELECT *
> 	FROM customers
> 	WHERE country = customer_country;
> END;
> $$ LANGUAGE plpgsql;
> 
> SELECT * FROM get_customer_by_country('USA');
> ```
> Получим таблицу customers, где country 'USA' 
> **`RETURN QUERY`** — когда функция возвращает МНОГО строк, обычно таблицу


---

### Переменные. DECLARE.

> [!example]- `DECLARE`
> ```sql
> CREATE FUNCTION get_square(ab real, bc real, ac real) RETURNS real AS $$
> DECLARE
> 	perimeter real
> BEGIN
> 	perimeter = (ab + bc + ac) / 2
> 	return sqrt(perimeter * (perimeter-ab) * (perimeter-bc) * (perimeter - ac));
> END;
> $$ LANGUAGE plpgsql;
> 
> SELECT get_square(6, 6, 6);
> ```
> Тут мы просто для примера находим полупериметр  треугольника, а потом используя формулу Герона вычисляем площадь

> [!example]- `DECLARE` и процедуры
> ```sql
> CREATE FUNCTION calc_middle_price() RETURNS SETOF products AS $$
> DECLARE
> 	avg_price real;
> 	low_price real;
> 	high_price real;
> BEGIN
> 	SELECT AVG(unit_price) INTO avg_price
> 	FROM products;
> 	
> 	low_price = avg_price * 0.75;  -- это все процедуры
> 	high_price = avg_price * 1.25;
> 	
> 	RETURN QUERY
> 	SELECT * FROM products
> 	WHERE unit_price BETWEEN low_price AND high_price;
> END;
> $$ LANGUAGE plpgsql;
> ```
> Объявляем сразу функции, затем вычисляем среднее значение, а от него и два других. После делаем запрос по этим двум критериям


---

### Логические ветвления. IF, ELSE, ELSEIF.

> [!example]- Простое ветвление
> ```sql
> CREATE OR REPLACE FUNCTION convert_temp_to(temp real, to_celsium bool DEFAULT true)
> RETURNS real AS $$
> DECLARE
> 	result_temp real;
> BEGIN
> 	IF NOT to_celsium THEN
> 		result_temp = (1.8 * temp) + 32;
> 	ELSE
> 		result_temp = (temp - 32) / 1.8;
> 	END IF;
> 	
> 	RETURN result_temp;
> END;
> $$ LANGUAGE plpgsql;
> 
> SELECT convert_temp_to(80);
> SELECT convert_temp_to(26.67, false);
> ```
> 
> Конвертируем градусы по Цельсию в Фаренгейты и обратно используя логическое ветвление а зависимости от флага `to_celsium`

> [!example]- Добавляем ELSEIF
> ```sql
> CREATE OR REPLACE FUNCTION get_season(month_number int)
> RETURNS text AS $$
> DECLARE
> 	season text;
> BEGIN
> 	IF month_number BETWEEN 3 AND 5 THEN
> 		season = 'Spring';
> 	ELSEIF month_number BETWEEN 6 AND 8 THEN
> 		season = 'Summer';
> 	ELSEIF month_number BETWEEN 9 AND 11 THEN
> 		season = 'Autumn';
> 	ELSE
> 		season = 'Winter';
> 	END IF;
> 	
> 	RETURN result_temp;
> END;
> $$ LANGUAGE plpgsql;
> 
> SELECT get_season(12);
> SELECT get_season(3);
> ```
Проверяем время года от month_number, всё как в Go.

### Циклы. WHILE, LOOP, FOR, EXIT WHEN(breake).

1. `WHILE` expression
    ```sql
    WHILE expression
	LOOP 
		logic
	END LOOP;
-- код будет исполняться до тех пор, пока expression = true
    ```

---


2. `LOOP`
    ```sql
	LOOP
		EXIT WHEN expression
		logic
	END LOOP;
-- бесконечный цикл с возможностью выйти тогда, когда при expression = true
-- можно выйти и без условия, просто EXIT
   ```

---


3. `FOR` counter
	```sql
	FOR counter IN a..b [BY x]
	LOOP
		logic
	END LOOP;
	-- здесь мы указываем число итераций как в Go, а также можем регулировать шаг с помощью BY, пример: FOR counter IN 1..10 [BY 2]
	-- от одного до десяти с шагом два, то есть 5 итераций. 1, 3, 5, 7, 9
	
	FOR counter IN REVERSE a..b
	LOOP
		logic
	END LOOP;
	-- обратный цикл от b до a. REVERSE 5..1 -  5, 4, 3, 2, 1
	```

---


4. `CONTINUE WHEN` expression
	```sql
	CONTINUE WHEN expression
	-- переходим к следующей итерации пропуская всё что ниже
	```


> [!example]- Фибоначчи с WHILE expression
> ```sql
> CREATE OR REPLACE FUNCTION fib(n int) RETURNS int AS $$
> DECLARE
> 	counter int := 0;
> 	i int = 0;
> 	j int = 1;
> BEGIN
> 	IF n < 1 THEN
> 		RETURN 0;
> 	END IF;
> 	
> 	WHILE counter < n
> 	LOOP
> 		counter = counter + 1;
> 		SELECT j, i+j INTO i, j;
> 	END LOOP;
> 	
> 	RETURN i;
> END;
> $$ LANGUAGE plpgsql; 
> 
> SELECT fib(3);
> ```
> Продолжаем, пока counter меньше n  (0, 1, 2) - 3 итерации

> [!example]- Фибоначчи с LOOP и EXIT WHEN
> ```sql
> CREATE OR REPLACE FUNCTION fib(n int) RETURNS int AS $$
> DECLARE
> 	counter int := 0;
> 	i int = 0;
> 	j int = 1;
> BEGIN
> 	IF n < 1 THEN
> 		RETURN 0;
> 	END IF;
> 	
> 	LOOP
> 		EXIT WHEN counter = n;
> 		counter = counter + 1;
> 		SELECT j, i+j INTO i, j;
> 	END LOOP;
> 	
> 	RETURN i;
> END;
> $$ LANGUAGE plpgsql;
> 
> SELECT fib(3);
> ```
> Прекращаем когда counter равен n (0, 1, 2, 3(не прошло)) - 3 итерации


### Построчный процессинг. RETURN NEXT.

Сразу стоит сказать, что RETURN NEXT обычно мало где бывает нужен, и всё что написано с RETURN NEXT можно переписать и без него. Оно будет работать даже быстрее, чем с ним, однако понимание его работы может быть полезно.

- Иногда необходимо накапливать записи в результирующем наборе (построчный процессинг)
- `RETURN NEXT` *expression*

> [!example]- Пример RETURN NEXT
> ```sql
> CREATE FUNCTION return_ints() RETURNS SETOF int AS $$
> BEGIN
> 	RETURN NEXT 1;
> 	RETURN NEXT 2;
> 	RETURN NEXT 3;
> 	--RETURN;
> END;
> $$ LANGUAGE plpgsql;
> 
> SELECT * FROM return_ints();
> ```
> Получим колонку с числами 1, 2, 3


> [!example]- Еще один пример RETURN NEXT
> ```sql
> CREATE FUNCTION after_christmas_sale() RETURNS products AS $$
> DECLARE
> 	product record; --этот тип означает полную строку таблицы, все колонки
> BEGIN
> 	FOR product IN SELECT * FROM products
> 	LOOP
> 		IF product.category_id IN (1, 4, 8) THEN
> 			product.unit_price = product.unit_price * 0.8;
> 		ELSEIF product.category_id IN (2, 3, 7) THEN
> 			product.unit_price = product.unit_price * 0.75;
> 		ELSE
> 			product.unit_price = product.unit_price * 1.1;
> 		END IF;
> 		RETURN NEXT product; -- показательная строка кода
> 		END LOOP;
> END;
> $$ LANGUAGE plpgsql;
> 
> SELECT * FROM after_christmas_sale();
> ```
> 

Всё же его использовать не стоит, либо в крайних случаях