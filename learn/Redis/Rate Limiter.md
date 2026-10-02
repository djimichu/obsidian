# Rate Limiter. RPS. Ограничение запросов

У нас может быть большой RPS (request per second), и мы способны его ограничить. Мы можем ограничить запросы от тех, от кого их поступает слишком много.

```
например: не больше 100 запросов в минуту на user_id
```

## Какие алгоритмы rate limiting бывают

На собесе это часто спрашивают.

### 1. Fixed Window
#### Что говорить на собесе про fixed window

Коротко так:

> Fixed window rate limiter в Redis обычно делают через `INCR` + `EXPIRE`, но в проде лучше заворачивать это в Lua script для атомарности. На каждый ключ, например `rate_limit:user:123`, ведётся счётчик запросов в окне. Если счётчик превышает лимит, возвращаем 429.

Пример:

```
100 запросов в минуту
```

Плюсы:

- просто
- легко сделать через `INCR + EXPIRE`

Минусы:

- проблема на границе окна  
    можно сделать 100 запросов в конце минуты и ещё 100 в начале следующей

> [!example]- Пример
> ```go
> package main
> 
> import (
> 	"context"
> 	"fmt"
> 	"time"
> 
> 	"github.com/redis/go-redis/v9"
> )
> 
> var ctx = context.Background()
> 
> func main() {
> 	rdb := redis.NewClient(&redis.Options{
> 		Addr: "localhost:6379",
> 	})
> 
> 	allowed, count, err := AllowRequest(rdb, "user:123", 5, time.Minute)
> 	if err != nil {
> 		panic(err)
> 	}
> 
> 	fmt.Println("allowed:", allowed, "count:", count)
> }
> 
> func AllowRequest(rdb *redis.Client, key string, limit int64, window time.Duration) (bool, int64, error) {
> 	count, err := rdb.Incr(ctx, key).Result()
> 	if err != nil {
> 		return false, 0, err
> 	}
> 
> 	if count == 1 {
> 		err = rdb.Expire(ctx, key, window).Err()
> 		if err != nil {
> 			return false, 0, err
> 		}
> 	}
> 
> 	if count > limit {
> 		return false, count, nil
> 	}
> 
> 	return true, count, nil
> }
> ```
> 

---

### 2. Sliding Window

Считает запросы в “скользящем окне”.

Часто делают через:

- `ZSET`
- timestamp каждого запроса

Плюсы:

- точнее

Минусы:

- сложнее
- дороже

---

### 3. Token Bucket

Очень популярный алгоритм.

Идея:

- есть “ведро” токенов
- запросы тратят токены
- токены со временем пополняются

Плюсы:

- хорошо подходит для API
- допускает bursts

---

### 4. Leaky Bucket

Похожая идея, но выравнивает поток.