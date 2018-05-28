#! /bin/bash

docker run --name prometheus \
	-p 9090:9090 -d --rm \
	-v $(pwd)/prometheus:/prometheus_config \
	prom/prometheus \
	--config.file=/prometheus_config/prometheus.yml

xdg-open http://127.0.0.1:9090
# lista de métricas exportadas
xdg-open http://127.0.0.1:9090/metrics

# metrics
# prometheus_target_interval_length_seconds
# prometheus_target_interval_length_seconds{quantile="0.99"}
# count(prometheus_target_interval_length_seconds)

# graphs
# http_requests_total
# http_requests_total{code="200"}
# count(http_requests_total)
# rate(http_requests_total[1m])
# rate(prometheus_tsdb_head_chunks_created_total[1m])

