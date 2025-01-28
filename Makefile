start:
	docker run -v ./wp-config.php:/app/wp-config.php -p 8080:80 --name woo kjwoo:latest
stop:
	-docker stop woo
	-docker rm woo
ssh:
	docker exec -it woo bash
build:
	docker build -t kjwoo .
reset: stop build start ssh
