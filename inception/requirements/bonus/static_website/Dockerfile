FROM alpine:latest

RUN apk update && apk add --no-cache hugo go git

WORKDIR /app
COPY . .

RUN hugo --destination public

RUN go build -o server main.go

RUN adduser -D staticuser
USER staticuser

EXPOSE 1313

CMD ["./server"]