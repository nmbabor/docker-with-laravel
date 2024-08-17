setup:
	@make build
	@make up
	@make composer-update
	@make permission
	@make copy-env
	@make generate-key
	@make storage-link

build:
	docker compose build

composer-update:
	docker exec lara-simple-app bash -c "composer update"

composer-install:
	docker exec lara-simple-app bash -c "composer install"

permission:
	@echo "Adjusting permissions..."
	docker exec lara-simple-app bash -c "chmod -R 777 /var/www/html/storage"
up:
	docker compose up -d
	
stop:
	docker compose stop

generate-key:
	@echo "Application key Generate ..."
	docker exec lara-simple-app bash -c "php artisan key:generate"

copy-env:
	@echo "Copy env from env.example ..."
	docker exec lara-simple-app bash -c "cp .env.example .env"

migrate:
	@echo "Run database migration ..."
	docker exec lara-simple-app bash -c "php artisan migrate"
	
storage-link:
	@echo "Create a symbolic link at public/storage ..."
	docker exec lara-simple-app bash -c "php artisan storage:link"