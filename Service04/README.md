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

# user information
안계혁 
은성일
문태훈
김민석      P059a2cbc24524c9dKR M14ef5ab1fe167f786b89b21a3c6e07a3e6dd5344d4a30fe3a103d301d6b94d1eKR
모성훈      P83a7f0787bf7ea23KR Md43d4e3310f7a60d5dc5fe636b34b473cb7bd0cd6e1bfc3575fff32081b428dcKR
유창욱      P147706ed72afc5c8KR M1448ce3c81ecedc36d9d08f4765d2d8f5eb3d570942e40651319c0d7333de957KR
홍길동      Pfb73605485978639KR M9fa5cf59ccf677d3f42487b759110c5231340c934f082adcd9763a9d82f087c9KR
홍길동1     Pdd6b48a5afa26f6fKR M035e181a0d9a229c3634aa963670794f92ed484f06cb627ecd7b3aea6111f749KR
홍길동2     Pfefc1c2a02b53b4dKR M20d991a852b269b874b0b7afb3a6d421e35d15d9a5482a734e4280339806c451KR
홍길동3     P59e1bf314a74b676KR M88c6ceb9ae8e3b7026ab3934cc3964b8eacfe293459cac3cccf72212551f9a80KR
홍길동4     P3509ef527a01f25dKR 
홍길동5     P1d2078f17e503652KR 
홍길동6     P427cce83c8c8cdbeKR 
홍길동7     P82f1e00b0ee9484eKR 
홍길동8     P742c917b76c35eceKR 
홍길동9     P362299e9f21680dbKR 
홍길동10    P3ea448e21d2b1a39KR 
#ubuntu 설치 내용 정리
실 서버에서 11001_60002_common.done 파일 copy
```
경로 /home/blab/upost-network/Service04/data/tilon/IljariAgent/options
```




