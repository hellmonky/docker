FROM alpine.glibc

# 添加基本文件
ADD server-jre-8u144-linux-x64.tar.gz /usr/local/bin/

# 设置jdk的环境变量
ENV JAVA_HOME=/usr/local/bin/jdk1.8.0_144 \
    CLASSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

# 设置系统环境变量
ENV PATH=$PATH:$JAVA_HOME/bin
