-- 学科表sqoop导入语句
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select * from itcast_subject where 1=1 and  \$CONDITIONS" \
--hcatalog-database ods \
--hcatalog-table t_itcast_subject \
-m 1

-- 员工表sqoop导入语句
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *, '2022-10-13' as dt from employee where 1=1 and  \$CONDITIONS" \
--hcatalog-database ods \
--hcatalog-table t_employee \
-m 1


-- 部门表
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select * from scrm_department where 1=1 and  \$CONDITIONS" \
--hcatalog-database ods \
--hcatalog-table t_scrm_department \
-m 1

-- 申诉表
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *, '2022-10-13' as dt from customer_appeal where 1=1 and  \$CONDITIONS" \
--hcatalog-database ods \
--hcatalog-table t_customer_appeal \
-m 1

-- 意向表
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&useSSL=false' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *, '2022-10-13' as dt from customer_relationship where 1=1 and  \$CONDITIONS" \
--hcatalog-database ods \
--hcatalog-table t_customer_relationship \
-m 1


-- 学员表

/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *, '2022-10-13' as dt from customer where 1=1 and  \$CONDITIONS" \
--hcatalog-database ods \
--hcatalog-table t_customer \
-m 1


-- 校区表
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select * from itcast_school where 1=1 and  \$CONDITIONS" \
--hcatalog-database ods \
--hcatalog-table t_itcast_school \
-m 1

-- 线索表
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *, '2022-10-13' as dt from customer_clue where 1=1 and  \$CONDITIONS" \
--hcatalog-database ods \
--hcatalog-table t_customer_clue \
-m 1



