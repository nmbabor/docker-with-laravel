# Dockerizing a Laravel Project from Scratch

This guide will walk you through the process of dockerizing a Laravel project from scratch. By the end of this tutorial, you will have a fully functional Laravel application running in Docker containers with Nginx, PHP, and MySQL.

## Prerequisites

Before you begin, ensure that you have the following installed on your system:

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/)
- [Composer](https://getcomposer.org/) (for creating the Laravel project)
## Step 1: Create a New Laravel Project

Start by creating a new Laravel project. If you already have an existing project, feel free to use it. I trust you're familiar with the process of setting up a Laravel project.
```bash
composer create-project --prefer-dist laravel/laravel my-laravel-app
cd my-laravel-app
````
## Step 2: Create a Dockerfile
In the root of your Laravel project, create a Dockerfile that defines how your Laravel application should be built in the Docker environment.

```
FROM php:8.1-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Set environment variable to allow superuser
ENV COMPOSER_ALLOW_SUPERUSER=1
# Update package list and install necessary dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip
# Copy project files and install dependencies using Composer
COPY . .

# Copy .env.example to .env
RUN cp .env.example .env

# Copy Composer binary from Composer official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# RUN composer update
# Install Laravel dependencies
RUN composer install

# Generate application key
RUN php artisan key:generate

# Change permissions of the vendor directory
RUN chmod -R 775 /var/www/html/storage
# Run Composer dump-autoload to optimize autoloader
# RUN composer dump-autoload --optimize

# Expose port if necessary
EXPOSE 9000

# Command to run PHP-FPM
# CMD ["php-fpm"]
```
**This `Dockerfile` will:**

* Use the php:8.1-fpm Docker image as the base image.
* Set the working directory inside the container.
* Copy your Laravel project files into the container.
* Install dependencies using Composer.
* Copy .env.example to .env and generate the application key.
* Expose port 8000 for the Laravel development server.

## Step 3: Create a `docker-compose.yml` File
  Next, create a `docker-compose.yml` file in the root of your project. This file defines the services needed for your application, such as the web server, PHP, and MySQL database.

```yaml
version: "3.8"
services:
  app:
    container_name: lara-simple-app
    restart: unless-stopped
    build:
      context: ./
      dockerfile: Dockerfile
    working_dir: /var/www/html
    volumes:
      - ./:/var/www/html:cached
    depends_on:
      - db
    networks:
      - lara-simple-network
  db:
    image: mysql:latest
    container_name: lara-simple-db
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: ${DB_DATABASE}
      MYSQL_ROOT_PASSWORD: ${DB_PASSWORD}
      MYSQL_PASSWORD: ${DB_PASSWORD}
      MYSQL_USER: ${DB_USERNAME}
    networks:
      - lara-simple-network
  nginx:
    image: nginx:alpine
    container_name: lara-simple-nginx
    restart: unless-stopped
    ports:
      - 80:80
    volumes:
      - ./:/var/www/html:cached
      - ./docker-compose/nginx:/etc/nginx/conf.d
    depends_on:
      - app
    networks:
      - lara-simple-network
networks:
  lara-simple-network:
    driver: bridge
```
**This `docker-compose.yml` defines three services:**

* **app:** The Laravel application, built from the Dockerfile you created.
* **db:** A MySQL database, with environment variables set for the root user, database name, and credentials.
* **nginx:** The Nginx web server, configured to serve your Laravel application.

## Step 4: Create Nginx Configuration
  Create the directory structure for Nginx configuration:
```bash
mkdir -p docker-compose/nginx/conf.d
```
Then, create a configuration file for Nginx at `docker-compose/nginx/conf.d/default.conf`:
```nginx
server {
    listen 80;
    
    index index.php index.html;
    
    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;

    root /var/www/html/public;

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass app:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }
    
    location / {
        try_files $uri $uri/ /index.php?$query_string;
        gzip_static on;
    }
}
```
This configuration tells Nginx to serve your Laravel application and pass PHP requests to the `app` service.

## Step 5: Update Laravel Environment Configuration
Open the `.env` file in your Laravel project and update the database configuration to match the settings in your docker-compose.yml file:

```env
DB_CONNECTION=mysql
DB_HOST=db #Database service name in the docker-compose.yml file
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=user
DB_PASSWORD=secret
```
If you don't have a `.env` file yet, run:
```bash
cp .env.example .env
```
## Step 6: Build and Run the Docker Containers
Now that everything is set up, you can build and run the Docker containers:

```bash
docker-compose up --build -d
```
This command will:

* Build the Docker images based on your Dockerfile and docker-compose.yml.
* Start the containers in detached mode.
  
## Step 7: Verify the Setup
  After the containers are up and running, you should be able to access your Laravel application at:

```
http://localhost
```
You can also verify that the database is working by running migrations:


```
docker exec -it laravel_app php artisan migrate
```
## Step 8: Additional Docker Commands
Here are some useful Docker commands for managing your Laravel application:

* **Stop the containers:**

```bash
docker-compose stop
```
* **Restart the containers:**
```bash
docker-compose restart
```

* **View container logs:**
```bash
docker-compose logs -f
```

* **Enter the running app container:**
```bash
docker exec -it lara-simple-app bash
```
## Conclusion
You now have a fully dockerized Laravel application. This setup allows you to develop and run your Laravel project in a consistent environment, making it easier to manage dependencies and configurations. You can further customize your Docker setup by adding additional services like Redis, adding custom Dockerfiles for different environments, or using multi-stage builds for production.

## Summary
This `Docker.md` file provides a comprehensive, step-by-step guide for dockerizing a Laravel project from scratch. It covers creating a Dockerfile, setting up Docker Compose, configuring Nginx, and managing the Docker environment, making it easy for anyone to follow and replicate the setup. Adjust any paths or commands as necessary for your specific environment.
