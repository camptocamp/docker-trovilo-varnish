FROM golang:1.17.6 as builder
RUN go get -u github.com/inovex/trovilo/cmd/trovilo

FROM camptocamp/varnish:20191121-2 as trovilo-varnish
COPY --from=0 /go/bin/trovilo /bin/trovilo

RUN apt-get update && \
    apt-get -y install ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    EXPORTER_VERSION=1.5.2 && \
    curl -L https://github.com/jonnenauha/prometheus_varnish_exporter/releases/download/$EXPORTER_VERSION/prometheus_varnish_exporter-$EXPORTER_VERSION.linux-amd64.tar.gz | tar xvfz - && \
    mv prometheus_varnish_exporter-*/prometheus_varnish_exporter /usr/local/bin && \
    rm -r prometheus_varnish_exporter-* && \
    strip /usr/local/bin/prometheus_varnish_exporter
