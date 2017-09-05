FROM alpine.oracle_jre

ADD apache-tomcat-7.0.81.tar.gz /usr/local/bin

# 设置tomcat的环境变量
ENV CATALINA_HOME=/usr/local/bin/apache-tomcat-7.0.81 \
    CATALINA_BASE=/usr/local/bin/apache-tomcat-7.0.81

# 设置系统环境变量
ENV PATH=$PATH:$CATALINA_HOME/lib:$CATALINA_HOME/bin

# 暴露tomcat接口，默认为8080
EXPOSE 8080

# 入口 
ENTRYPOINT /usr/local/bin/apache-tomcat-7.0.81/bin/startup.sh && tail -F /usr/local/bin/apache-tomcat-7.0.81/logs/catalina.out
