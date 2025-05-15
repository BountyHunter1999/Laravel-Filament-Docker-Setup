setup_project:
	docker run --rm  -v $$(pwd):/var/www/html -w /var/www/html composer:lts composer create-project laravel/laravel chirper
	sudo chown -R $$(id -un):$$(id -gn) chirper
	mv -v chirper/* chirper/.[!.]* .
	rm -rf chirper