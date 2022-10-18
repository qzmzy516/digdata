drop table if exists zx_dwb.dwb_wide_table;
create table zx_dwb.dwb_wide_table
(
    --意向表
    id                          int comment '意向id',
    create_date_time            string comment '创建时间',
    update_date_time            string comment '最后更新时间',
    deleted                     string comment '是否被删除（禁用）',
    customer_id                 int comment '所属客户id',
    first_id                    int comment '第一条客户关系id',
    belonger                    int comment '归属人',
    belonger_name               string comment '归属人姓名',
    initial_belonger            int comment '初始归属人',
    distribution_handler        int comment '分配处理人',
    business_scrm_department_id int comment '归属部门',
    last_visit_time             string comment '最后回访时间',
    next_visit_time             string comment '下次回访时间',
    origin_type                 string comment '数据来源',
    itcast_school_id            int comment '校区Id',
    itcast_subject_id           int comment '学科Id',
    intention_study_type        string comment '意向学习方式',
    anticipat_signup_date       string comment '预计报名时间',
    level                       string comment '客户级别',
    creator                     int comment '创建人',
    current_creator             int comment '当前创建人：初始==创建人，当在公海拉回时为 拉回人',
    creator_name                string comment '创建者姓名',
    origin_channel              string comment '来源渠道',
    comment                     string,
    first_customer_clue_id      int comment '第一条线索id',
    last_customer_clue_id       int comment '最后一条线索id',
    process_state               string comment '处理状态',
    process_time                string comment '处理状态变动时间',
    payment_state               string comment '支付状态',
    payment_time                string comment '支付状态变动时间',
    signup_state                string comment '报名状态',
    signup_time                 string comment '报名时间',
    notice_state                string comment '通知状态',
    notice_time                 string comment '通知状态变动时间',
    lock_state                  string comment '锁定状态',
    lock_time                   string comment '锁定状态修改时间',
    itcast_clazz_id             int comment '所属ems班级id',
    itcast_clazz_time           string comment '报班时间',
    payment_url                 string comment '付款链接',
    payment_url_time            string comment '支付链接生成时间',
    ems_student_id              int comment 'ems的学生id',
    delete_reason               string comment '删除原因',
    deleter                     int comment '删除人',
    deleter_name                string comment '删除人姓名',
    delete_time                 string comment '删除时间',
    course_id                   int comment '课程ID',
    course_name                 string comment '课程名称',
    delete_comment              string comment '删除原因说明',
    close_state                 string comment '关闭装填',
    close_time                  string comment '关闭状态变动时间',
    appeal_id                   int comment '申诉id',
    tenant                      int comment '租户',
    total_fee                   string comment '报名费总金额',
    belonged                    int comment '小周期归属人',
    belonged_time               string comment '归属时间',
    belonger_time               string comment '归属时间',
    transfer                    int comment '转移人',
    transfer_time               string comment '转移时间',
    follow_type                 int comment '分配类型，0-自动分配，1-手动分配，2-自动转移，3-手动单个转移，4-手动批量转移，5-公海领取',
    transfer_bxg_oa_account     string comment '转移到博学谷归属人OA账号',
    transfer_bxg_belonger_name  string comment '转移到博学谷归属人OA姓名',
    --班级表
    banji_id                          int comment    '班级ID',
    itcast_school_name          string comment '校区名称',
    itcast_subject_name         string comment '学科名称',
    --线索表
    customer_relationship_id int    comment '客户关系id',
    clue_state               string comment '线索状态',
    --申诉表
    customer_relationship_first_id int comment '第一条客户关系id',
    appeal_status                  int comment '申诉状态，0:待稽核 1:无效 2：有效',
    --员工表
    yuangong_id                  int comment '员工id',
    tdepart_id          int comment '直属部门',
    --部门表
    bumen_id               int comment '部门id',
    name             string comment '部门名称'
)COMMENT '主题宽表'
PARTITIONED BY(dt STRING)
row format delimited fields terminated by '\t'
stored as textfile
tblproperties ('orc.compress' = 'SNAPPY');

insert into table zx_dwb.dwb_wide_table partition (dt)
select
    cr.id,
    cr.create_date_time,
    cr.update_date_time,
    cr.deleted,
    cr.customer_id,
    cr.first_id,
    cr.belonger,
    cr.belonger_name,
    cr.initial_belonger,
    cr.distribution_handler,
    cr.business_scrm_department_id,
    cr.last_visit_time,
    cr.next_visit_time,
    cr.origin_type,
    cr.itcast_school_id,
    cr.itcast_subject_id,
    cr.intention_study_type,
    cr.anticipat_signup_date,
    cr.level,
    cr.creator,
    cr.current_creator,
    cr.creator_name,
    cr.origin_channel,
    cr.comment,
    cr.first_customer_clue_id,
    cr.last_customer_clue_id,
    cr.process_state,
    cr.process_time,
    cr.payment_state,
    cr.payment_time,
    cr.signup_state,
    cr.signup_time,
    cr.notice_state,
    cr.notice_time,
    cr.lock_state,
    cr.lock_time,
    cr.itcast_clazz_id,
    cr.itcast_clazz_time,
    cr.payment_url,
    cr.payment_url_time,
    cr.ems_student_id,
    cr.delete_reason,
    cr.deleter,
    cr.deleter_name,
    cr.delete_time,
    cr.course_id,
    cr.course_name,
    cr.delete_comment,
    cr.close_state,
    cr.close_time,
    cr.appeal_id,
    cr.tenant,
    cr.total_fee,
    cr.belonged,
    cr.belonged_time,
    cr.belonger_time,
    cr.transfer,
    cr.transfer_time,
    cr.follow_type,
    cr.transfer_bxg_oa_account,
    cr.transfer_bxg_belonger_name,
    ic.id,
    ic.itcast_school_name,
    ic.itcast_subject_name,
    cc.customer_relationship_id,
    cc.clue_state,
    ca.customer_relationship_first_id,
    ca.appeal_status,
    e.id,
    e.tdepart_id,
    sd.id,
    sd.name,
    SUBSTR(cr.create_date_time,1,10) as dt --动态分区值
from zx_dwd.fact_customer_relationship cr
left join zx_dwd.dim_itcast_clazz ic on ic.id = cr.itcast_clazz_id and ic.end_date='9999-99-99'
left join zx_dwd.dim_customer_clue cc on cc.customer_relationship_id = cr.id and cc.end_date='9999-99-99'
left join zx_dwd.dim_customer_appeal ca on ca.customer_relationship_first_id = cr.id and ca.end_date='9999-99-99'
left join zx_dwd.dim_employee e on e.id = cr.creator and e.end_date='9999-99-99'
left join zx_dwd.dim_scrm_department sd on sd.id = e.tdepart_id
where cr.end_date='9999-99-99';

set hive.exec.mode.local.auto=false;
set hive.auto.convert.join=false;