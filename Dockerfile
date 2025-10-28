FROM golang:1.20-alpine AS build
RUN apk add --no-cache git
WORKDIR /src

# Copy go.mod first for improved layer caching
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source and build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-s -w" -o /emanon-go

FROM alpine:3.18
RUN apk add --no-cache ca-certificates
COPY --from=build /emanon-go /usr/local/bin/emanon-go
WORKDIR /app
# Mount your config.yaml into /app/config.yaml when running the container.
VOLUME ["/app/config.yaml"]
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/emanon-go"]
