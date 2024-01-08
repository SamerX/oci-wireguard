# Build environment
FROM golang:alpine3.18 AS build-env

# Install dependencies
RUN apk add --no-cache git gcc

# Clone wgrest repository
RUN git clone https://github.com/suquant/wgrest /app
WORKDIR /app

# Build wgrest
RUN export appVersion=$(git describe --tags `git rev-list -1 HEAD`) && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
      -ldflags "-X main.appVersion=$appVersion" \
      -o wgrest cmd/wgrest-server/main.go

# Final image
FROM alpine:3.18

RUN mkdir /app
WORKDIR /app
# Install WireGuard
RUN apk add --no-cache wireguard-tools

# Copy wgrest binary
COPY --from=build-env /app/wgrest /app/wgrest

# Copy Entrypoint script
COPY Entrypoint.sh ./Entrypoint.sh
RUN sed -i 's/\r$//' Entrypoint.sh && \
    chmod +x Entrypoint.sh

# Expose port
EXPOSE 51800/tcp
EXPOSE 51820/udp

# Set entrypoint to run wgrest and Entrypoint.sh
ENTRYPOINT ["/bin/sh", "-c", "/app/wgrest --listen '127.0.0.1:51800' && ./Entrypoint.sh"]
