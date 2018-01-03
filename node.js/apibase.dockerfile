# info:         docker image with:
# 					alpineLinux 3.7
# 					node.js 8.9.3 (yarn 1.3.2)
# 					python 2.7.14 (pip installed pakcage)
# 					jdk 1.8.52
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
	apk add openssl python python-dev py-pip make gcc g++ && \
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


# 设置使用国内源，安装基础组件
RUN npm -g config set user root && \
    npm -g config set registry https://registry.npm.taobao.org && \
    npm install -g grunt grunt-cli nodemon && \
    yarn config set registry 'https://registry.npm.taobao.org'


# 安装alijdk：
ADD ajdk-8.4.7-b187.tgz /opt/
ENV JAVA_HOME /opt/ajdk-8.4.7-b187
ENV PATH $JAVA_HOME/bin:$PATH
ENV CLASSPATH .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar


# 安装python基础库：
COPY re.txt /
COPY install_re.sh /
RUN apk update && \
    apk add mysql-dev libpcap libpcap-dev && \
    pip install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com --upgrade pip && \
    chmod 755 /install_re.sh && \
    /bin/bash /install_re.sh
    #pip install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com -r /re.txt --no-index --find-links file:///tmp



# startup with supervisor
CMD ["/bin/bash"]