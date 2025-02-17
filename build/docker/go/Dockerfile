FROM golang:1.24.0-bullseye AS build

ARG name=service
ARG version=latest

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . ./
RUN CGO_ENABLED=0 go build -ldflags="-s -w -extldflags '-static'" -buildvcs=false -tags netgo -a -o service .

FROM gcr.io/distroless/static

ARG name
ARG version

ENV SERVICE_NAME=$name
ENV SERVICE_VERSION=$version

WORKDIR /

COPY --from=build /app/service /service
ENTRYPOINT ["/service"]
