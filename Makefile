all:
	docker build -t actilis/httpd-cgi:alpine .

test:
	docker container run -it --rm --name dev actilis/httpd-cgi:alpine

clean:
	docker image rm actilis/httpd-cgi:alpine 
