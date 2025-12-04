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


