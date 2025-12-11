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
```sql
CREATE OR REPLACE FUNCTION get_total_number_of_goods() RETURNS bigint AS $$
BEGIN
	RETURN SUM(units_in_stock)
	FROM products;
END;
$$ LANGUAGE plpgsql;

SELECT get_total_number_of_goods();
```
Сумма товаров в продаже
**`RETURN значение`** — когда функция возвращает ОДНО значение

```sql
CREATE OR REPLACE FUNCTION get_max_price_discontinued() RETURNS AS real $$
BEGIN
	RETURN MAX(units_in_stock)
	FROM products
	WHERE discontinued = 1;
END;
$$ LANGUAGE plpgsql;

SELECT get_total_number_of_goods()
```
Максимальная цена товара в наличии
**`RETURN значение`** — когда функция возвращает ОДНО значение

```sql
CREATE OR REPLACE FUNCTION get_price_boundaries(OUT max_price real, OUT min_price real) AS $$
BEGIN
	SELECT MAX(unit_price), MIN(unit_price)
	INTO max_price, min_price
	FROM products;
END;
$$ LANGUAGE plpgsql
```
Максимальная и минимальная цена товара 
Если есть `OUT` параметры → `RETURN` не обязателен (автоматически в конце), пишем `INTO`

```sql
CREATE OR REPLACE FUNCTION get_sum(x int, y int, OUT result int) AS $$
BEGIN
	result := x + y
	RETURN; -- можем не ставить, а можем поставить для наглядности
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_sum(2, 3); --5
```
Результат суммы двух чисел
**`RETURN;`** — когда функция использует `OUT` параметры

```sql
CREATE OR REPLACE FUNCTION get_customer_by_country(customer_country varchar) RETURNS SETOF customers AS real $$
BEGIN
	RETURN QUERY
	SELECT *
	FROM customers
	WHERE country = customer_country;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_customer_by_country('USA');
```
Получим таблицу customers, где country 'USA' 
**`RETURN QUERY`** — когда функция возвращает МНОГО строк