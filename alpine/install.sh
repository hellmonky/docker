docker build -f base.dockerfile -t alpine.base .
docker build -f glibc.dockerfile -t alpine.glibc .
docker build -f openjdk8.dockerfile -t alpine.openjdk .
docker build -f oraclejre.dockerfile -t alpine.oracle_jre .
docker build -f tomcat.dockerfile -t alpine.tomcat .
