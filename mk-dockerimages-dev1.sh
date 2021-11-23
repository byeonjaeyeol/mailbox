docker build -f ./Basic/docker/Dockerfile -t bsquarelab/upost-basic:latest ./Basic/docker
docker build -f ./External01/docker/Dockerfile -t bsquarelab/upost-external:0.1 ./External01/docker
docker build -f ./Service04/docker/Dockerfile -t bsquarelab/upost-service04:0.2 ./Service04/docker

