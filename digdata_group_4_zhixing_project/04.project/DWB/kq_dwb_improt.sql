--设置动态分区的模式为  nonstrict非严格模式
set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table zx_dwb.dwb_leave_wide_table partition (dt)
select
        fsla.class_id,
        student_id,
        audit_state,
        begin_time_type,
        begin_time,
        end_time_type,
        end_time,
        cancel_state,
        valid_state,
        class_date,
        class_mode,
        content,
        morning_begin_time,
        morning_end_time,
        afternoon_begin_time,
        afternoon_end_time,
        evening_begin_time,
        evening_end_time,
        use_begin_date,
        use_end_date,
        fsla.dt
from zx_dwd.fact_student_leave_apply fsla
    left join zx_dwd.dim_course_table_upload_detail dctud
    on fsla.class_id = dctud.class_id
    left join zx_dwd.dim_tbh_class_time_table dtctt
    on fsla.class_id = dtctt.class_id
where cast(class_date as date) between cast(use_begin_date as date) and cast(use_end_date as date);


insert overwrite table zx_dwb.dwb_student_signin_wide_table partition (dt)
select tssr.id,
       tssr.normal_class_flag,
       tssr.time_table_id,
       tssr.class_id,
       tssr.student_id,
       tssr.signin_time,
       tssr.signin_date,
       tssr.inner_flag,
       tssr.signin_type,
       tssr.share_state,
       tssr.inner_ip,

       tctt.morning_begin_time,
       tctt.morning_end_time,
       tctt.afternoon_begin_time,
       tctt.afternoon_end_time,
       tctt.evening_begin_time,
       tctt.evening_end_time,
       tctt.use_begin_date,
       tctt.use_end_date,

       ctud.class_date,
       ctud.class_mode,

       cssc.studying_student_count,
       cssc.studying_date,
       '2021-10-07' as dt

from zx_dwd.fact_tbh_student_signin_record tssr
left join zx_dwd.dim_tbh_class_time_table tctt
on tssr.class_id = tctt.class_id
-- and cast(tssr.signin_date as date) between cast(tctt.use_begin_date as date) and cast(tctt.use_end_date as date)
left join zx_dwd.dim_course_table_upload_detail ctud
on tssr.class_id = ctud.class_id and tssr.signin_date=ctud.class_date
left join zx_dwd.dim_class_studying_student_count cssc
on tssr.class_id=cssc.class_id and ctud.class_date=cssc.studying_date
where cast(tssr.signin_date as date) between cast(tctt.use_begin_date as date) and cast(tctt.use_end_date as date);

