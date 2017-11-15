FROM scratch

# 添加基本文件
ADD alpine-minirootfs-3.6.2-x86_64.tar.gz /
COPY *.apk /tmp/

# 更换为国内源
RUN rm -f /etc/apk/repositories && \
    echo "http://mirrors.ustc.edu.cn/alpine/v3.6/main" >> /etc/apk/repositories && \
    echo "http://mirrors.ustc.edu.cn/alpine/v3.6/community" >> /etc/apk/repositories
	
# 安装glibc支持
RUN apk upgrade --update && \
    apk add bash tree && \
    apk add --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib

# 更改系统的时区设置
RUN apk update && apk add curl bash tree tzdata \
    && cp -r -f /usr/share/zoneinfo/Hongkong /etc/localtime
