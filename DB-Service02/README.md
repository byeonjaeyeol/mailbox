# UPOST-DBSERVER-02
모바일우편함 DB Service02 서버로 일반적인 데이터베이스 관련 설정은 여기에서 정리할 예정임.

# 사용자 추가/삭제


# 사용자권한 추가/삭제


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



