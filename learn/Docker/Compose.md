# Docker Compose

docker-compose.yaml - инструмент для объединения docker-контейнеров, тут мы описываем наши сервисы
```yaml
services:
	application:
		build: . # наш Dockerfile отсносительно текущей директории
		container_name: application-container
		ports:
			-"5070:5050" # маппинг портов если нужно(пробрасываем)
```
Теперь можем запустить сервис:
```bash
docker compose up -d application # -d это detached mode, терминал свободен пока контейнеры работают
```
Чтобы остановить его:
```bash
docker compose down application
```

