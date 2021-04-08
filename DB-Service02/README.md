# UPOST-DBSERVER-02
모바일우편함 DB Service02 서버

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



