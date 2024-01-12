# Build environment
FROM golang:alpine3.18 AS phase-bulid

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
FROM alpine:3.18 AS phase-final

RUN mkdir /app
RUN mkdir -p /var/lib/wgrest/v1

# Install WireGuard
RUN apk add --no-cache wireguard-tools

# Copy Entrypoint script
COPY ./Entrypoint.sh ./app/Entrypoint.sh
RUN sed -i 's/\r$//' ./app/Entrypoint.sh && \
    chmod +x ./app/Entrypoint.sh

# Copy wgrest binary
COPY --from=phase-bulid ./app/wgrest ./app/wgrest

# Expose port
EXPOSE 8080/tcp
EXPOSE 9090/udp

# Set command to run wgrest and Entrypoint.sh
CMD ["/bin/sh", "-c", "./app/Entrypoint.sh"]
