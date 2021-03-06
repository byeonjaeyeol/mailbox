UPOST-NETWORK
=============
모바일우편함 개발 네트워크 구성을 위한 전반적인 사항을 다룬다.

# Pre-requisite
## Software
사용할 소프트웨어 및 리눅스의 버전 체크를 진행한다.

리눅스 OS 버전 체크
```bash
$ cat /etc/redhat-release
CentOS Linux release 7.2.1511 (Core) 
```

리눅스 ARCH 체크
```bash
$ arch
x86_64
```

Elastic Search NoSQL 버전 체크
```bash
$ curl "localhost:9200"
{
  "name" : "node-1",
  "cluster_name" : "emailbox",
  "cluster_uuid" : "qeu2VRQ7R6yfuzavcDlO5A",
  "version" : {
    "number" : "6.5.0",
    "build_flavor" : "default",
    "build_type" : "rpm",
    "build_hash" : "816e6f6",
    "build_date" : "2018-11-09T18:58:36.352602Z",
    "build_snapshot" : false,
    "lucene_version" : "7.5.0",
    "minimum_wire_compatibility_version" : "5.6.0",
    "minimum_index_compatibility_version" : "5.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

MariaDB 버전 체크
```console
# mysql -h 10.65.203.109 -u embuser -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 7551232
Server version: 10.2.8-MariaDB-log MariaDB Server

Copyright (c) 2000, 2017, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> select version();
+--------------------+
| version()          |
+--------------------+
| 10.2.8-MariaDB-log |
+--------------------+dock
1 row in set (0.02 sec)
MariaDB [(none)]> 
```

node 버전 체크
원래 블록체인 API에서 사용하던 버전은 v8.15.1이지만 MariaDB 연동을 위해 특별한 이슈가 없는 경우에는 v14를 사용할 예정임.
```
# node -v
v8.15.1

# node -v
v14.15.5
```

현재 노드의 LTS 의 최신 버전이 v14이기 때문에 NODE v14를 설치하기 위해서는 다음과 같이 진행할 수 있다.
```
rm /etc/yum.repos.d/nodesource-el.repo

curl -sL https://rpm.nodesource.com/setup_14.x | bash -
sudo yum clean all && sudo yum makecache fast
sudo yum install -y gcc-c++ make
sudo yum install -y nodejs

node -v
npm -v
```

## Docker Images
현재 필요한 docker images들은 아래 목록과 같으며 이중 centos:7 혹은 centos:8, mariadb:10.2.8, docker.elastic.co/kibana/:6.5.0 그리고  docker.elastic.co/elasticsearch:6.5.0은 오픈소스가 제공하는 것을 그대로 사용해야 하고 나머지는 각각 도커를 빌드해서 사용해야 한다. 추후에는 docker hub로 제공할 수 있다.

현재는 docker hub를 사용하지 않고 docker image를 빌드 하기 위해서 다음과 같은 shell script를 통해 docker image를 빌드 할 수 있다.

현재 기준 OS를 centos:7을 기본으로 하지만 mac os에서 systemd 버전 이슈로 deamon이 동작하지 않아서 mac os에서는 centos:8 버전을 베이스OS로 적용하여 실행시켜야 한다.

### Cleaning docker images 
기존 도커 이미지를 삭제하여 신규로 적용하기 위해서는 다음과 같이 기존 docker images를 삭제해야 한다.
```
$ rmi-dockerimages.sh
```
베이스 OS 버전만 변경하기 위해서는 다음과 같이 관련 이미지만 삭쩨하면 된다.
```
$ rmi-dockerimages-centos.sh
```

### Making docker images
도커 이미지를 만들때 베이스 OS 이미지에 따라 두개로 나뉜다.

일반적으로 리눅스 계열에서 사용하는 경우 
```
$ mk-dockerimages.sh

$ mk-dockerimages-devX.sh

```
mac os에서 실행하는 경우
```
$ mk-dockerimages-mac.sh
```
그러나 현재 docker-compose에서 cgroups을 지원하지 않기 때문에 mac os에서는 docker-compose로 deploy할 수 없다.

[docker 4.3.0 issues](https://docs.docker.com/desktop/mac/release-notes/)에 새로운 Desktop Docker이슈가 설명되어 있다.


[cgroups not supported](https://github.com/docker/compose/issues/8167)에는 현재 docker-compose가 cgroups을 지원하지 못하는 이슈가 오픈되어 있다.


### Checking docker images

```
$ docker images
REPOSITORY                                                                                                     TAG       IMAGE ID       CREATED         SIZE
bsquarelab/upost-node-mailbox                                                                                  0.1       dcfa1da86f5c   24 hours ago    974MB
bsquarelab/upost-node-static                                                                                   0.1       b9f7f36f1441   24 hours ago    751MB
bsquarelab/upost-node                                                                                          latest    4995c454c266   25 hours ago    749MB
bsquarelab/upost-basic                                                                                         latest    4995c454c266   25 hours ago    749MB
bsquarelab/upost-dbservice01                                                                                   0.1       07de6d698657   7 days ago      603MB
bsquarelab/upost-service04                                                                                     0.1       85d668799b2d   7 days ago      603MB
bsquarelab/upost-service02                                                                                     0.1       fc3e5466c853   7 days ago      603MB
bsquarelab/upost-service01                                                                                     0.1       06f3a010cb6d   9 days ago      603MB
bsquarelab/upost-external                                                                                      0.1       1c4c9cd6c076   9 days ago      603MB
centos                                                                                                         7         8652b9f0cb4c   4 months ago    204MB
docker.elastic.co/kibana/kibana                                                                                6.5.0     fcc1f039f61c   2 years ago     727MB
docker.elastic.co/elasticsearch/elasticsearch                                                                  6.5.0     ff171d17e77c   2 years ago     774MB
mariadb                                                                                                        10.2.8    eb7b193b1631   3 years ago     397MB

```

# Operations

## Pre-requisite
필요한 데이터 폴더를 생성해야 한다.
```
$ cd upost-network

$ ./mkdirs.sh
```

pid 충돌을 막기 위해서는 다음과 같이 pid를 제거할 수 있다.
```
$ ./rmpid.sh
```

## Deployment all to local and 1 tier 
현재 필요한 docker-compose는 다음 4가지가 필요하며 docker가 시작되면서 서비스가 살아나기 때문에 실행 순서는 아래 순서대로 실행하면 된다. 그전에 pid 충돌을 예방하기 위해서 rmpid.sh을 실행하여 삭제한다.

docker-compose-dev-data.yml : elasticsearch and database
docker-compose-dev-mailbox.yml : 모바일 우편함 서비스
docker-compose-dev-manager.yml : 관리자 페이지 관련
docker-compose-dev-blockchain.yml : 향후 블록체인 관련 네트워크 (현재 없음)

macos에서는 --env-file을 지정하는 방식을 사용하고 centos에서는 자동을 해당 값이 .env를 통해 지정되도록 한다. 
리눅스에서는 --env-file이 정상적으로 동작하지 않는다.

```
$ cd upost-network

$ ./rmpid.sh

$ docker-compose --env-file macos.cfg -f docker-compose-dev-data.yml up -d

$ docker-compose --env-file macos.cfg -f docker-compose-dev-blockahin.yml up -d

$ docker-compose --env-file macos.cfg -f docker-compose-dev-mailbox.yml up -d

$ docker-compose --env-file macos.cfg -f docker-compose-dev-manager.yml up -d

```

linux에서는 --env-file 옵션이 없는 상태로 실행하면 된다.
```
$ cd upost-network

$ ./rmpid.sh

$ docker-compose -f docker-compose-dev-data.yml up -d

$ docker-compose -f docker-compose-dev-blockahin.yml up -d

$ docker-compose -f docker-compose-dev-mailbox.yml up -d

$ docker-compose -f docker-compose-dev-manager.yml up -d

```

## Deployment all to 3 tiers
3개의 티어로 분리한 경우 다음과 같은 docker-compose 설정 파일을 이용하여 배포할 수 있다.

at the 3rd tier
```
$ cd upost-network
$ ./rmpid.sh
$ docker-compose -f docker-compose-dev3-data.yml up -d
$ docker-compose -f docker-compose-dev3-analyzers.yml up -d
```

at the 1st tier
```
$ cd upost-network
$ ./rmpid.sh
$ docker-compose -f docker-compose-dev1-mailbox.yml up -d
```

at the 2nd tier
```
$ cd upost-network
$ ./rmpid.sh
$ docker-compose -f docker-compose-dev2-mailbox.yml up -d
$ docker-compose -f docker-compose-dev2-manage.yml up -d
```

## Deployment by CLI

MAC OS에서 Docker for MAC 4.3.0 이후 버전을 사용하는 경우에는 현재 기준으로는 docker-compose를 사용할 수 없다. 결과적으로 다음과 같이 docker run을 사용하여 진행해야 한다.

```


```







## docker-compose down
docker를 실행하는 역순으로 실행한다.

```
$ cd upost-network

$ docker-compose -f docker-compose-manager.yml down

$ docker-compose -f docker-compose-mailbox.yml down

$ docker-compose -f docker-compose-blockahin.yml down

$ docker-compose -f docker-compose-es.yml down

```
## instance@amazone

아마존의 다음 인스턴스에 배포되어 있다.
15.165.68.163

```
root/blab1234!
blab/blab1234!
```


## additional 
추가로 위의 사항은 전체 네트워크를 배포하기 위해 필요한 사항이며 관리자 페이지를 개발하거나 하는 경우에는 docker-compose-data.yml과 docker-compose-mailbox.yml 만 실행하고 개발해도 된다.



P147706ed72afc5c8KR 
3yLTaHrvCWneaJEQGKIx3KpL0pgQSnMYygBXVWt8hKxGVr9kP3/THQEwJHtKz5aK/O4qHyyWnENeCGvSphz8ug==
I5g7VxV1/0cXt3K6yU2emhV9dTsDmO2KSWzUOr7gNTY=


