# UPOST-SERVICE02
모바일우편함 Service01 서버로 collector, interface, pusher 서비스를 포함한 서버임


# Pre-requisite

to docker build
```
$ docker build -t bsquarelab/upost-service02:latest .
$ docker build -t bsquarelab/upost-service02:0.1 .
$ docker push bsquarelab/upost-service02:0.2
$ docker pull bsquarelab/upost-service02:0.2
```
to start a docker image
```
$ docker run -p 2022:22 --restart unless-stopped --net=host -d bsquarelab/upost-service02:0.1

$ docker run -p 2022:22 --restart unless-stopped --net=host -v /Users/alwayswinner/Develops/upost-network/service02/exec/collector:/usr/share/tilon/collector -v /Users/alwayswinner/Develops/upost-network/service02/exec/pusher:/usr/share/tilon/pusher -d bsquarelab/upost-service02:0.1

$ docker run -p 2022:22 --restart unless-stopped --net=bridge -v /Users/alwayswinner/Develops/upost-network/service02/exec/collector:/usr/share/tilon/collector -v /Users/alwayswinner/Develops/upost-network/service02/exec/pusher:/usr/share/tilon/pusher -d bsquarelab/upost-service02:0.1


$ docker run -p 2022:22 --net=bridge -v /Users/alwayswinner/Develops/upost-network/service02/exec/collector:/usr/share/tilon/collector -v /Users/alwayswinner/Develops/upost-network/service02/exec/pusher:/usr/share/tilon/pusher -it bsquarelab/upost-service02:0.1 bash

$ docker ps

$ docker exec -it c456623003b1 /bin/bash

```

실행파일 권한주기
```
$ chmod -R a+rw ./*
$ chmod a+x ./collector/collector_1.0.0.0 
$ chmod a+x ./pusher/pusher 
```

