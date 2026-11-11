ARG runtime_image=gcr.io/distroless/static

FROM golang:1.27.4-trixie AS build

ARG name=service
ARG version=latest
ARG cgo_enabled=0
ARG ldflags="-s -w -extldflags=-static"

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . ./
RUN CGO_ENABLED="$cgo_enabled" go build -ldflags="$ldflags" -buildvcs=false -tags netgo -a -o service .

FROM ${runtime_image}

ARG name
ARG version

ENV SERVICE_NAME=$name
ENV SERVICE_VERSION=$version

WORKDIR /

COPY --from=build /app/service /service
ENTRYPOINT ["/service"]
