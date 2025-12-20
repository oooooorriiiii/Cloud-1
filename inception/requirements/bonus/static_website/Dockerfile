FROM alpine:latest

RUN apk update && apk add --no-cache go

WORKDIR /app

# Goの簡易サーバーコードを作成
RUN echo 'package main; import ("net/http"; "fmt"); func main() { http.Handle("/", http.FileServer(http.Dir("./public"))); fmt.Println("Listening on :1313"); http.ListenAndServe(":1313", nil) }' > main.go

# 静的HTML作成
RUN mkdir public && \
    echo '<html><body><h1>Welcome to My Static Site</h1><p>Powered by Go</p></body></html>' > public/index.html

# ビルド
RUN go build -o server main.go

EXPOSE 1313

CMD ["./server"]