/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select * from class_studying_student_count where 1=1 and  \$CONDITIONS" \
--hcatalog-database zx_ods \
--hcatalog-table t_class_studying_student_count \
-m 1

/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *, '2022-10-13' as dt from course_table_upload_detail where 1=1 and  \$CONDITIONS" \
--hcatalog-database zx_ods \
--hcatalog-table t_course_table_upload_detail \
-m 1

/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *, '2022-10-13' as dt from student_leave_apply where 1=1 and  \$CONDITIONS" \
--hcatalog-database zx_ods \
--hcatalog-table t_student_leave_apply \
-m 1

/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *, '2022-10-13' as dt from tbh_class_time_table where 1=1 and  \$CONDITIONS" \
--hcatalog-database zx_ods \
--hcatalog-table t_tbh_class_time_table \
-m 1

/usr/bin/sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect 'jdbc:mysql://106.75.33.59:3306/teach?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true' \
--username itcast_edu_stu \
--password itcast_edu_stu \
--query "select *, '2022-10-13' as dt from tbh_student_signin_record where 1=1 and  \$CONDITIONS" \
--hcatalog-database zx_ods \
--hcatalog-table t_tbh_student_signin_record \
-m 1