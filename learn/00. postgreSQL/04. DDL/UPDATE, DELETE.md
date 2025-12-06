## UPDATE, DELETE и RETURNING


#### UPDATE
Чтобы изменить какое-то значение поля в таблице, мы пишем:
```sql
UPDATE author -- название таблицы
SET name = 'Elias', rating = 5 -- обновляемые столбцы и их значения
WHERE author_id = 1 -- какого именно автора обновляем
```

#### DELETE
Чтобы удалить какие-то значения, нужно описать, что мы хотим удалить, например:
```sql
DELETE FROM author -- название таблицы
WHERE rating < 4.5 -- всех, чей рейтинг ниже 4.5
```

Чтобы удалить все строки таблицы, пишем просто:
```sql
DELETE FROM author 
```

Отличие DELETE FROM author от TRUNCATE TABLE author в том, что наш запрос оставляет лог об удалении всех данных, а TRUNCATE не оставляет.

#### RETURNING
Мы также можем возвращать данные, которые изменили или удалили с помощью  RETERNING.

> [!example] При изменении UPDATE:
> ```sql
> UPDATE author 
> SET name = 'Elias', rating = 5
> WHERE author_id = 1 
> RETURNING author_id -- вернет ID автора которого мы изменили
> ```
> 

> [!example] При удалении DELETE:
> ```sql
> DELETE FROM author
> WHERE rating < 4.5 
> RETURNING * -- вернет всех авторов, которых мы удалили
> ```

> [!example] При вставке данных:
> ```sql
> INSERT INTO book
> VALUES 
> (2, 'book1', '123456', 54)
> RETURNING *
> ```