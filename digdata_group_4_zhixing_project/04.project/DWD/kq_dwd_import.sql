--设置动态分区的模式为  nonstrict非严格模式
set hive.exec.dynamic.partition.mode=nonstrict;

insert overwrite table zx_dwd.dim_class_studying_student_count
select *
from zx_ods.t_class_studying_student_count;


insert overwrite table zx_dwd.dim_course_table_upload_detail PARTITION(dt)
select id,
       base_id,
       class_id,
       class_date,
       content,
       teacher_id,
       teacher_name,
       job_number,
       classroom_id,
       classroom_name,
       is_outline,
       class_mode,
       is_stage_exam,
       is_pay,
       tutor_teacher_id,
       tutor_teacher_name,
       tutor_job_number,
       is_subsidy,
       answer_teacher_id,
       answer_teacher_name,
       answer_job_number,
       remark,
       create_time,
       dt
from zx_ods.t_course_table_upload_detail;

insert overwrite table zx_dwd.fact_student_leave_apply PARTITION(dt)
select id,
       class_id,
       student_id,
       audit_state,
       audit_person,
       audit_time,
       audit_remark,
       leave_type,
       leave_reason,
       begin_time,
       begin_time_type,
       end_time,
       end_time_type,
       days,
       cancel_state,
       cancel_time,
       old_leave_id,
       leave_remark,
       valid_state,
       create_time,
       dt
from zx_ods.t_student_leave_apply;

insert overwrite table zx_dwd.dim_tbh_class_time_table PARTITION(dt)
select id,
       class_id,
       morning_template_id,
       morning_begin_time,
       morning_end_time,
       afternoon_template_id,
       afternoon_begin_time,
       afternoon_end_time,
       evening_template_id,
       evening_begin_time,
       evening_end_time,
       use_begin_date,
       use_end_date,
       create_time,
       create_person,
       remark,
       dt
from zx_ods.t_tbh_class_time_table;

insert overwrite table zx_dwd.fact_tbh_student_signin_record PARTITION(dt)
select id,
       normal_class_flag,
       time_table_id,
       class_id,
       student_id,
       signin_time,
       signin_date,
       inner_flag,
       signin_type,
       share_state,
       inner_ip,
       dt
from zx_ods.t_tbh_student_signin_record;