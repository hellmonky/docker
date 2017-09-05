FROM alpine.oracle_jre

ADD ideaIC-2017.2.3-no-jdk.tar.gz /usr/local/bin/

# install gui-basic-compent, git and sudo
RUN apk update --update && \
    apk add libxtst-dev libxrender-dev sudo && \
    export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer && \
    sudo rm -rf /var/cache/apk/*
    

# 设置环境变量，将IDEA的主目录设置为/home/developer
USER developer
ENV HOME /home/developer

# 启动时执行的指令，需要在启动时export变量:
CMD /usr/local/bin/idea-IC-172.3968.16/bin/idea.sh