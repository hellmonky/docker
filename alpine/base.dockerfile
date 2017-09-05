FROM scratch
ADD alpine-minirootfs-3.6.2-x86_64.tar.gz /
RUN rm -f /etc/apk/repositories && \
    echo "http://mirrors.ustc.edu.cn/alpine/v3.6/main" >> /etc/apk/repositories && \
    echo "http://mirrors.ustc.edu.cn/alpine/v3.6/community" >> /etc/apk/repositories
RUN apk update --update && apk add tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    rm -rf /var/cache/apk/*
CMD ["/bin/sh"]
