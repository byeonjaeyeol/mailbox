docker build -f ./Basic/docker/Dockerfile -t bsquarelab/upost-basic:latest ./Basic/docker
docker build -f ./GoEnv/docker/Dockerfile -t bsquarelab/upost-goenv:latest ./GoEnv/docker
docker build -f ./Node/docker/Dockerfile -t bsquarelab/upost-node:latest ./Node/docker
docker build -f ./DB-Service01/docker/Dockerfile -t bsquarelab/upost-dbservice01:0.2 ./DB-Service01/docker
docker build -f ./External01/docker/Dockerfile -t bsquarelab/upost-external:0.1 ./External01/docker
docker build -f ./Service01/docker/Dockerfile -t bsquarelab/upost-service01:0.1 ./Service01/docker
docker build -f ./Service02/docker/Dockerfile -t bsquarelab/upost-service02:0.1 ./Service02/docker
docker build -f ./Service04/docker/Dockerfile -t bsquarelab/upost-service04:0.3 ./Service04/docker
docker build -f ./API-WAS1/docker-mailbox-service/Dockerfile -t bsquarelab/upost-node-mailbox:0.1 ./API-WAS1/docker-mailbox-service/
docker build -f ./API-WAS1/docker-mailbox-front/Dockerfile -t bsquarelab/upost-node-mailbox-front:0.1 ./API-WAS1/docker-mailbox-front/
docker build -f ./API-WAS1/docker-mailbox-front-user/Dockerfile -t bsquarelab/upost-node-mailbox-front-user:0.1 ./API-WAS1/docker-mailbox-front-user/
docker build -f ./API-WAS1/docker-mailbox-static/Dockerfile -t bsquarelab/upost-node-static:0.1 ./API-WAS1/docker-mailbox-front/

