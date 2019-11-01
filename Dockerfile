FROM golang:1.12 as builder
RUN go get -u github.com/inovex/trovilo/cmd/trovilo

FROM camptocamp/varnish:prometheus_6 as trovilo-varnish
COPY --from=0 /go/bin/trovilo /bin/trovilo
