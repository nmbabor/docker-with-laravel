FROM php:8.1-fpm

# Define arguments for user and UID
ARG user
ARG uid

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

# Copy Composer binary from Composer official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create user and assign necessary permissions
RUN useradd -G www-data,root -u $uid -d /home/$user $user \
    && mkdir -p /home/$user/.composer \
    && chown -R $user:$user /home/$user

# Switch to user and set working directory
USER $user
WORKDIR /var/www/html

# Copy project files and install dependencies using Composer
COPY --chown=$user:$user . .
RUN composer install --no-interaction --prefer-dist

# Expose port if necessary
# EXPOSE 9000

# Command to run PHP-FPM
# CMD ["php-fpm"]
