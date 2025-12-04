## FOREIGN KEY

**Внешние ключи** чем-то похожи на тему которую мы проходили [[Типы соединений]] однако там можно было взаимодействовать между таблицами без ключей, но ключи позволяют гарантированно работать с данными и таблицами без каких-либо проблем. Ключи дают защиту данных, что не будет каких-то висячих значений с ссылками на несуществующие объекты и всё в этом духе. Работает как ремень безопасности для по настоящему зависимых объектов.

Но это вовсе не значит что JOIN не нужен и можно обойтись ключами, вовсе нет, соединения очень важны, но сейчас не об этом.

Внешние ключи также являются видами ограничений. Посмотрим всё на примере:

> [!example]- Пример БЕЗ внешнего ключа
> ```sql
> CREATE TABLE publisher
> (
> 	publisher_id int,
> 	publisher_name varchar(128) NOT NULL, 
> 	address text,
> 	
> 	CONSTRAINT pk_publisher PRIMARY KEY(publisher_id)
> );
> 
> CREATE TABLE book
> (
> 	book_id int,
> 	title text NOT NULL,
> 	isbn varchar(32) NOT NULL,
> 	publisher_id int,
> 	
> 	CONSTRAINT pk_book PRIMARY KEY(book_id)
> )
> ```

> Тут мы можем писать любые значения в book publisher_id, нам ничего не запрещает, так как мы пока никак не ссылаемся на таблицу publisher. Если мы впишем значение publisher_id, которого нет в publisher - никаких ошибок, но и никаких связей.


> [!example]- Теперь добавим внешний ключ
> ```sql
> ALTER TABLE book
> ADD CONSTRAINT fk_books_publisher FOREIGN KEY(publisher_id) REFERENCES publisher(publisher_id);
> ```

> [!example]- Либо сразу при создании
> ```sql
> CREATE TABLE publisher
> (
> 	publisher_id int,
> 	publisher_name varchar(128) NOT NULL, 
> 	address text,
> 	
> 	CONSTRAINT publisher_pk PRIMARY KEY(publisher_id)
> );
> 
> CREATE TABLE book
> (
> 	book_id int,
> 	title text NOT NULL,
> 	isbn varchar(32) NOT NULL,
> 	publisher_id int,
> 	
> 	CONSTRAINT pk_book PRIMARY KEY(book_id),
> 	CONSTRAINT fk_books_publisher FOREIGN KEY(publisher_id) REFERENCES publisher(publisher_id)
> )
> ```
