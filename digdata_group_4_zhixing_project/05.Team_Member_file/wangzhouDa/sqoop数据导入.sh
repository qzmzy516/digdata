/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username 	itcast_edu_stu \
--password 	itcast_edu_stu \
--query "select *,'2022-10-15'as dt  from customer_relationship where 1=1 and  \$CONDITIONS" \
--hcatalog-database zx_ods \
--hcatalog-table t_customer_relationship \
-m 1

/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username 	itcast_edu_stu \
--password 	itcast_edu_stu \
--query "select *,'2022-10-15' as dt from scrm_department where 1=1 and  \$CONDITIONS" \
--hcatalog-database zx_ods \
--hcatalog-table t_scrm_department\
-m 1

/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username 	itcast_edu_stu \
--password 	itcast_edu_stu \
--query "select *,'2022-10-15' as dt from employee where 1=1 and  \$CONDITIONS" \
--hcatalog-database zx_ods \
--hcatalog-table t_employee \
-m 1


/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username 	itcast_edu_stu \
--password 	itcast_edu_stu \
--query "select *,'2022-10-15' as dt from customer_appeal where 1=1 and  \$CONDITIONS" \
--hcatalog-database zx_ods \
--hcatalog-table t_customer_appeal \
-m 1

/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username 	itcast_edu_stu \
--password 	itcast_edu_stu \
--query "select *,'2022-10-15' as dt from itcast_school where 1=1 and  \$CONDITIONS" \
--hcatalog-database zx_ods \
--hcatalog-table t_itcast_school \
-m 1


/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username 	itcast_edu_stu \
--password 	itcast_edu_stu \
--query "select *,'2022-10-15' as dt from itcast_subject where 1=1 and  \$CONDITIONS" \
--hcatalog-database zx_ods \
--hcatalog-table t_itcast_subject \
-m 1


/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/scrm?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username 	itcast_edu_stu \
--password 	itcast_edu_stu \
--query "select *,'2022-10-15' as dt from customer_clue where 1=1 and  \$CONDITIONS" \
--hcatalog-database zx_ods \
--hcatalog-table t_customer_clue \
-m 1