FROM alpine.glibc

# 安装openjdk_8.131.11-r2
RUN apk upgrade --update-cache && \
    apk add openjdk8 && \
    rm -rf /tmp/* /var/cache/apk/*

