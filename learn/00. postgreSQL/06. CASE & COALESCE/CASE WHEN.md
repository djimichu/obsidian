## CASE WHEN

```sql
CASE
	WHEN condition_1 THEN result_1
	WHEN condition_2 THEN result_2
	[WHEN...]
	[ELSE result_n]
END
```

- condition - условие, возвращающее bool
- result - результат или действие в случае с pgSQL

Если простыми словами, то мы можем делать аналог switch, по условиям совершать какие-либо действия.

> [!example]
> 
> ```sql
> SELECT product_name, unit_price, units_in_stock,
> 	CASE WHEN units_in_stock >= 100 THEN 'lots of'
> 		 WHEN units_in_stock >= 50 AND units_in_stock < 100 THEN 'average'
> 		 WHEN units_in_stock < 50 THEN 'low number'
> 		 ELSE 'unknown'
> 	END AS amount
> FROM products
> ORDER BY units_in_stock DESC;
> ```
> В этом примере мы используем CASE как 4 колонку нашего SELECT, она будет вписывать значения 'lots of', 'average' или 'low number' в зависимости от кол-ва товаров на складе

> [!example] Узнаем время года:
> ```sql
> SELECT order_id, order_date,
> 	CASE WHEN date_part('month', order_date) BETWEEN 3 and 5 THEN 'spring'
> 		 WHEN date_part('month', order_date) BETWEEN 6 and 8 THEN 'summer'
> 		 WHEN date_part('month', order_date) BETWEEN 9 and 11 THEN 'autumn'
> 		 ELSE 'winter'
> 	END AS season
> FROM orders
> ```
> Тут мы по таблице orders узнаем, в какое время года был заказ, пример как и первый используется как доп. колонка в SELECT


