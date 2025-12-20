FROM alpine:latest

RUN apk update && apk add --no-cache redis

RUN sed -i "s|bind 127.0.0.1|#bind 127.0.0.1|g" /etc/redis.conf && \
    sed -i "s|protected-mode yes|protected-mode no|g" /etc/redis.conf && \
    echo "maxmemory 256mb" >> /etc/redis.conf && \
    echo "maxmemory-policy allkeys-lru" >> /etc/redis.conf

EXPOSE 6379

CMD ["redis-server", "/etc/redis.conf"]