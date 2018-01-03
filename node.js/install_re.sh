#!/bin/bash
PIP_REQUIRE="/requirement.txt"
while read LINE
do
  if [[ $LINE =~ ^[a-zA-Z] ]]
  then
    echo $LINE
    # pip install $LINE -d /data/pypi  #仅下载不安装
    pip install -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com $LINE
  fi
done < $PIP_REQUIRE