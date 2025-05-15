<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>

<p align="center">
<a href="https://github.com/laravel/framework/actions"><img src="https://github.com/laravel/framework/workflows/tests/badge.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/dt/laravel/framework" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/v/laravel/framework" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/l/laravel/framework" alt="License"></a>
</p>

## About Laravel

Laravel is a web application framework with expressive, elegant syntax. We believe development must be an enjoyable and creative experience to be truly fulfilling. Laravel takes the pain out of development by easing common tasks used in many web projects, such as:

-   [Simple, fast routing engine](https://laravel.com/docs/routing).
-   [Powerful dependency injection container](https://laravel.com/docs/container).
-   Multiple back-ends for [session](https://laravel.com/docs/session) and [cache](https://laravel.com/docs/cache) storage.
-   Expressive, intuitive [database ORM](https://laravel.com/docs/eloquent).
-   Database agnostic [schema migrations](https://laravel.com/docs/migrations).
-   [Robust background job processing](https://laravel.com/docs/queues).
-   [Real-time event broadcasting](https://laravel.com/docs/broadcasting).

Laravel is accessible, powerful, and provides tools required for large, robust applications.

## Learning Laravel

Laravel has the most extensive and thorough [documentation](https://laravel.com/docs) and video tutorial library of all modern web application frameworks, making it a breeze to get started with the framework.

You may also try the [Laravel Bootcamp](https://bootcamp.laravel.com), where you will be guided through building a modern Laravel application from scratch.

If you don't feel like reading, [Laracasts](https://laracasts.com) can help. Laracasts contains thousands of video tutorials on a range of topics including Laravel, modern PHP, unit testing, and JavaScript. Boost your skills by digging into our comprehensive video library.

## Laravel Sponsors

We would like to extend our thanks to the following sponsors for funding Laravel development. If you are interested in becoming a sponsor, please visit the [Laravel Partners program](https://partners.laravel.com).

### Premium Partners

-   **[Vehikl](https://vehikl.com)**
-   **[Tighten Co.](https://tighten.co)**
-   **[Kirschbaum Development Group](https://kirschbaumdevelopment.com)**
-   **[64 Robots](https://64robots.com)**
-   **[Curotec](https://www.curotec.com/services/technologies/laravel)**
-   **[DevSquad](https://devsquad.com/hire-laravel-developers)**
-   **[Redberry](https://redberry.international/laravel-development)**
-   **[Active Logic](https://activelogic.com)**

## Contributing

Thank you for considering contributing to the Laravel framework! The contribution guide can be found in the [Laravel documentation](https://laravel.com/docs/contributions).

## Code of Conduct

In order to ensure that the Laravel community is welcoming to all, please review and abide by the [Code of Conduct](https://laravel.com/docs/contributions#code-of-conduct).

## Security Vulnerabilities

If you discover a security vulnerability within Laravel, please send an e-mail to Taylor Otwell via [taylor@laravel.com](mailto:taylor@laravel.com). All security vulnerabilities will be promptly addressed.

## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

# Laravel Docker Development Environment

This repository contains a complete Docker development environment for Laravel applications with MySQL, PostgreSQL, and Redis support. It's designed to be educational and demonstrate best practices for containerized Laravel development.

## 🚀 Features

-   PHP 8.2 with FPM for running Laravel applications
-   Nginx web server configured for Laravel
-   MySQL 8.0 database
-   PostgreSQL 15 database (alternative option)
-   Redis for cache, session, and queue management
-   Comprehensive Dockerfiles with detailed educational comments
-   Ready to use docker-compose configuration

## 🛠️ Prerequisites

-   Docker and Docker Compose installed on your machine
-   Git (optional, for cloning this repository)
-   Basic knowledge of Laravel and Docker concepts

## 🏗️ Getting Started

### 1. Clone this repository (or use it as a template)

```bash
git clone <repository-url>
cd Laravel-Filament-Docker-Setup
```

### 2. Create a new Laravel project

You can install Laravel in two ways:

#### Option A: Using Composer directly on your host machine

```bash
composer create-project laravel/laravel .
```

#### Option B: Using Docker (if you don't have Composer installed)

```bash
docker run --rm -v $(pwd):/app composer create-project laravel/laravel .
```

### 3. Configure environment variables

Copy the example environment file:

```bash
cp .env.example .env
```

Generate an application key:

```bash
docker-compose run --rm app php artisan key:generate
```

### 4. Build and start the Docker containers

```bash
docker-compose up -d
```

This command will:

-   Build the Laravel application container
-   Start the Nginx web server
-   Start MySQL and PostgreSQL databases
-   Start Redis

### 5. Access your application

Your Laravel application should now be available at:

-   http://localhost

## 🏗️ Project Structure

-   `dockerfiles/` - Contains all Docker-related configuration files
    -   `Dockerfile` - PHP-FPM configuration with Laravel dependencies
    -   `nginx.conf` - Nginx configuration for Laravel
-   `docker-compose.yml` - Defines all services needed for development

## 📝 Usage Guide

### Installing PHP dependencies

```bash
docker-compose run --rm app composer require package-name
```

### Running Artisan commands

```bash
docker-compose run --rm app php artisan migrate
docker-compose run --rm app php artisan make:controller UserController
```

### Installing Node.js dependencies and building assets

```bash
docker-compose run --rm app npm install
docker-compose run --rm app npm run dev
```

### Working with databases

To connect to MySQL from your host machine:

-   Host: 127.0.0.1
-   Port: 3306
-   User: laravel
-   Password: password (or what you configured in .env)
-   Database: laravel

To connect to PostgreSQL from your host machine:

-   Host: 127.0.0.1
-   Port: 5432
-   User: laravel
-   Password: password (or what you configured in .env)
-   Database: laravel

### Running tests

```bash
docker-compose run --rm app php artisan test
```

## 🔄 Common Tasks

### Rebuilding containers after Dockerfile changes

```bash
docker-compose up -d --build
```

### Viewing logs

```bash
docker-compose logs -f
```

### Stopping containers

```bash
docker-compose down
```

### Accessing container shells

```bash
docker-compose exec app bash
docker-compose exec mysql bash
docker-compose exec postgres bash
```

## 🧪 Switching database connections

The default database connection is MySQL. To switch to PostgreSQL:

1. Edit your `.env` file and change:

```
DB_CONNECTION=pgsql
DB_HOST=postgres
DB_PORT=5432
```

2. Update your Laravel configuration as needed

## 🚨 Important Notes

-   This setup is for development purposes only and is not recommended for production use
-   Database data is persisted in Docker volumes
-   Laravel storage and bootstrap/cache directories are writable by the www-data user

## 📚 Learning Resources

-   [Laravel Documentation](https://laravel.com/docs)
-   [Docker Documentation](https://docs.docker.com/)
-   [Nginx Documentation](https://nginx.org/en/docs/)
