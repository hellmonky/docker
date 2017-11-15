FROM nodejs:latest

# 基础需要环境安装
RUN apk upgrade && apk upgrade && \
	apk add ca-certificates && \
	update-ca-certificates && \
	apk add openssl python make gcc g++

# 切换为node用户，否则无法正常的安装npm库
USER node

# 问题解决：https://stackoverflow.com/questions/44633419/no-access-permission-error-with-npm-global-install-on-docker-image
RUN npm -g config set user root

# npm设置和相关的库安装
RUN npm config set registry https://registry.npm.taobao.org
RUN npm install -g grunt grunt-cli bcrypt bcryptjs nopt fs-extra when clone semver i18next jsonata body-parser passport cors mustache oauth2orize passport-http-bearer passport-oauth2-client-password ws

# 最后编译安装node-red
RUN npm install -g node-red



