# UPOST-NODE
node 14.x 환경을 지원하는 docker 컨테이너로 다양한 노드 애플리케이션을 위한 서버를 제공한다.
추후에 pm2를 이용하여 node 애플리케이션을 멀티로 구성할 수 있는 형태로 만들어야 할지 고민이 필요하다.

# Pre-requisite

to build a docker image
```
$ docker build -t bsquarelab/upost-node:latest .
$ docker build -t bsquarelab/upost-node:0.1 .
$ docker push bsquarelab/upost-node:0.1
$ docker pull bsquarelab/upost-node:0.1
```

to start the docker instance
```
$ docker run -p 3306:3306 --net=bridge -it bsquarelab/upost-node:0.1 bash
$ docker run -p 3306:3306 --net=host -it bsquarelab/upost-node:0.1 bash

$ docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' emailboxdb

$ docker ps

$ docker exec -it c456623003b1 /bin/bash

```
