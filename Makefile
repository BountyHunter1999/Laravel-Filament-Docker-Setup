start_simple_nginx:
	docker run --rm -d -p 8080:80 -v $$(pwd):/usr/share/nginx/html nginx:latest

simple_network_example:
	docker rm -f nginx_server curl_client || true
	docker network rm simple_network || true
	docker network create simple_network
	echo '<h1>Hello World</h1>' > hello.html    
	docker run -d --name nginx_server -v $$(pwd)/hello.html:/usr/share/nginx/html/index.html --network simple_network nginx:latest
	docker run -it --name curl_client --network simple_network alpine:latest sh -c "apk add curl && curl -s http://nginx_server"
	@echo " $$(tput setaf 1) I will now start cleaning stuff up $$(tput sgr0)"
	@sleep 2
	rm -f hello.html
	docker rm -f nginx_server curl_client
	docker network rm simple_network

setup_project:
	docker run --rm  -v $$(pwd):/var/www/html -w /var/www/html composer:lts composer create-project laravel/laravel chirper
	sudo chown -R $$(id -un):$$(id -gn) chirper
	mv -v chirper/* chirper/.[!.]* .
	rm -rf chirper
