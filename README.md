# Docker Crash Course

This guide will serve as the basis for educational purposes within the organization, and in no way, shape, or form should be used in production setup. It will be used to provide a basic understanding of the tooling used and how one can incorporate the information/knowledge gained within their own project

## Topics

- [x] When to use Docker vs Local Development
- [x] When to restart and when to build in Docker
- [x] Docker Compose, and other orchestration tools
- [x] Docker Volumes
- [x] Docker Networks
- [x] Environment Variables

## When to use Docker vs Local Development

Docker provides a consistent development environment across different machines, making it ideal for team projects or when your application has complex dependencies. Use Docker when:

- Working in teams where environment consistency is critical
- Your application requires specific versions of PHP, MySQL, Redis, etc.
- You need to isolate the application environment from your local system
- You want to mimic production environment closely

Local development might be preferable when:

- You need maximum performance for development tasks
- You're working on a simple project with minimal dependencies
- You're comfortable managing dependencies on your local machine
- You need to conserve system resources on less powerful machines

## When to restart and when to build in Docker

- **Restart containers** (`docker-compose restart`): When you change configuration in your docker-compose.yml file that doesn't affect the build process, or when services need to be refreshed.

    - Likely need to restart when you change the .env file, or when you change the docker-compose.yml file.
    - When a service is unresponsive but you don't want to rebuild
    - When changing application configurations that are loaded at runtime
    - After updating web server configurations like Nginx or Apache settings
    - When troubleshooting network connectivity issues between containers

- **Rebuild containers** (`docker-compose up --build`): When you:

    - Change the Dockerfile
    - Update dependencies (composer.json, package.json) (If composer install and npm install aren't done within the Dockerfile, you don't need to rebuild the container or rather rebuilding won't matter `:)` )
    - Modify the base image
    - Change build arguments

- **Recreate containers** (`docker-compose down && docker-compose up -d`): When you need a fresh start or when volume paths have changed.

## Docker Compose, and other orchestration tools

**Docker Compose** is perfect for local development with Laravel:

- Defines multi-container applications in a single YAML file
- Manages container lifecycle, networks, and volumes
- Enables easy service configuration and environment variable management

For more complex environments, consider:

- **Kubernetes**: For production-grade container orchestration with scaling, self-healing, and load balancing
- **Docker Swarm**: A simpler alternative to Kubernetes for container orchestration
- **Portainer**: GUI-based container management for those preferring visual interfaces

## Docker Volumes

Volumes are used to persist data and share files between host and containers:

- **Named Volumes**: Use for database persistence. It'll appear in host system as: `/var/lib/docker/volumes/db_data/_data`

    ```
    volumes:
      - db_data:/var/lib/mysql
    ```

- **Bind Mounts**: Used for development to reflect code changes immediately

    ```
    volumes:
      - ./:/var/www/html
    ```

- **Anonymous Volumes**: Temporary data that needs to persist between container restarts. In named, we just name the path to that volume.
    - It'll appear in host system as: `/var/lib/docker/volumes/0000000000000000000000000000000000000000000000000000000000000000/_data`
    ```
    volumes:
      - /var/www/html/storage
    ```

## Docker Networks

Networks allow containers to communicate with each other:

- **Default Bridge Network**: Automatically created, containers can communicate using service names as hostnames
- **Custom Networks**: Create isolated networks for specific application components
    ```
    networks:
      frontend:
      backend:
    ```
- **Host Network**: Use when containers need direct access to host networking
- **None Network**: When containers need complete network isolation

### Types of communication

1. Host to Container: Here, we expose container port to host port. `docker run --name my-app -p <host-port>:<container-port> my-app`
2. Container to Container: Here, we connect two containers to the same network. `docker network connect my-network my-other-app`
    - Here, `my-other-app` will be able to access `my-app` using it's name as hostname
3. Container to Host: Here, we expose container port to host port. `docker run -p 8000:80 my-app`
    - To access the host services from within container we can use `host.docker.internal` as hostname.
        - `host.docker.internal` is a special DNS name that resolves to the host machine's IP address.

## Environment Variables

Environment variables manage configuration across different environments:

- Use `.env` files with docker-compose:

    ```
    env_file:
      - ./.env
    ```

- Pass individual variables:

    ```
    environment:
      - DB_HOST=mysql
      - REDIS_HOST=redis
    ```

- Use environment variables for sensitive information like API keys and passwords
- Create different .env files for different environments (.env.development, .env.production)
- Docker Compose automatically reads variables from a file named `.env` in the same directory as the docker-compose.yml file
