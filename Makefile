setup:
	@make build
	@make up
	@make composer-update
	@make permission

build:
	docker compose build

composer-update:
	docker exec lara-simple-app bash -c "composer update"

permission:
	@echo "Adjusting permissions..."
	docker exec lara-simple-app bash -c "chmod -R 777 /var/www/html/storage"
up:
	docker compose up -d
stop:
	docker compose stop
generate-key:
	docker exec lara-simple-app bash -c "php artisan key:generate"