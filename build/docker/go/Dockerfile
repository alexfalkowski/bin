FROM golang:1.26.0-trixie AS build

ARG name=service
ARG version=latest

ENV CGO_ENABLED=0
ENV GOEXPERIMENT=greenteagc,jsonv2

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . ./
RUN go build -ldflags="-s -w -extldflags '-static'" -buildvcs=false -tags netgo -a -o service .

FROM gcr.io/distroless/static

ARG name
ARG version

ENV SERVICE_NAME=$name
ENV SERVICE_VERSION=$version

WORKDIR /

COPY --from=build /app/service /service
ENTRYPOINT ["/service"]
