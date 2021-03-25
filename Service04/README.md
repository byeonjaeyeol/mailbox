# UPOST-SERVICE04
모바일우편함 Service04 서버로 elastic search에 관련한 내용은 SERVICE03에서 설명하였고 여기서는 IljariAgent와 sender 애플리케이션을 추가하여 동작하는 사항을 설명한다.

# Pre-requisite
실행파일 권한주기
```
$ chmod -R a+rw ./*
$ chmod a+x ./IljariAgent/IljariAgent 
$ chmod a+x ./sender/sender 
```

to docker build
```
$ docker build -t bsquarelab/upost-service04:latest .
$ docker build -t bsquarelab/upost-service04:0.1 .
$ docker push bsquarelab/upost-service04:0.1
$ docker pull bsquarelab/upost-service04:0.1

$ docker run -p 4022:22 --restart unless-stopped --net=host -v /Users/alwayswinner/Develops/upost-network/service04/etc/elasticsearch:/etc/elasticsearch -d bsquarelab/upost-service04:0.1

$ docker run -p 4022:22 --restart unless-stopped --net=bridge -v /Users/alwayswinner/Develops/upost-network/service04/data:/data/tilon -v /Users/alwayswinner/Develops/upost-network/service04/exec/IljariAgent:/usr/share/tilon/IljariAgent -v /Users/alwayswinner/Develops/upost-network/service04/exec/sender:/usr/share/tilon/sender -d bsquarelab/upost-service04:0.1

$ docker run -p 4022:22 --net=host -it bsquarelab/upost-service04:0.1 bash

$ docker ps

$ docker exec -it c456623003b1 /bin/bash

```




