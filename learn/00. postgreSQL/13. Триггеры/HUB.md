# Триггеры HUB

> [!success]- Построчный триггер
> ```sql
> ALTER TABLE customers
> ADD COLUMN last_updated timestamp;
> 
> CREATE OR REPLACE FUNCTION customers_timestamp()
> RETURNS TRIGGER AS $$
> BEGIN
> 	NEW.last_updated = NOW();
> 	RETURN NEW;
> END;
> $$ LANGUAGE plpgsql;
> 
> CREATE TRIGGER trigger_customer_update
> 	BEFORE INSERT OR UPDATE ON customers
> 	FOR EACH ROW EXECUTE FUNCTION customers_timestamp();
> 
> SELECT * FROM customers	
> WHERE customer_id = 'ALFKI'
> 
> UPDATE customers
> SET contact_name = 'Vladimir' WHERE customer_id = 'ALFKI'
> ```


> [!success]- Решение 1
> ```sql
> ALTER TABLE products
> ADD COLUMN last_updated timestamp;
> 
> CREATE OR REPLACE FUNCTION products_timestamp()
> RETURNS TRIGGER AS $$
> BEGIN
> 	NEW.last_updated = NOW();
> 	RETURN NEW;
> END
> $$ LANGUAGE plpgsql; 
> 
> CREATE TRIGGER products_last_update
> 	BEFORE INSERT OR UPDATE ON products
> 	FOR EACH ROW EXECUTE FUNCTION products_timestamp();
> 
> UPDATE products
> SET units_in_stock = 33
> WHERE product_id = 3
> 
> INSERT INTO products (product_name, supplier_id, category_id, quantity_per_unit,
> 		unit_price, units_in_stock, units_on_order, reorder_level, discontinued, last_updated)
> VALUES('Tovar', 2, 1, '5 oz jars', 66, 66, 0, 10, 0, null)
> 
> SELECT * FROM products
> ```

> [!success]- Решение 2
> ```sql
> DROP TABLE IF EXISTS order_details_audit
> CREATE TABLE IF NOT EXISTS order_details_audit (
> 	op varchar(1) NOT NULL,
> 	user_changes text NOT NULL,
> 	time_stamp timestamp NOT NULL,
> 	
> 	order_id smallint NOT NULL,
> 	product_id smallint NOT NULL,
> 	unit_price real NOT NULL,
> 	quantity smallint NOT NULL,
> 	discount real NOT NULL
> )
> 
> CREATE OR REPLACE FUNCTION audit_order_details()
> RETURNS TRIGGER AS $$
> BEGIN
> 	CASE TG_OP
> 		WHEN 'INSERT' THEN
> 			INSERT INTO order_details_audit
> 			SELECT 'I', session_user, now(), nt.* FROM new_table nt;
> 		WHEN 'UPDATE' THEN
> 			INSERT INTO order_details_audit
> 			SELECT 'U', session_user, now(), nt.* FROM new_table nt;
> 		WHEN 'DELETE' THEN
> 			INSERT INTO order_details_audit
> 			SELECT 'D', session_user, now(), ot.* FROM old_table ot;
> 		ELSE
> 			RAISE NOTICE 'Неизвестная операция: %', TG_OP;
> 		END CASE;
> 		
> 		RETURN NULL;
> END;
> $$ LANGUAGE plpgsql;
> 
> CREATE TRIGGER insert_order_details AFTER INSERT ON order_details
> REFERENCING NEW TABLE AS new_table 
> FOR EACH STATEMENT EXECUTE FUNCTION audit_order_details();
> 
> CREATE TRIGGER update_order_details AFTER UPDATE ON order_details
> REFERENCING NEW TABLE AS new_table
> FOR EACH STATEMENT EXECUTE FUNCTION audit_order_details();
> 
> CREATE TRIGGER delete_order_details AFTER DELETE ON order_details
> REFERENCING OLD TABLE AS old_table
> FOR EACH STATEMENT EXECUTE FUNCTION audit_order_details();
> 
> SELECT * FROM order_details
> ORDER BY order_id DESC
> 
> SELECT * FROM order_details_audit
> 
> INSERT INTO order_details
> VALUES(11077, 11, 10, 10, 0)
> 
> UPDATE order_details
> SET unit_price = 666
> WHERE order_id = 11077 AND product_id = 11
> 
> DELETE FROM order_details
> WHERE order_id = 11077 AND product_id = 11
> ```