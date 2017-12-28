# info:         docker image with alpineLinux 3.7 and node.js 8.9.3
# author:       yuanlai.xwt@alibaba-inc.com
# updateTime:   2017-12-28

FROM scratch

# baseImage build and setup environment
ADD alpine-minirootfs-3.7.0-x86_64.tar.gz /
RUN rm -f /etc/apk/repositories && \
    echo "http://mirrors.ustc.edu.cn/alpine/v3.7/main/" >> /etc/apk/repositories && \
    echo "http://mirrors.ustc.edu.cn/alpine/v3.7/community" >> /etc/apk/repositories
RUN apk update && apk upgrade && \
    apk add bash tree tzdata && \
    apk add ca-certificates && \
	update-ca-certificates && \
	apk add openssl python python-dev make gcc g++ && \
    apk add binutils-gold curl gnupg libgcc linux-headers &&\
    apk add --no-cache libstdc++ && \
    apk add --no-cache --virtual .build-deps && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    rm -rf /tmp/* /var/cache/apk/*


# 安装glibc支持
COPY *.apk /tmp/
RUN apk update && apk upgrade && \
    apk add --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
    rm -rf /tmp/* /var/cache/apk/* && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf


# 安装nodejs环境支持
ENV NODE_VERSION 8.9.3
RUN addgroup -g 1000 node && \
    adduser -u 1000 -G node -s /bin/sh -D node && \
    curl -SLO "https://npm.taobao.org/mirrors/node/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" && \
    tar -xf "node-v$NODE_VERSION.tar.xz" && \
    cd "node-v$NODE_VERSION" && \
    ./configure && \
    make -j$(getconf _NPROCESSORS_ONLN) && \
    make install && \
    apk del .build-deps && \
    cd .. && \
    rm -Rf "node-v$NODE_VERSION" && \
    rm "node-v$NODE_VERSION.tar.xz"
COPY yarn-v1.3.2.tar.gz /
RUN mkdir -p /opt/yarn \
    && tar -xzf yarn-v1.3.2.tar.gz -C /opt/yarn --strip-components=1 \
    && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
    && rm yarn-v1.3.2.tar.gz


# 设置使用国内源
RUN npm -g config set user root && \
    npm -g config set registry https://registry.npm.taobao.org && \
    npm install -g grunt grunt-cli && \
    yarn config set registry 'https://registry.npm.taobao.org'


# startup
CMD ["node"]