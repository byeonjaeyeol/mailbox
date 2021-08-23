set @database_1 = 'EMAILBOX'; -- provide first database name here
set @database_2 = 'EMAILBOX_DEV'; -- provide second database name here
select * 
from (
        select COALESCE(c1.table_name, c2.table_name) as table_name,
               COALESCE(c1.column_name, c2.column_name) as table_column,
               c1.column_name as database1,
               c2.column_name as database2
        from
            (select table_name,
                    column_name
             from information_schema.columns c
             where c.table_schema = @database_1) c1
        right join
                 (select table_name,
                         column_name
                  from information_schema.columns c
                  where c.table_schema = @database_2) c2
        on c1.table_name = c2.table_name and c1.column_name = c2.column_name

    union

        select COALESCE(c1.table_name, c2.table_name) as table_name,
               COALESCE(c1.column_name, c2.column_name) as table_column,
               c1.column_name as schema1,
               c2.column_name as schema2
        from
            (select table_name,
                    column_name
             from information_schema.columns c
             where c.table_schema = @database_1) c1
        left join
                 (select table_name,
                         column_name
                  from information_schema.columns c
                  where c.table_schema = @database_2) c2
        on c1.table_name = c2.table_name and c1.column_name = c2.column_name
) tmp
where database1 is null
      or database2 is null
order by table_name,
         table_column;
set @database_1 = null;
set @database_2 = null;

/*
+---------------------------+--------------------------+--------------------------+-----------+
| table_name                | table_column             | EMAILBOX                 | EMAILBOX_DEV |
+---------------------------+--------------------------+--------------------------+-----------+
| TBL_AGENCY                | business_license_number  | business_license_number  | NULL      |
| TBL_CALL                  | reg_name                 | NULL                     | reg_name  |
| TBL_FAILED_DISPATCH       | ci                       | NULL                     | ci        |
| TBL_FAILED_DISPATCH       | member_id                | member_id                | NULL      |
| TBL_FAILED_DISPATCH       | member_id_class          | member_id_class          | NULL      |
| TBL_FAILED_DISPATCH       | p_seqid                  | p_seqid                  | NULL      |
| TBL_FAILED_DISPATCH       | request_id               | request_id               | NULL      |
| TBL_NOTICE                | reg_name                 | NULL                     | reg_name  |
| TBL_STAT_RECVFILE_RESULT  | agency_id                | agency_id                | NULL      |
| TBL_STAT_SENDFILE_RESULT  | agency_id                | agency_id                | NULL      |
+---------------------------+--------------------------+--------------------------+-----------+
*/