# UPOST-BASIC
sftp와 sh을 사용할 수 있고 systemctl을 통해 인스턴스가 초기화 될때 deamon 형태로 애플리케이션이 동작할 수 있도록 구성한 도커 이미지로 일반적인 애플리케이셔은 해당 이미지를 base로 하여 제공한다.

# Pre-requisite

to build a docker image
```
$ docker build -t bsquarelab/upost-basic:latest .
$ docker build -t bsquarelab/upost-basic:0.1 .
$ docker push bsquarelab/upost-basic:0.1
$ docker pull bsquarelab/upost-basic:0.1
```

to start basic image
```
$ docker run -p 127.0.0.1:1322:22 -dt --privileged=true --name=sshd bsquarelab/upost-basic
$ docker run -p 127.0.0.1:1322:22 -dt --privileged=true --name=sshd bsquarelab/upost-basic:0.1

$ docker run -p 127.0.0.1:1322:22 --restart unless-stopped --net=bridge -v /Users/alwayswinner/Develops/upost-network/External01/data:/data/blab -d bsquarelab/upost-basic:0.1

$ docker run -p 3306:3306 --net=bridge -it bsquarelab/upost-basic:0.1 bash

```