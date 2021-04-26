docker stop `docker ps -a -q` 
docker rm `docker ps -a -q`
#docker rmi -f `docker images -a -q` 
docker volume prune 
rm -rf /data/ktbcp/storage/*

