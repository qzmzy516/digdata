
/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/nev?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *, '2022-10-14' as dt from web_chat_ems_2019_07 where 1=1 and  \$CONDITIONS" \
--hcatalog-database zx_ods \
--hcatalog-table t_web_chat_ems_2019_07 \
-m 1


/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/nev?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *, '2022-10-14' as dt from web_chat_text_ems_2019_07 where 1=1 and  \$CONDITIONS" \
--hcatalog-database zx_ods \
--hcatalog-table t_web_chat_text_ems_2019_07 \
-m 1