###  ALTER TABLE

**ALTER TABLE** позволяет нам изменять таблицы в БД. 
После того как мы прописали  ALTER TABLE у нас доступны следующие команды:

---


- **ADD COLUMN** *column_name **data_type***
	- Позволяет нам добавить столбец в уже существующую таблицу
	- 
	- Мы пишем имя столбца, а затем тип данных, которые будут хранится в ней.

> [!example]- Добавляем столбцы
> ```sql
> ALTER TABLE student
> ADD COLUMN middle_name varchar;
> 
> ALTER TABLE student
> ADD COLUMN rating float;
> 
> ALTER TABLE student
> ADD COLUMN enrolled date;
> ``` 

- Также мы можем удалять столбцы с помощью `DROP COLUMN`
 
> [!example]- Удаляем столбец
> ```sql
> ALTER TABLE student
> DROP COLUMN middle_name date;
> ```

---

- **RENAME TO** *new_table_name*
	Позволяет нам переименовать таблицу

> [!example]- Переименовываем таблицу
> ```sql
> ALTER TABLE cathedra
> RENAME TO chair
> ```
> 

---

- **RENAME** *old_column_name* **TO** *new_column_name*
	Позволяет нам переименовать столбец, существующий в таблице

> [!example]- Переименовываем столбцы
> ```sql
> ALTER TABLE chair
> RENAME cathedra_id TO chair_id;
> 
> ALTER TABLE chair
> RENAME cathedra_name TO chair_name;
> ```
> 

---

- **ALTER COLUMN** *column_name* **SET DATA TYPE *data_type***
	Позволяет нам изменить и задать новый тип данных столбца

> [!example]- Меняем тип данных столбцов
> ```sql
> ALTER TABLE student
> ALTER COLUMN first_name SET DATA TYPE varchar(64);
> ALTER TABLE student
> ALTER COLUMN last_name SET DATA TYPE varchar(64);
> ALTER TABLE student
> ALTER COLUMN phone SET DATA TYPE varchar(30);
> ```