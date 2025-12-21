### CREATE TABLE

 CREATE TABLE позволяет нам создавать таблицы в нашей существующей БД.

> [!example]- Создаем таблицы
> 
>  ```sql
>  CREATE TABLE student
>  (
> 	 student_id serial
> 	 first_name varchar,
> 	 last_name varchar,
> 	 birthday date,
> 	 phone varchar
>  );
>  CREATE TABLE cathedra
>  (
> 	 cathedra_id serial,
> 	 cathedra_name varchar,
> 	 dean varchar
>  )
>  ```


Также можем создавать таблицы на основе других таблиц, сходу заполняя данными:

```sql
SELECT *
INTO new_table
FROM source_table
WHERE condition;
```
или, то же что и:
```sql
CREATE TABLE new_table AS
SELECT *
FROM source_table
WHERE condition; -- лучше читаемость!
```
Оба способа делают одно и то же.  Второй предпочтителен, лучше читаемость.

