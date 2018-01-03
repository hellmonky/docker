# info:         docker image with: alpineLinux 3.7 (glibc 2.26)
# author:       yuanlai.xwt@alibaba-inc.com
# updateTime:   2017-12-28

FROM scratch

# baseImage build and setup environment
ADD alpine-minirootfs-3.7.0-x86_64.tar.gz /
RUN rm -f /etc/apk/repositories && \
    echo "http://mirrors.ustc.edu.cn/alpine/v3.7/main/" >> /etc/apk/repositories && \
    echo "http://mirrors.ustc.edu.cn/alpine/v3.7/community" >> /etc/apk/repositories && \
    echo 'root:root' | chpasswd
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


# 安装ssh服务，提供外部直接连入管理的能力
# 当OpenSSH服务器第一次安装到Linux系统时，SSH主机密钥应该会自动生成以供后续使用。因为docker没有完整的启动过程，所以需要手动生成这些秘钥
EXPOSE 22
RUN apk --update add openssh && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N "" && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_dsa_key -N "" && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ""  && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
COPY sshd_config /etc/ssh/


# startup
CMD ["/bin/bash"]