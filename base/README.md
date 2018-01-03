# base docker image

使用alpine 3.7 作为基础运行文件环境，安装glibc运行支持，安装了基本的编译环境。
并且设置容器启动运行ssh服务，供外部直接链接进入管理。

构建镜像：
docker build -f base.dockerfile -t base:1.0 .
运行镜像：
docker run -p 8022:22 -d base:1.0 /usr/sbin/sshd -D