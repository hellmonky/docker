FROM alpine.glibc

# 添加基本文件
ADD go1.9.linux-amd64.tar.gz /usr/local/bin/

# 设置golang的环境变量
ENV GOROOT=/usr/local/bin/go \
        GOPATH=/usr/local/bin/gopath

# 设置系统环境变量
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin
