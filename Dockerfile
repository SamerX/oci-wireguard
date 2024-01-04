# Build environment
FROM golang:alpine3.18 as build-env

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

# Install WireGuard
RUN apk add --no-cache wireguard-tools

# Copy wgrest binary
COPY --from=build-env /app/wgrest /usr/local/bin/wgrest

# Copy Entrypoint script
COPY Entrypoint.sh ./Entrypoint.sh
RUN sed -i 's/\r$//' Entrypoint.sh && \
    chmod +x Entrypoint.sh

RUN chmod +x /usr/local/bin/wgrest
RUN mkdir -p /var/lib/wgrest 

# Expose port
EXPOSE 8000/tcp

# Set entrypoint to run wgrest and Entrypoint.sh
ENTRYPOINT ["/bin/sh", "-c", "/usr/local/bin/wgrest --listen '127.0.0.1:8000' & ./Entrypoint.sh"]
