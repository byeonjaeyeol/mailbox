# UPOST-DBService01
모바일우편함 DB Service01 서버로 MariaDB를 포함한 서비이지만 개발 네트워크에서는 데이터베이스와 나머지 기능인 analyzer를 분리하여 해당 기능만 제공하는 서버임

# Pre-requisite
실제 네트워크로 부터 데이터베이스를 백업하기 위해 다음과 같이 백업 한 후 복구 할 수 있다.

to connect the database
```
$ mysql -h 172.0.0.1 -P 3307 -u root -p
1234 
```

to backup the database
```
$ mysqldump --routines –trigger –uroot -ppassword databasename > dump.sql

```

# MariaDB
to start mariadb
```
$ docker run --name emailboxdb -p 3306:3306 --restart unless-stopped --net=bridge -e MYSQL_ROOT_PASSWORD=1234 -v /Users/alwayswinner/Develops/upost-network/DB-Service01/mariadb:/var/lib/mysql -d mariadb:10.2.8

$ docker run --name emailboxdb -p 127.0.0.1:3307:3306 --restart unless-stopped --net=bridge -e MYSQL_ROOT_PASSWORD=1234 -v /Users/alwayswinner/Develops/upost-network/DB-Service01/mariadb:/var/lib/mysql -d mariadb:10.2.8

$ docker run -p 3306:3306 --net=bridge -it mariadb:10.2.8 bash

$ docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' emailboxdb

$ docker ps

$ docker exec -it c456623003b1 /bin/bash

```

MariaDB의 한글 character가 깨지는 경우에는 혹시라도 다음과 같이 확인하여 수정해야 한다.
```
MariaDB [EMAILBOX]> show variables like 'character%';
+--------------------------+----------------------------+
| Variable_name            | Value                      |
+--------------------------+----------------------------+
| character_set_client     | utf8                       |
| character_set_connection | utf8                       |
| character_set_database   | latin1                     |
| character_set_filesystem | binary                     |
| character_set_results    | utf8                       |
| character_set_server     | latin1                     |
| character_set_system     | utf8                       |
| character_sets_dir       | /usr/share/mysql/charsets/ |
+--------------------------+----------------------------+
8 rows in set (0.008 sec)

MariaDB [EMAILBOX]> SET character_set_database=utf8
    -> ;
Query OK, 0 rows affected (0.001 sec)

MariaDB [EMAILBOX]> SET character_set_server=utf8
    -> ;
Query OK, 0 rows affected (0.001 sec)

MariaDB [EMAILBOX]> show variables like 'character%';
+--------------------------+----------------------------+
| Variable_name            | Value                      |
+--------------------------+----------------------------+
| character_set_client     | utf8                       |
| character_set_connection | utf8                       |
| character_set_database   | utf8                       |
| character_set_filesystem | binary                     |
| character_set_results    | utf8                       |
| character_set_server     | utf8                       |
| character_set_system     | utf8                       |
| character_sets_dir       | /usr/share/mysql/charsets/ |
+--------------------------+----------------------------+
8 rows in set (0.003 sec)


```

# Analyzer

to docker build
```
$ docker build -t bsquarelab/upost-dbservice01:latest .
$ docker build -t bsquarelab/upost-dbservice01:0.1 .
$ docker push bsquarelab/upost-dbservice01:0.1
$ docker pull bsquarelab/upost-dbservice01:0.1
```

to start dbserver01 in order to start analyzer
```
$ docker run -p 1122:22 --restart unless-stopped --net=bridge -v /Users/alwayswinner/Develops/upost-network/DB-Service01/data:/data/tilon -v /Users/alwayswinner/Develops/upost-network/DB-Service01/exec/analyzer:/usr/share/tilon/analyzer -v /Users/alwayswinner/Develops/upost-network/DB-Service01/exec/sender:/usr/share/tilon/sender -d bsquarelab/upost-dbservice01:0.1
```
## debugs of analyzer
to tcp dump (reference : https://sites.google.com/site/jimmyxu101/testing/use-tcpdump-to-monitor-http-traffic)

```
tcpdump -A -s 0 'tcp port 9200 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'

```
