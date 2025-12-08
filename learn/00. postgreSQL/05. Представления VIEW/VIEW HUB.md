# Всё о представлениях View

1. [[learn/00. postgreSQL/05. Представления VIEW/Введение|Введение]]
2. [[Создание представлений]] - как создать вьюху
3. [[Изменения]] - как изменяются вьюхи, их ограничения
4. [[Обновляемые представления]] - как обновлять 
5. [[Опция CHECK]] - как избегать вставки данных не соответствующих вьюхе.






---

> [!question]- Задачи по View
> 
> > [!example]- Задача 1
> > 1. Создать представление, которое выводит следующие колонки:
> > 
> > order_date, required_date, shipped_date, ship_postal_code, company_name, contact_name, phone, last_name, first_name, title из таблиц orders, customers и employees.
> > 
> > - Сделать select к созданному представлению, выведя все записи, где order_date больше 1го января 1997 года.
> 
> > [!example]- Задача 2
> > 2. Создать представление, которое выводит следующие колонки:
> > 
> > order_date, required_date, shipped_date, ship_postal_code, ship_country, company_name, contact_name, phone, last_name, first_name, title из таблиц orders, customers, employees.
> > 
> > - Попробовать добавить к представлению (после его создания) колонки ship_country, postal_code и reports_to. Убедиться, что проихсодит ошибка. Переименовать представление и создать новое уже с дополнительными колонками.
> > 
> > - Сделать к нему запрос, выбрав все записи, отсортировав их по ship_county.
> > 
> > - Удалить переименованное представление.
> > 
> 
> > [!example]- Задача 3
> > 
> > 3. Создать представление "активных" (discontinued = 0) продуктов, содержащее все колонки. Представление должно быть защищено от вставки записей, в которых discontinued = 1.
> > 
> > - Попробовать сделать вставку записи с полем discontinued = 1 - убедиться, что не проходит.
> 

> [!success]- Решения
> 
> > [!example]- Задача 1
> > ```sql
> > CREATE OR REPLACE VIEW ord_cus_emp AS
> > SELECT order_date, required_date, shipped_date, ship_postal_code,
> > company_name, contact_name, phone, last_name, first_name, title
> > FROM orders
> > JOIN customers USING(customer_id)
> > JOIN employees USING(employee_id);
> > 
> > 
> > SELECT * FROM ord_cus_emp
> > WHERE order_date > '1997-01-01'
> > ORDER BY order_date;
> > ```
> 
> > [!example]- задача 2
> > ```sql
> > ALTER VIEW ord_cus_emp RENAME TO o_c_e;
> > --или
> > DROP VIEW ord_cus_emp;
> > 
> > CREATE OR REPLACE VIEW ord_cus_emp AS
> > SELECT order_date, required_date, shipped_date, ship_postal_code,
> > 		ship_country, 
> > 	company_name, contact_name, phone, c.postal_code,
> > 	last_name, first_name, e.title, e.reports_to
> > FROM orders
> > JOIN customers AS c USING(customer_id)
> > JOIN employees AS e USING(employee_id);
> > 
> > SELECT *
> > FROM ord_cus_emp
> > ORDER BY ship_country;
> > 
> > DROP VIEW ord_cus_emp;
> > ```
> 
> > [!example]- Задача 3
> > ```sql
> > CREATE OR REPLACE VIEW prod_view AS
> > SELECT *
> > FROM products
> > WHERE discontinued = 0
> > WITH LOCAL CHECK OPTION;
> > 
> > SELECT *
> > FROM prod_view;
> > 
> > SELECT *
> > FROM products;
> > 
> > INSERT INTO prod_view (product_name, supplier_id, category_id,
> > 		quantity_per_unit, unit_price, units_in_stock,
> > 		 units_on_order, reorder_level, discontinued)
> > VALUES ('Banana', 3, 1, '10kg', 100, 25, 37, 10, 1);
> > ```


