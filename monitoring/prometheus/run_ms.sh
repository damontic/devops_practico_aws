#!/bin/bash

IP=$(ip add | grep inet | egrep -v 'inet6|docker' | egrep -v 'lo$' | tr -s ' ' | cut -d' ' -f3 | cut -d'/' -f1)
sed -i "s/192.168.1.6/$IP/g" prometheus/prometheus_ms.yml

docker ps | grep prometheus
if [[ $? -eq 0 ]]; then
	docker stop prometheus
fi

if [[ ! -d client_golang ]]; then
	git clone https://github.com/prometheus/client_golang.git
fi

docker images | grep golang-example-random
if [[ ! $? -eq 0 ]]; then
	cd client_golang
	docker build -f examples/random/Dockerfile -t prometheus/golang-example-random .
	cd ..
fi

docker ps | grep random
if [[ ! $? -eq 0 ]]; then
	docker run --name random1 --rm -d -p 8080:8080 prometheus/golang-example-random -listen-address=:8080
	docker run --name random2 --rm -d -p 8081:8081 prometheus/golang-example-random -listen-address=:8081
	docker run --name random3 --rm -d -p 8082:8082 prometheus/golang-example-random -listen-address=:8082
fi

docker run --name prometheus \
	-p 9090:9090 -d --rm \
	-v $(pwd)/prometheus:/prometheus_config \
	prom/prometheus \
	--config.file=/prometheus_config/prometheus_ms.yml

xdg-open http://127.0.0.1:9090
xdg-open http://127.0.0.1:8080/metrics
xdg-open http://127.0.0.1:8081/metrics
xdg-open http://127.0.0.1:8082/metrics
