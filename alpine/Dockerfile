# alpine:3.6.2 glibc:2.25 oracle_jre:1.8.144
FROM scratch

# 添加基本文件支持
ADD alpine-minirootfs-3.6.2-x86_64.tar.gz /
ADD server-jre-8u144-linux-x64.tar.gz /usr/local/bin
ADD apache-tomcat-7.0.81.tar.gz /usr/local/bin
COPY *.apk /tmp/

# 安装系统基础包，并且设置
RUN rm -f /etc/apk/repositories && \
    echo "http://mirrors.ustc.edu.cn/alpine/v3.6/main" >> /etc/apk/repositories && \
    echo "http://mirrors.ustc.edu.cn/alpine/v3.6/community" >> /etc/apk/repositories && \
    apk update --update && apk add bash tree tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk add --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib

# 设置环境变量
ENV JAVA_HOME=/usr/local/bin/jdk1.8.0_144 \
    CLASSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar \
    CATALINA_HOME=/usr/local/bin/apache-tomcat-7.0.81 \
    CATALINA_BASE=/usr/local/bin/apache-tomcat-7.0.81 \
    PATH=$PATH:$JAVA_HOME/bin:$CATALINA_HOME/lib:$CATALINA_HOME/bin

# 暴露tomcat接口，默认为8080
EXPOSE 8080

# 入口 
ENTRYPOINT /usr/local/bin/apache-tomcat-7.0.81/bin/startup.sh && tail -F /usr/local/bin/apache-tomcat-7.0.81/logs/catalina.out

