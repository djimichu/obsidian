# Cache stampede. Singleflight.
## 1. Проблема: cache stampede

**Сценарий**:

```
ключ истёк → 1000 запросов одновременно → все идут в БД
```
Это приводит к:

- перегрузке БД
    
- росту latency(задержек)
    
- возможному падению сервиса

## 2. Решение

```
разрешить только ОДНОМУ запросу идти в БД  
остальные ждут результат
```

---

## 3. Инструмент: singleflight

Пакет:

```go
golang.org/x/sync/singleflight
```
Он делает:

> дедупликацию одинаковых запросов

---

## 4. Как работает

```
ключ запроса → "product:1"  
  
если 10 горутин одновременно:  
→ только 1 выполнит функцию  
→ остальные получат тот же результат
```

---

## 5. Пример с Redis + DB (код)

> [!example]- Пример
> ```go
> import (  
>     "context"  
>     "encoding/json"  
>     "time"  
>   
>     "github.com/redis/go-redis/v9"  
>     "golang.org/x/sync/singleflight"  
> )  
>   
> var g singleflight.Group  
>   
> func GetProduct(ctx context.Context, id int) (Product, error) {  
>     key := fmt.Sprintf("product:%d", id)  
>   
>     // 1. пробуем из кеша  
>     val, err := rdb.Get(ctx, key).Bytes()  
>     if err == nil {  
>         var p Product  
>         json.Unmarshal(val, &p)  
>         return p, nil  
>     }  
>   
>     // 2. cache miss → используем singleflight  
>     v, err, _ := g.Do(key, func() (interface{}, error) {  
>   
>         // ещё раз проверяем кеш (важно!)  
>         val, err := rdb.Get(ctx, key).Bytes()  
>         if err == nil {  
>             var p Product  
>             json.Unmarshal(val, &p)  
>             return p, nil  
>         }  
>   
>         // идём в БД  
>         p := db.GetProduct(id)  
>   
>         data, _ := json.Marshal(p)  
>   
>         rdb.Set(ctx, key, data, time.Minute)  
>   
>         return p, nil  
>     })  
>   
>     if err != nil {  
>         return Product{}, err  
>     }  
>   
>     return v.(Product), nil
> }    
> ```


## 12. Короткий ответ для собеса

> Чтобы избежать cache stampede, используют singleflight — механизм, который гарантирует, что при cache miss только одна горутина пойдёт в базу, а остальные получат её результат.

