FROM golang:1.14.4-alpine AS builder
WORKDIR /app
COPY . .
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/trivia-app


FROM alpine:3.12.0
COPY --from=builder /go/bin/trivia-app /go/bin/trivia-app
EXPOSE 8081
ENTRYPOINT ["/go/bin/trivia-app"]
