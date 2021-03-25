# UPOST-EXTERNAL01
모바일 우편함을 제외한 외부의 서버에 대응하기 위한 서버로 다음과 같은 역활을 하고 있음.
1. DM 업체 서버
2. 향후 KOTI 서버 역할을 하여 디버깅에 사용될 수 있으나 다양한 기능이 필요한 경우 새로 서버를 추가하여 구현할 수 있음.

# Pre-requisite
to build a docker image
```
$ docker build -t bsquarelab/upost-external:latest .
$ docker build -t bsquarelab/upost-external:0.1 .
$ docker push bsquarelab/upost-external:0.1
$ docker pull bsquarelab/upost-external:0.1
```

to start
```
$ docker run -p 3306:3306 --net=bridge -it bsquarelab/upost-external:0.1 bash
$ docker run -p 3306:3306 --net=host -it mariadb:10.2.8 bash

$ docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' emailboxdb

$ docker ps

$ docker exec -it c456623003b1 /bin/bash

```
