# upost-node-static
이중화된 모바일 우편함 관리 서비스에 이미지를 위한 스토리지를 제공하기 위한 서비스 이미지 

# Pre-requisite

도커 이미지를 빌드하고 운영하기 위해서 아래와 같이 대응한다.
```
$ docker build -t bsquarelab/upost-node-static:latest .
$ docker build -t bsquarelab/upost-node-static:0.1 .
$ docker push bsquarelab/upost-node-static:0.1
$ docker pull bsquarelab/upost-node-static:0.1
```


to start the docker instance
```
$ docker run -p 8100:8080 --net=bridge -it bsquarelab/upost-node-static:0.1 bash
$ docker run -p 8100:8080 --net=host -it bsquarelab/upost-node-static:0.1 bash

$ docker exec -it c456623003b1 /bin/bash

```
