### PRIMARY KEY

PRIMARY KEY (первичный ключ) позволяет нам вставлять данные в таблицу, гарантируя, что мы не сможем вставить дубликат конкретно в то поле, где у нас указан PRIMARY KEY.

Неважно какое это значение, число, строка или еще что-то.



> [!danger]- Создадим таблицу
> ```sql
> CREATE TABLE chair
> (
> 	chair_id serial PRIMARY KEY,
> 	chair_name varchar,
> 	dean varchar
> );
> ```

> [!danger]- Вставим данные
> ```sql
> INSERT INTO chair
> VALUES (1, 'name', 'dean')
> ```

> [!error]- Вставим данные с тем же ID
> ```sql
>  INSERT INTO chair
>  VALUES (1, 'name_2', 'dean_2')
>   ```

>ERROR: SQL state: 23505 - нарушение ограничения уникальности, ключ ужe существует

> [!error]- Вставим NULL на место ID
> ```sql
>  INSERT INTO chair
>  VALUES (1, 'name_2', 'dean_2')
>   ```

>ERROR: SQL state: 23502 - нарушение ограничения NOT NULL


То есть мы не можем вставить повторно тот же ID или вставить NULL в PRIMARY KEY.

> [!danger]- Вставим данные с другим ID
> ```sql
> INSERT INTO chair
> VALUES (2, 'name_2', 'dean_2')
> ```

Всё успешно

Казалось бы, в чем тогда отличие PRIMARY KEY от конструкций UNIQUE и NOT NULL, ведь по сути, PRIMARY KEY это два эти оператора в совокупности. Но не совсем, UNIQUE NOT NULL мы можем использовать много раз в одной таблице на разные колонки, а вот PRIMARY KEY у нас только ОДИН на таблицу!


PRIMARY KEY почти всегда это ID с автоинкрементом (ID выставляется автоматически БД).

Мы способны сами назначать ограничения и название для ключей:

> [!danger]- Создадим таблицу с CONSTRAINT
> ```sql
> CREATE TABLE chair
> (
> 	chair_id serial --PRIMARY KEY,
> 	chair_name varchar,
> 	dean varchar
> 	
> 	CONSTRAINT pk_chair_chair_id PRIMARY KEY(chair_id)
> );
> ```

Мы пишем CONSTRAINT, после чего, если это PRIMARY KEY - PK, и название таблицы_название колонки и сами ограничения. *pk_chair_id*

Чтобы получить название нашего первичного ключа(оно будет даже если мы его не назначали сами, дефолтное), можем написать такой код:

> [!quote]- Получение CONSTRAINT(необязательно)
> ```sql
> SELECT constraint_name
> FROM information_schema.key_column_usage
> WHERE table_name = 'chair'
> 	AND table_schema = 'public'
> 	AND column_name = 'chair_id'
> ```

> По дефолту будет таблица_pkey, то есть: chair_pkey

Можно также добавлять и удалять CONSTRAINT и PRIMARY KEY:

> [!danger]- Добавляем PRIMARY KEY в таблицу
> ```sql
> ALTER TABLE chair
> ADD PRIMARY KEY(chair_id)
> ```
> 

> [!danger]- Удаляем CONSTRAINT из таблицы
> 
> ```sql
> ALTER TABLE chair
> DROP CONSTRAINT chair_chair_id_key
> ```
> 

> chair_id останется в таблице, но все ограничения уникальности удалятся.


---


Продолжение этой темы в [[Последовательность]]