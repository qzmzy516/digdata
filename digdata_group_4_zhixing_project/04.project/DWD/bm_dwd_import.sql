-- 客户意向拉链表
insert OVERWRITE TABLE zx_dwd.fact_customer_relationship partition (start_date)
select
    id,
    create_date_time,
    update_date_time,
    substr(a.update_date_time,1,4) as year,
    substr(a.update_date_time,6,2) as month,
    substr(a.update_date_time,9,1) as day,
    substr(a.update_date_time,1,7) as year_month,
    substr(a.update_date_time,1,10) as year_month_day,
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
       case when origin_type = 'NETSERVICE' OR origin_type = 'PRESIGNUP'
           then '线上'
           else '线下'
           end
    as origin_type,
    itcast_school_id,
    itcast_subject_id,
    intention_study_type,
    anticipat_signup_date,
    level,
    creator,
    current_creator,
    creator_name,
    origin_channel,
    comment,
    first_customer_clue_id,
    last_customer_clue_id,
    process_state,
    process_time,
        case when payment_state = 'PAID'
             then '已支付'
             else '未支付'
                 end
    as payment_state,
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
    '9999-99-99' as end_date,
    dt
from zx_ods.t_customer_relationship a;

-- dwd层 员工信息拉链表
insert into zx_dwd.dim_employee partition (start_date)
select
        id,
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
        substr(a.update_date_time,1,4) as year,
        substr(a.update_date_time,6,2) as month ,
        substr(a.update_date_time,9,1) as day,
        substr(a.update_date_time,1,7) as year_month,
        substr(a.update_date_time,1,10) as year_month_day,
        deleted,
        scrm_department_id,
        leave_office,
        leave_office_time,
        reinstated_time,
        superior_leaders_id,
        tdepart_id,
        tenant,
        ems_user_name,
        '9999-99-99' as end_date,
        dt
from zx_ods.t_employee a;

- dwd层 部门信息表
insert overwrite table zx_dwd.dim_scrm_department partition (dt)
select
    id,
    name,
    parent_id,
    create_date_time,
    update_date_time,
    deleted,
    id_path,
    tdepart_code,
    creator,
    depart_level,
    depart_sign,
    depart_line,
    depart_sort,
    disable_flag,
    tenant,
    dt
from zx_ods.t_scrm_department;

-- dwd层 校区信息表
insert overwrite table zx_dwd.dim_itcast_school partition (dt)
select
    id,
    create_date_time,
    update_date_time,
    deleted,
    name,
    code,
    tenant,
    dt
from zx_ods.t_itcast_school;

-- dwd层 学科信息表
insert overwrite table zx_dwd.dim_itcast_subject partition (dt)
select
    id,
    create_date_time,
    update_date_time,
    deleted,
    name,
    code,
    tenant,
    dt
from zx_ods.t_itcast_subject;

-- 申诉拉链表
insert overwrite table zx_dwd.dim_customer_appeal partition (start_date)
select
    id,
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
    substr(a.update_date_time,1,4) as year,
    substr(a.update_date_time,6,2) as month,
    substr(a.update_date_time,9,1) as day,
    substr(a.update_date_time,1,7) as year_month,
    substr(a.update_date_time,1,10) as year_month_day,
    deleted,
    tenant,
    '9999-99-99' as end_date,
    dt
from zx_ods.t_customer_appeal a;
--线索拉链表
insert overwrite table zx_dwd.dim_customer_clue partition (start_date)
select
    id,
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
    clue_state,
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
    '9999-99-99' as end_date,
    dt
from zx_ods.t_customer_clue;
