FROM php:8.4-fpm-bookworm

# Setting environment variables to enable non-interactive installations
ENV DEBIAN_FRONTEND=noninteractive

# Define ARG for UID and GID with default values
# These can be overridden at build time
ARG HOST_UID=1000
ARG HOST_GID=1000

# Update package lists and install dependencies
# These packages are needed for various PHP extensions and tools
RUN apt-get update && apt-get install -y \
    # Git for version control
    git \
    # Zip utilities for Composer packages
    unzip \
    libzip-dev \
    # Libraries for image processing (used by GD extension)
    libpng-dev \
    libjpeg-dev \
    # PostgreSQL development libraries
    libpq-dev \
    # Node.js and npm for frontend assets
    nodejs \
    npm \
    # For better performance with opcache
    libicu-dev \
    # Cleanup to reduce image size
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions required for Laravel
# Each extension adds specific functionality to PHP
RUN docker-php-ext-install \
    # Database drivers for MySQL and PostgreSQL
    pdo \
    pdo_pgsql \
    # MySQL development libraries
    pdo_mysql \
    # ZIP extension for Composer package handling
    zip \
    # BCMath for arbitrary precision mathematics
    bcmath \
    # Internationalization functions
    intl \
    # OPcache improves PHP performance by storing precompiled script bytecode
    opcache \
    # Configure and install GD library with JPEG support
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install gd

# Install Redis extension for PHP (using PECL)
# Redis is used for caching, session storage, and queues in Laravel
RUN pecl install redis \
    && docker-php-ext-enable redis

RUN delgroup dialout

# Create a user with the same UID/GID as the host user
# This solves permission issues between host and container
RUN groupadd -g ${HOST_GID} laravel && \
    useradd -u ${HOST_UID} -g ${HOST_GID} -m -s /bin/bash laravel \
    && sed -i "s/user = www-data/user = laravel/g" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/group = www-data/group = laravel/g" /usr/local/etc/php-fpm.d/www.conf \
    && echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

# Install Composer (PHP package manager)
# We're using the official installer script
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory for the application
WORKDIR /var/www/html

# Copy composer files first to leverage Docker cache layers
# This means dependencies will only be reinstalled when these files change
COPY --chown=laravel:laravel composer.json composer.lock ./

# Install PHP dependencies as the laravel user
USER laravel
RUN composer install --no-scripts --no-autoloader

# Copy the rest of the application code
COPY --chown=laravel:laravel . .

# Generate optimized autoload files and run post-install scripts
RUN composer dump-autoload --optimize && composer run-script post-root-package-install

# Install Node.js dependencies and build assets
# For Laravel Mix / Vite
RUN npm install && npm run build

# Expose port 9000 for PHP-FPM
# This will be connected to Nginx or another web server
EXPOSE 9000

# Start PHP-FPM server i foreground
CMD ["sh", "-c", "composer install && php artisan migrate && php-fpm"]
