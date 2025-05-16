start_simple_nginx:
	docker run --rm -d -p 8080:80 -v $$(pwd):/usr/share/nginx/html nginx:latest

simple_network_example:
	docker rm -f nginx_server curl_client || true
	docker network rm simple_network || true
	docker network create simple_network
	@echo '<h1>Hello World</h1>' > hello.html    
	docker run -d --name nginx_server -v $$(pwd)/hello.html:/usr/share/nginx/html/index.html --network simple_network nginx:latest
	@echo " $$(tput setaf 1) I will now start curl client $$(tput sgr0)"
	docker run -it --name curl_client --network simple_network alpine:latest sh -c "apk add curl && curl -s http://nginx_server"
	@echo " $$(tput setaf 2) I will now start cleaning stuff up $$(tput sgr0)"
	@sleep 2
	rm -f hello.html
	docker rm -f nginx_server curl_client
	docker network rm simple_network

attach_to_network1:
	docker rm -f nginx_server || true
	docker network rm hariom_network || true
	docker network create hariom_network
	@echo "<h1>I can't be seen normally</h1>" > hello.html
	docker run -d --name nginx_server -v $$(pwd)/hello.html:/usr/share/nginx/html/index.html --network hariom_network nginx:latest

attach_to_network2:
	docker rm -f curl_client || true
	docker run -d --name curl_client nginx:latest
	@docker exec -it curl_client sh -c "apt update > /dev/null 2>&1 && apt install -y curl > /dev/null 2>&1 && curl -s http://nginx_server" || echo "$$(tput setaf 1) We couldn't connect to the network $$(tput sgr0)"
	echo " $$(tput setaf 1) I will attach this to the required network$$(tput sgr0)"
	sleep 2
	docker network connect hariom_network curl_client
	@docker exec -it curl_client sh -c "curl -s http://nginx_server"

attach_network_clean:
	docker rm -f nginx_server curl_client || true
	docker network rm hariom_network || true
	rm hello.html

setup_project:
	docker run --rm  -v $$(pwd):/var/www/html -w /var/www/html composer:lts composer create-project laravel/laravel chirper
	sudo chown -R $$(id -un):$$(id -gn) chirper
	mv -v chirper/* chirper/.[!.]* .
	rm -rf chirper


install_filament:
	docker compose exec app composer require filament/filament
	docker compose exec app php artisan filament:install --panels
	docker compose exec app php artisan make:filament-user
	echo "Needed to do this for this error: $$(tput setaf 1)The POST method is not supported for route admin/login. Supported methods: GET, HEAD$$(tput sgr0)"
	docker compose exec app php artisan vendor:publish --force --tag=livewire:assets
	echo "Visit the site at http://localhost:8000/admin"

see_connected_db:
	docker compose exec app php artisan db:monitor