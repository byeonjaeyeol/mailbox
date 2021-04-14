# UPOST-SERVICE01
모바일우편함 Service01 서버로 interface 서비스를 포함한 서버

# Pre-requisite


to docker build
```
$ docker build -t bsquarelab/upost-service01:latest .
$ docker build -t bsquarelab/upost-service01:0.1 .
$ docker push bsquarelab/upost-service01:0.1
$ docker pull bsquarelab/upost-service01:0.1
```

to start a docker image
```
$ docker run -p 2100:2100 -p 1122:22 --restart unless-stopped --net=host -d bsquarelab/upost-service01:0.1

$ docker run -p 2100:2100 -p 1122:22 --restart unless-stopped --net=host -v /Users/alwayswinner/Develops/upost-network/Service01/exec/interface:/usr/share/tilon/interface -d bsquarelab/upost-service01:0.1

$ docker run -p 2100:2100 -p 1122:22 --restart unless-stopped --net=bridge -v /Users/alwayswinner/Develops/upost-network/Service01/exec/interface:/usr/share/tilon/interface -d bsquarelab/upost-service01:0.1


$ docker run -p 2100:2100 -p 1122:22 --net=bridge -v /Users/alwayswinner/Develops/upost-network/Service01/exec:/usr/share/tilon -it bsquarelab/upost-service01:0.1 bash

$ docker ps

$ docker exec -it c456623003b1 /bin/bash

```




