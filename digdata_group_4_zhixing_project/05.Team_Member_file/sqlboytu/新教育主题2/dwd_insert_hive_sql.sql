--分区
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=10000;
set hive.exec.max.dynamic.partitions=100000;
set hive.exec.max.created.files=150000;
--hive压缩
set hive.exec.compress.intermediate=true;
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;
insert into table dwd.dim_itcast_school -- 校区表
select * from ods.t_itcast_school;

insert into table dwd.dim_itcast_subject -- 学科表
select * from ods.t_itcast_subject;

insert into table dwd.dim_scrm_department -- 部门表
select * from ods.t_scrm_department;


insert overwrite table dwd.dim_employee partition(start_date)-- 员工表
select id,
       email,
       real_name,
       phone,
       department_id,
       department_name,
       remote_login,
       job_number,
       cross_school,
       last_login_date,
       creator,
       create_date_time,
       update_date_time,
       deleted,
       scrm_department_id,
       leave_office,
       leave_office_time,
       reinstated_time,
       superior_leaders_id,
       tdepart_id,
       tenant,
       ems_user_name,
       dt as start_date,
       '9999-99-99'as end_date


from ods.t_employee;


insert into table dwd.dim_customer partition (start_date)
select id,
       customer_relationship_id,
       create_date_time,
       update_date_time,
       deleted,
       name,
       idcard,
       birth_year,
       gender,
       phone,
       wechat,
       qq,
       email,
       area,
       leave_school_date,
       graduation_date,
       bxg_student_id,
       creator,
       origin_type,
       origin_channel,
       tenant,
       md_id,
        dt as start_date,
       '9999-99-99'as end_date
from ods.t_customer; -- 学员信息表

insert overwrite table dwd.dim_customer_clue partition (start_date)
select id,
       create_date_time,
       update_date_time,
       deleted,
       customer_id,
       customer_relationship_id,
       session_id,
       sid,
       status,
       `user`,
       create_time,
       platform,
       s_name,
       seo_source,
       seo_keywords,
       ip,
       referrer,
       from_url,
       landing_page_url,
       url_title,
       to_peer,
       manual_time,
       begin_time,
       reply_msg_count,
       total_msg_count,
       msg_count,
       comment,
       finish_reason,
       finish_user,
       end_time,
       platform_description,
       browser_name,
       os_info,
       area,
       country,
       province,
       city,
       creator,
       name,
       idcard,
       phone,
       itcast_school_id,
       itcast_school,
       itcast_subject_id,
       itcast_subject,
       wechat,
       qq,
       email,
       gender,
       level,
       origin_type,
       information_way,
       working_years,
       technical_directions,
       customer_state,
       valid,
       anticipat_signup_date,
       case clue_state
       when 'INVALID_PUBLIC_OLD_CLUE' then  '老学员'
       when 'VALID_NEW_CLUES'   then '新学员'
       when '未知'  then '其他'
       else null end as clue_state,
       scrm_department_id,
       superior_url,
       superior_source,
       landing_url,
       landing_source,
       info_url,
       info_source,
       origin_channel,
       course_id,
       course_name,
       zhuge_session_id,
       is_repeat,
       tenant,
       activity_id,
       activity_name,
       follow_type,
       shunt_mode_id,
       shunt_employee_group_id,
        dt as start_date,
       '9999-99-99'as end_date
from ods.t_customer_clue; -- 线索表

insert into table dwd.fact_customer_appeal partition (start_date)
select id,
       customer_relationship_first_id,
       employee_id,
       employee_name,
       employee_department_id,
       employee_tdepart_id,
       appeal_status,
       audit_id,
       audit_name,
       audit_department_id,
       audit_department_name,
       audit_date_time,
       create_date_time,
       update_date_time,
       deleted,
       tenant,
       dt as start_date,
       '9999-99-99'as end_date
from ods.t_customer_appeal; -- 申诉表

insert into table dwd.fact_customer_relationship partition (start_date)
select id,
       create_date_time,
       update_date_time,
       deleted,
       customer_id,
       first_id,
       belonger,
       belonger_name,
       initial_belonger,
       distribution_handler,
       business_scrm_department_id,
       last_visit_time,
       next_visit_time,
       case origin_type
       when 'NETSERVICE' then '线上'
       when 'PHONE'      then '线上'
       when 'OTHER'      then '线下'
       when 'VISITED'    then '线下'
       else null end as  origin_type,
       itcast_school_id,
       itcast_subject_id,
       intention_study_type,
       anticipat_signup_date,
       level,
       creator,
       current_creator,
       creator_name,
       case origin_channel when  '1'  then '介绍'
                          when   '2'  then  '不请自来'
                          else null
            end as origin_channel,
       comment,
       first_customer_clue_id,
       last_customer_clue_id,
       process_state,
       process_time,
       payment_state,
       payment_time,
       signup_state,
       signup_time,
       notice_state,
       notice_time,
       lock_state,
       lock_time,
       itcast_clazz_id,
       itcast_clazz_time,
       payment_url,
       payment_url_time,
       ems_student_id,
       delete_reason,
       deleter,
       deleter_name,
       delete_time,
       course_id,
       course_name,
       delete_comment,
       close_state,
       close_time,
       appeal_id,
       tenant,
       total_fee,
       belonged,
       belonged_time,
       belonger_time,
       transfer,
       transfer_time,
       follow_type,
       transfer_bxg_oa_account,
       transfer_bxg_belonger_name,
       dt as start_date,
       '9999-99-99'as end_date
from ods.t_customer_relationship; -- 意向表
