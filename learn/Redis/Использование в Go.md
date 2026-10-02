# Использование в Go

> [!example]- Подключение к Redis
> ```go
> import (
>     "context"
>     "github.com/redis/go-redis/v9"
> )
> 
> ctx := context.Background()
> 
> rdb := redis.NewClient(&redis.Options{
>     Addr: "localhost:6379",
> })
> ```

> [!example]- Запись значения (SET)
> ```go
> err := rdb.Set(ctx, "product_1", 100, 0).Err()
> if err != nil {
>     panic(err)
> }
> ```
>>"product_1" → ключ
>>100         → значение
>>0           → без TTL(Time To Live) (хранится бесконечно)
>```go
rdb.Set(ctx, "product_1", 100, time.Minute)
>```
>>Так ставим TTL(через минуту данные удалятся)

> [!example]-  Чтение значения (GET)
> ```go
> val, err := rdb.Get(ctx, "product_1").Result()
> if err != nil {
>     panic(err)
> }
> 
> fmt.Println(val) // "100"
> ```
> >Redis хранит всё как строки (или байты)

## Частые операции

> [!NOTE]-  Увеличить значение
> ```go
> rdb.Incr(ctx, "product_1")
> ```
> 
> Это атомарная операция.
> 

> [!NOTE]- Проверить наличие
> ```go
> exists, _ := rdb.Exists(ctx, "product_1").Result()
> ```
> 

> [!NOTE]- Удалить
> ```go
> rdb.Del(ctx, "product_1")
> ```

> [!NOTE]-  Если нужно хранить объект
> Пример:
> 
> ```go
> type Product struct {  
>     ID    int  
>     Price int  
> }
> ```
> 
> Обычно:
> 
> ```go
> data, _ := json.Marshal(product)  
> rdb.Set(ctx, "product:1", data, 0)
> ```
> 

> [!NOTE]- Альтернатива — Hash
> ```go
> rdb.HSet(ctx, "product:1", map[string]interface{}{  
>     "id":    1,  
>     "price": 100,  
> })
> ```

> [!NOTE]- Обновить TTL
> ```go
> rdb.Expire(ctx, "test-key-1", 300*time.Second)
> ```


