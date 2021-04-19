# UPOST-DBSERVER-02
모바일우편함 DB Service02 서버로 일반적인 데이터베이스 관련 설정은 여기에서 정리할 예정임.

# docker build
to docker build
```
$ docker build -t bsquarelab/upost-mariadb:latest .

$ docker build -t bsquarelab/upost-mariadb:0.1 .

$ docker push bsquarelab/upost-mariadb:0.1
$ docker pull bsquarelab/upost-mariadb:0.1
```

# 사용자 관리
## 추가
```
MariaDB [(none)]> create user 'embuser'@'localhost' identified by '!tilon9099@';
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> create user 'embuser'@'%' identified by '!tilon9099@';
Query OK, 0 rows affected (0.00 sec)
```

## 삭제

```
MariaDB [mysql]> drop user 'embuser'@'%';
Query OK, 0 rows affected (0.00 sec)
```


# 사용자권한 관리
## 추가
```
MariaDB [(none)]> grant all privileges on *.* to 'embuser'@'localhost';
Query OK, 0 rows affected (0.01 sec)

MariaDB [(none)]> grant all privileges on *.* to 'embuser'@'%';
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> show grants for 'embuser'@'localhost';
+-------------------------------------------------------------------------------------------------------------------------+
| Grants for embuser@localhost                                                                                            |
+-------------------------------------------------------------------------------------------------------------------------+
| GRANT ALL PRIVILEGES ON *.* TO 'embuser'@'localhost' IDENTIFIED BY PASSWORD '*F6A8012F18F5925568CA9B6173D61462877696A6' |
+-------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

MariaDB [(none)]> 

```

## 삭제


```
MariaDB [(none)]> revoke all on *.* from 'embuser'@'localhost';
Query OK, 0 rows affected (0.01 sec)

MariaDB [(none)]> revoke all on *.* from 'embuser'@'%';
Query OK, 0 rows affected (0.00 sec)
```

# 데이터베이스 백업 및 복구
```
[root@ip-172-31-38-3 home]# mysql -h 127.0.0.1 -P 3307 -u root -p EMAILBOX < EMAILBOX_20210308.sql 
Enter password: 
[root@ip-172-31-38-3 home]# 
```



# 한글깨짐수정
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

MariaDB [EMAILBOX]> SET character_set_database=utf8;
Query OK, 0 rows affected (0.001 sec)

MariaDB [EMAILBOX]> SET character_set_server=utf8;
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

# primary key 변경
primary key를 변경하기 위해서는 우선 삭제를 진행한다.
```
MariaDB [EMAILBOX]> alter table TBL_EPOSTMEMBER_CO drop primary key;
Query OK, 2437307 rows affected (40 min 5.117 sec)     
Records: 2437307  Duplicates: 0  Warnings: 0
```

삭제 후 primary key를 변경한다.
```
MariaDB [EMAILBOX]> alter table TBL_EPOSTMEMBER_CO add primary key(p_code, MI);
Query OK, 0 rows affected, 1 warning (2 min 51.833 sec)
Records: 0  Duplicates: 0  Warnings: 1
```

# handling index
select 속도를 개선하기 위해 indexin을 사용할 수 있다.
index 확인
```
MariaDB [EMAILBOX]> show index from TBL_EPOSTMEMBER_CO;
+--------------------+------------+---------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table              | Non_unique | Key_name                  | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+--------------------+------------+---------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| tbl_epostmember_co |          0 | PRIMARY                   |            1 | p_code      | A         |     2260163 |     NULL | NULL   |      | BTREE      |         |               |
| tbl_epostmember_co |          0 | PRIMARY                   |            2 | MI          | A         |     2260163 |     NULL | NULL   |      | BTREE      |         |               |
| tbl_epostmember_co |          0 | TBL_EPOSTMEMBER_ci_uindex |            1 | ci          | A         |     2260163 |     NULL | NULL   |      | BTREE      |         |               |
+--------------------+------------+---------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
3 rows in set (0.025 sec)

```

index 생성
```
MariaDB [EMAILBOX]> create index TBL_EPOSTMEMBER_CO_MI_index on TBL_EPOSTMEMBER_CO(MI);
Query OK, 0 rows affected (1 min 40.859 sec)        
Records: 0  Duplicates: 0  Warnings: 0

MariaDB [EMAILBOX]> show index from TBL_EPOSTMEMBER_CO;
+--------------------+------------+-----------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| Table              | Non_unique | Key_name                    | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |
+--------------------+------------+-----------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
| tbl_epostmember_co |          0 | PRIMARY                     |            1 | p_code      | A         |     2260163 |     NULL | NULL   |      | BTREE      |         |               |
| tbl_epostmember_co |          0 | PRIMARY                     |            2 | MI          | A         |     2260163 |     NULL | NULL   |      | BTREE      |         |               |
| tbl_epostmember_co |          0 | TBL_EPOSTMEMBER_ci_uindex   |            1 | ci          | A         |     2260163 |     NULL | NULL   |      | BTREE      |         |               |
| tbl_epostmember_co |          1 | TBL_EPOSTMEMBER_CO_MI_index |            1 | MI          | A         |     2260163 |     NULL | NULL   |      | BTREE      |         |               |
+--------------------+------------+-----------------------------+--------------+-------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
4 rows in set (0.011 sec)

```

index 삭제
```
MariaDB [EMAILBOX]> drop index TBL_EPOSTMEMBER_CO_MI_index on TBL_EPOSTMEMBER_CO;

```

# procedure
## procedure 목록
프로시져 목록을 확인하기
```
MariaDB [EMAILBOX]> show procedure status;

MariaDB [EMAILBOX]> show create procedure SP_IF_LOGIN;
```
## procedure 업데이트



# Table
## 상세정보
```
MariaDB [EMAILBOX]> show full columns from TBL_EPOSTMEMBER;

MariaDB [EMAILBOX]> desc TBL_EPOSTMEMBER;

MariaDB [EMAILBOX]> SELECT default_character_set_name, DEFAULT_COLLATION_NAME FROM information_schema.SCHEMATA  WHERE schema_name = "EMAILBOX";
+----------------------------+------------------------+
| default_character_set_name | DEFAULT_COLLATION_NAME |
+----------------------------+------------------------+
| utf8                       | utf8_general_ci        |
+----------------------------+------------------------+


```

# Database
데이터베이스에 대한 charset과 collation 변경
```
MariaDB [EMAILBOX]> ALTER DATABASE EMAILBOX CHARACTER SET utf8 COLLATE utf8_unicode_ci;
Query OK, 1 row affected (0.012 sec)

MariaDB [EMAILBOX]> SELECT SCHEMA_NAME 'database', default_character_set_name 'charset', DEFAULT_COLLATION_NAME 'collation' FROM information_schema.SCHEMATA;
+--------------------+---------+-----------------+
| database           | charset | collation       |
+--------------------+---------+-----------------+
| EMAILBOX           | utf8    | utf8_unicode_ci |
| data               | utf8    | utf8_general_ci |
| information_schema | utf8    | utf8_general_ci |
| mysql              | utf8    | utf8_general_ci |
| performance_schema | utf8    | utf8_general_ci |
+--------------------+---------+-----------------+
5 rows in set (0.005 sec)

```


# 데이터 정합성

```
INSERT INTO TBL_AGENCY VALUES(12,"49757","(주)비스퀘어랩","69999","미래연구본부","안계혁","01026686763","jhko@tilon.com","https://if.postok.co.kr/icon/bsquarelab_logo.png", "2025-05-20 00:00:00", "pstchannel1","org1",0,3,"365d",0,"");

```