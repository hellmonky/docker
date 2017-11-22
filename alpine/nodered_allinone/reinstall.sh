docker rm nodered
docker rmi -f nodered:latest
docker build -f nodered.dockerfile -t nodered:latest .
