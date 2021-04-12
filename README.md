# UPOST-NETWORK
모바일우편함 개발 네트워크 구성을 위한 전반적인 사항을 다룬다.

# Pre-requisite
## 필요한 버전 체크
사용할 소프트웨어 및 리눅스의 버전 체크를 진행한다.

리눅스 OS 버전 체크
```
# cat /etc/redhat-release
CentOS Linux release 7.2.1511 (Core) 
```

리눅스 ARCH 체크
```
# arch
x86_64
```

Elastic Search NoSQL 버전 체크
```
# curl "localhost:9200"
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
```
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

## docker images required
현재 필요한 docker images들은 아래 목록과 같으며 이중 centos:7, mariadb:10.2.8, docker.elastic.co/kibana/:6.5.0 그리고  docker.elastic.co/elasticsearch:6.5.0은 오픈소스가 제공하는 것을 그대로 사용해야 하고 나머지는 각각 도커를 빌드해서 사용해야 한다. 추후에는 docker hub로 제공할 수 있다.

```
$ docker images
REPOSITORY                                                                                                     TAG       IMAGE ID       CREATED         SIZE
bsquarelab/upost-node-postalk                                                                                  0.1       dcfa1da86f5c   24 hours ago    974MB
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

## pre-requisite
필요한 데이터 폴더를 생성해야 한다.
```
$ cd upost-network

$ ./mkdirs.sh
```

## docker-compose up
현재 필요한 docker-compose는 다음 4가지가 필요하며 docker가 시작되면서 서비스가 살아나기 때문에 실행 순서는 아래 순서대로 실행하면 된다. 그전에 pid 충돌을 예방하기 위해서 rmpid.sh을 실행하여 삭제한다.

docker-compose-es.yml : elasticsearch and database
docker-compose-mailbox.yml : 모바일 우편함 서비스
docker-compose-manager.yml : 관리자 페이지 관련
docker-compose-blockchain.yml : 향후 블록체인 관련 네트워크 (현재 없음)

macos에서는 --env-file을 지정하는 방식을 사용하고 centos에서는 자동을 해당 값이 .env를 통해 지정되도록 한다.

```
$ cd upost-network

$ ./rmpid.sh

$ docker-compose --env-file macos.cfg -f docker-compose-es.yml up

$ docker-compose --env-file macos.cfg -f docker-compose-blockahin.yml up

$ docker-compose --env-file macos.cfg -f docker-compose-mailbox.yml up

$ docker-compose --env-file macos.cfg -f docker-compose-manager.yml up

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

15.165.68.163
ch
```
root/blab1234!
blab/blab1234!
```


## additional 
추가로 위의 사항은 전체 네트워크를 배포하기 위해 필요한 사항이며 관리자 페이지를 개발하거나 하는 경우에는 docker-compose-es.yml과 docker-compose-mailbox.yml 만 실행하고 개발해도 된다.



