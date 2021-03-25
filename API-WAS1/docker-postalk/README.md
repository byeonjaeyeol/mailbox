# upost-node-postalk
모바일 우편함 관리자 페이지 

# Pre-requisite

도커 이미지를 빌드하고 운영하기 위해서 아래와 같이 대응한다.
```
$ docker build -t bsquarelab/upost-node-postalk:latest .
$ docker build -t bsquarelab/upost-node-postalk:0.1 .
$ docker push bsquarelab/upost-node-postalk:0.1
$ docker pull bsquarelab/upost-node-postalk:0.1
```


to start the docker instance
```
$ docker run -p 8100:8080 --net=bridge -it bsquarelab/upost-node-postalk:0.1 bash
$ docker run -p 8100:8080 --net=host -it bsquarelab/upost-node-postalk:0.1 bash

$ docker exec -it c456623003b1 /bin/bash

```
