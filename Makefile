.PHONY: build run stop shell clean

build:
	docker build -t jekyll-site .
	docker rm -f jekyll-container 2>/dev/null || true
	docker create --name jekyll-container -v "$(PWD):/srv/jekyll" -p 4001:4001 jekyll-site

run:
	docker start jekyll-container
	docker attach jekyll-container

stop:
	docker stop jekyll-container

shell:
	docker start jekyll-container > /dev/null 2>&1 || true
	docker exec -it jekyll-container /bin/bash

clean:
	docker rm -f jekyll-container 2>/dev/null || true
	docker rmi jekyll-site 2>/dev/null || true