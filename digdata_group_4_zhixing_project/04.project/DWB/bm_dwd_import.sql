-- - 数据导入
insert overwrite table zx_dwb.dwb_relationship_wide partition (dt)
select
        fcr.id,
        fcr.create_date_time,
        fcr.update_date_time,
        fcr.year,
        fcr.month,
        fcr.day,
        fcr.year_month,
        fcr.year_month_day,
        fcr.deleted,
        fcr.origin_type,
        fcr.itcast_school_id,
        sch.name as school_name,
        fcr.itcast_subject_id,
        sub.name as subject_name,
        fcr.anticipat_signup_date,
        fcr.level,
        fcr.creator,
        fcr.current_creator,
        fcr.creator_name,
        department_name,
        fcr.origin_channel,
        fcr.comment,
        fcr.first_customer_clue_id,
        fcr.last_customer_clue_id,
        fcr.payment_state,
        fcr.payment_time,
        fcr.itcast_clazz_id,
        fcr.itcast_clazz_time,
        appeal_status,
        fcr.appeal_id,
        customer_relationship_first_id,
        fcr.start_date as dt
from (select * from zx_dwd.fact_customer_relationship where end_date = '9999-99-99' and deleted = 'false') fcr
left join zx_dwd.dim_itcast_school sch on fcr.itcast_school_id = sch.id
left join zx_dwd.dim_itcast_subject sub on fcr.itcast_subject_id = sub.id
left join zx_dwd.dim_employee emp on fcr.creator = emp.id and emp.end_date = '9999-99-99'
left join zx_dwd.dim_scrm_department dep on emp.tdepart_id = dep.id
left join zx_dwd.dim_customer_clue clue on fcr.id = clue.customer_relationship_id and clue.end_date = '9999-99-99'
left join zx_dwd.dim_customer_appeal apel on fcr.id = apel.customer_relationship_first_id and apel.end_date = '9999-99-99';
