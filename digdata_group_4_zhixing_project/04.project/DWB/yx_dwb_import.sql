insert into dwb.original_wide_table
select
    fcr.id,
    fcr.create_date_time,
    fcr.update_date_time,
    fcr.deleted,
    fcr.customer_id,
    fcr.first_id,
    fcr.belonger,
    fcr.belonger_name,
    fcr.initial_belonger,
    fcr.distribution_handler,
    fcr.business_scrm_department_id,
    fcr.last_visit_time,
    fcr.next_visit_time,
    fcr.origin_type,
    fcr.itcast_school_id,
    fcr.itcast_subject_id,
    fcr.intention_study_type,
    fcr.anticipat_signup_date,
    fcr.level,
    fcr.creator,
    fcr.current_creator,
    fcr.creator_name,
    fcr.origin_channel,
    fcr.comment,
    fcr.first_customer_clue_id,
    fcr.last_customer_clue_id,
    fcr.process_state,
    fcr.process_time,
    fcr.payment_state,
    fcr.payment_time,
    fcr.signup_state,
    fcr.signup_time,
    fcr.notice_state,
    fcr.notice_time,
    fcr.lock_state,
    fcr.lock_time,
    fcr.itcast_clazz_id,
    fcr.itcast_clazz_time,
    fcr.payment_url,
    fcr.payment_url_time,
    fcr.ems_student_id,
    fcr.delete_reason,
    fcr.deleter,
    fcr.deleter_name,
    fcr.delete_time,
    fcr.course_id,
    fcr.course_name,
    fcr.delete_comment,
    fcr.close_state,
    fcr.close_time,
    fcr.appeal_id,
    fcr.tenant,
    fcr.total_fee,
    fcr.belonged,
    fcr.belonged_time,
    fcr.belonger_time,
    fcr.transfer,
    fcr.transfer_time,
    fcr.follow_type,
    fcr.transfer_bxg_oa_account,
    fcr.transfer_bxg_belonger_name,
    dcc.customer_relationship_id,
    dcc.clue_state,
    dis.name as school_name,
    dis2.name as subject_name,
    dc.area as customer_area,
    dsd.name as department_name,
   year(fcr.create_date_time) as year_code, -- 年
    day(fcr.create_date_time) as day_code, -- 天
   month (fcr.create_date_time) as month_code,-- 月
    hour(fcr.create_date_time) as hour_code-- 小时



from dwd.fact_customer_relationship fcr --意向主表
left join dwd.dim_customer dc -- 学员表--地区维度
on fcr.customer_id = dc.id and dc.end_date = '9999-99-99'
left join dwd.dim_customer_clue dcc  -- 线索信息表-- 新老学员维度
on fcr.id = dcc.customer_relationship_id and dcc.end_date = '9999-99-99'
left join dwd.dim_itcast_school dis -- 校区表 -- 校区维度
on fcr.itcast_school_id = dis.id
left join dwd.dim_itcast_subject dis2  -- 学科表 -- 学科维度
on fcr.itcast_subject_id = dis2.id
left join dwd.dim_employee de -- 员工表
on fcr.creator = de.id and de.end_date = '9999-99-99'
left join   dwd.dim_scrm_department dsd  -- 部门表
on de.tdepart_id = dsd.id
where fcr.end_date = '9999-99-99'
limit 2000;-- dwb宽表插入语句