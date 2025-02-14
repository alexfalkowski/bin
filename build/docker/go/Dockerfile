FROM golang:1.24.0-bullseye AS build

ARG name=service
ARG version=latest

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . ./
RUN CGO_ENABLED=0 go build -ldflags="-s -w -X 'github.com/alexfalkowski/${name}/internal/cmd.Version=${version}' -extldflags '-static'" -tags netgo -a -o service main.go

FROM gcr.io/distroless/static

WORKDIR /

COPY --from=build /app/service /service
ENTRYPOINT ["/service"]
