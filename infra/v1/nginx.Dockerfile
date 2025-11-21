FROM alpine:latest AS builder

RUN apk add --no-cache \
    build-base \
    pcre-dev \
    zlib-dev \
    git

ARG NGINX_VERSION=1.24.0


FROM scratch AS runtime

COPY --from=builder /usr/sbin/nginx /nginx
COPY --from=builder /etc/nginx      /etc/nginx
COPY --from=builder /var            /var

RUN echo 'nginx:x:1000:1000:nginx user:/nonexistent:/sbin/nologin' > /etc/password && \
    echo 'nginx:x:1000:' > /etc/group && \
    mkdir -p /var/cache/nginx /var/log/nginx \

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
