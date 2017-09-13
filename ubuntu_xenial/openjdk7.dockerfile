FROM ubuntu

# 安装必要的工具
RUN apt-get update && \
    apt-get install -y mercurial build-essential \
    libx11-dev libxext-dev libxrender-dev libxtst-dev libxt-dev \
    libcups2-dev libfreetype6-dev \
    libasound2-dev ccache gawk m4 unzip zip libasound2-dev \
    libxrender-dev xorg-dev xutils-dev binutils libmotif-dev ant

# 安装openjdk7作为bootstrap编译器
RUN apt-get install -y software-properties-common python-software-properties && \
    add-apt-repository -y ppa:openjdk-r/ppa && \
    apt-get update && \
    apt-get install -y openjdk-7-jdk